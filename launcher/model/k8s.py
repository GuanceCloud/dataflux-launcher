# encoding=utf-8

import os, re, subprocess, time
import markdown, shortuuid
import json, yaml, base64

from launcher.utils.template import jinjia2_render

from launcher import settingsMdl, SERVICECONFIG, DOCKERIMAGES


def deploy_status():
  namespaces = SERVICECONFIG['namespaces']

  tempStatus = {}
  for ns in namespaces:
    cmd = 'kubectl get deployments -n {} -o json'.format(ns)
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

    output, err = p.communicate()
    deploys = json.loads(output)

    for item in deploys['items']:
      key = item['metadata']['name']
      image = item['spec']['template']['spec']['containers'][0]['image']

      status = {}
      # if 'conditions' in item['status']:
      #   status = {c['type']: c['status'] for c in item['status']['conditions']}

      status['fullImagePath'] = image
      status['key'] = key
      status['replicas'] = item['status'].get('replicas', 0)
      status['availableReplicas'] = item['status'].get('availableReplicas', 0)
      status['unavailableReplicas'] = item['status'].get('unavailableReplicas', 0)

      tempStatus[key] = status

  deployStatus = []
  for ns in SERVICECONFIG['services']:
    ds = {
      "namespace": ns["namespace"],
      "services": []
    }
    for service in ns['services']:
      key      = service['key']
      name     = service['name']
      disabled = service.get('deleted', False)
      replicas = service.get('replicas', 1)

      if SERVICECONFIG['debug'] and replicas != 0:
        replicas = 1

      if disabled:
        # 已经下线的服务，不做删除，只是将副本数设为0
        replicas = 0

      if key in tempStatus:
          tempStatus[key]['replicas'] = replicas
          tempStatus[key]['name'] = name
          tempStatus[key]['imageKey'] = service['image']
          tempStatus[key]['disabled'] = disabled

          ds["services"].append(tempStatus[key])
      else:
          ds["services"].append({
                  'key': key,
                  'name': name,
                  'imageKey': service['image'],
                  'replicas': replicas,
                  'availableReplicas': 0,
                  'unavailableReplicas': 0,
                  'disabled': disabled
              })

    deployStatus.append(ds)

  return deployStatus


def __ingress_1_yaml():
  tmpDir = SERVICECONFIG['tmpDir']
  ingressTemplate = jinjia2_render("template/k8s/ingress_v1.yaml", {"config": settingsMdl})
  ingressYaml = os.path.abspath(tmpDir + "/ingress_v1.yaml")

  with open(ingressYaml, 'w') as f:
    f.write(ingressTemplate)

  return ingressYaml


def __ingress_latest_yaml():
  tmpDir = SERVICECONFIG['tmpDir']
  ingressTemplate = jinjia2_render("template/k8s/ingress.yaml", {"config": settingsMdl})
  ingressYaml = os.path.abspath(tmpDir + "/ingress.yaml")

  with open(ingressYaml, 'w') as f:
    f.write(ingressTemplate)

  return ingressYaml


def __do_ingress_apply(ingressYaml):
  # 创建所有 ingress
  cmd = "kubectl apply -f {}".format(ingressYaml)
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True, stderr=subprocess.STDOUT)
  output, err = p.communicate()

  return str(output or b"", encoding = "utf-8")


def ingress_apply():
  kind_version_error_re = r".*no\s*matches\s*for\s*kind"

  ingressYaml = __ingress_latest_yaml()
  result = __do_ingress_apply(ingressYaml)

  if re.match(kind_version_error_re, result, flags = re.S) != None:
    # unable to recognize "ingress. vaml": no matches for kind "Ingress" in version "networking.k8s.i0/v1"
    # 如何检测到不支持 networking.k8s.i0/v1 这个 apiVersion 的错误
    # 换成 extensions/v1beta1 版本的重新创建 Ingress
    ingressYaml = __ingress_1_yaml()
    result = __do_ingress_apply(ingressYaml)

  success = (re.match(r".*ingress.+(configured)|(unchanged)", result, flags = re.S) != None)

  return success


def get_namespace():
  cmd = "kubectl get namespaces {} -o json".format(' '.join(SERVICECONFIG['namespaces']))
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  output, err = p.communicate()
  namespace = json.loads(output)

  return [ns['metadata']['name'] for ns in namespace['items']]


def get_pvc():
  pvcs = []
  for ns in SERVICECONFIG['namespaces']:
    cmd = "kubectl get pvc -n {} -o json".format(ns)
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

    output, err = p.communicate()
    data = json.loads(output)

    for item in data['items']:
      pvc = dict(
                  namespace         = ns,
                  name              = item['metadata']['name'],
                  storageClassName  = item['spec']['storageClassName'],
                  storage           = item['spec']['resources']['requests']['storage']
                )

      pvcs.append(pvc)

  return pvcs


def get_node_internal_ip():
  cmd = 'kubectl get nodes -o json'

  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  output, err = p.communicate()
  result = json.loads(output)

  ips = []
  nodeItems = result.get('items') or []
  for node in nodeItems:
    addresses = node.get('status', {}).get('addresses') or []

    for addr in addresses:
      if addr.get('type', '') == 'InternalIP':
        ip = addr.get('address')

        if ip:
          ips.append(ip)

  return ips


def get_storageclass():
  cmd = "kubectl get storageclass -o json"
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  output, err = p.communicate()
  storage = json.loads(output)

  storageNames = []
  for item in storage['items']:
    storageNames.append(item['metadata']['name'])

  return storageNames

def list_ingressclasses():
  result = subprocess.run(f"kubectl get ingressclasses -o json", shell=True, check=True, capture_output=True)
  items = json.loads(result.stdout.decode()).get('items')
  return [item['metadata']['name'] for item in items]

def apply_namespace():
  tmpDir = SERVICECONFIG['tmpDir']
  namespaces = SERVICECONFIG['namespaces']

  namespaceTemplatePath = "template/k8s/namespace.yaml"
  namespaceYamlContent = jinjia2_render(namespaceTemplatePath, {"namespaces": namespaces})
  namespaceYamlPath = os.path.abspath(tmpDir + "/namespace.yaml")

  with open(namespaceYamlPath, 'w') as f:
    f.write(namespaceYamlContent)

  # 必须要等命名空间创建完，才能继续后续操作
  for i in range(5):
    cmd = "kubectl apply -f {}".format(tmpDir + "/namespace.yaml")
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

    # 等待 namespace 创建完成
    for j in range(5):
      k8sNamespaces = get_namespace()

      if len(k8sNamespaces) == len(namespaces):
        break

      time.sleep(0.5)
    else:
      break

  return True


def get_configmap_list(namespace):
  cmd = 'kubectl get configmap -n {} -o json'.format(namespace)

  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  output, err = p.communicate()

  result = json.loads(output)

  return result.get('items') or []


def get_configmap(mapName, namespace):
  cmd = 'kubectl get configmap {} -n {} -o json'.format(mapName, namespace)

  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  output, err = p.communicate()

  result = json.loads(output)

  return result.get('data') or {}


def redeploy(deployName, namespace):
  patchJson = '{\\"spec\\": {\\"template\\": {\\"metadata\\": {\\"labels\\": {\\"redeploy\\": \\"$(date +%s)\\"} } } } }'

  cmd = 'kubectl patch deployment {} -p "{}" -n {}'.format(deployName, patchJson, namespace)

  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  output, err = p.communicate()

  return True


def patch_configmap(mapName, mapKey, content, namespace):
  patchYaml = yaml.dump({
    'data': {
      mapKey: content
    }}, default_flow_style = False)

  if not os.path.exists("/tmp/k8s"):
    os.mkdir("/tmp/k8s")

  path = "/tmp/k8s/{}-configmap-patch.yaml".format(mapName)

  with open(path, 'w') as f:
    f.write(patchYaml)

  cmd = 'kubectl patch configmap {} -p "$(cat {})" -n {}'.format(mapName, path, namespace)

  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  output, err = p.communicate()

  os.remove(path)

  return output, err


def registry_secret_get(namespace, registryKeyName):
  cmd = "kubectl get secret {} -n {} -o json".format(registryKeyName, namespace)
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  output, err = p.communicate()
  secretJson  = json.loads(output)

  dockerConfigJson = base64.b64decode(secretJson['data']['.dockerconfigjson'])
  dockerConfig     = json.loads(dockerConfigJson)
  auths            = dockerConfig['auths']  

  result = []
  for key, val in auths.items():
    result.append({
        "address": key,
        "username": val['username'],
        "password": val['password']
      })

  return result


# 创建镜像凭证
def registry_secret_create(namespace, server, username, password):
  patch = { "imagePullSecrets": [{"name": "registry-key"}] }

  cmd = 'kubectl create secret docker-registry registry-key --docker-server={} --docker-username={} --docker-password={} -n {}'.format(server, username, password, namespace)
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  cmd = "kubectl patch sa default -p '{}' -n {}".format(json.dumps(patch), namespace)
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  return True


# 创建 TLS 证书
def certificate_create(namespace):
  tlsSetting = settingsMdl.other.get('tls')

  certificate = dict(
              privateKey = tlsSetting.get('certificatePrivateKey', ''),
              content = tlsSetting.get('certificateContent', ''),
              disabled = tlsSetting.get('tlsDisabled', False)
          )

  if not certificate["privateKey"] or not certificate["content"]:
    return True

  domain = settingsMdl.domain.get('domain')

  tmpPath = SERVICECONFIG['tmpDir']
  certFile = '{}/tls.cert'.format(tmpPath)
  certKeyFile = '{}/tls.key'.format(tmpPath)

  if not os.path.exists(tmpPath):
    os.mkdir(tmpPath)

  with open(os.path.abspath(certFile), 'w') as f:
    f.write(certificate['content'])

  with open(os.path.abspath(certKeyFile), 'w') as f:
    f.write(certificate['privateKey'])

  cmd = "kubectl create secret tls {} --cert='{}' --key='{}' -n {}".format(domain, certFile, certKeyFile, namespace)
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  return True


# 创建 TLS 证书
def certificate_create_all_namespace():
  tlsSetting = settingsMdl.other.get('tls')

  certificate = dict(
              privateKey = tlsSetting['certificatePrivateKey'],
              content = tlsSetting['certificateContent'],
              disabled = tlsSetting['tlsDisabled']
          )

  if not certificate["privateKey"] or not certificate["content"]:
    return True

  domain = settingsMdl.domain.get('domain')

  tmpPath = SERVICECONFIG['tmpDir']
  certFile = '{}/tls.cert'.format(tmpPath)
  certKeyFile = '{}/tls.key'.format(tmpPath)

  if not os.path.exists(tmpPath):
    os.mkdir(tmpPath)

  with open(os.path.abspath(certFile), 'w') as f:
    f.write(certificate['content'])

  with open(os.path.abspath(certKeyFile), 'w') as f:
    f.write(certificate['privateKey'])

  # apply_namespace()

  namespaces = SERVICECONFIG['namespaces']
  for ns in namespaces:
    cmd = "kubectl create secret tls {} --cert='{}' --key='{}' -n {} --dry-run -o yaml | kubectl apply -f -".format(domain, certFile, certKeyFile, ns)
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  return True

