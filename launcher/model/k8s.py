# encoding=utf-8

import os, re, subprocess, time
import markdown, shortuuid
import json, yaml

from launcher.utils.template import jinjia2_render

from launcher import SERVICECONFIG, DOCKERIMAGES


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

      tempStatus[key] = status

  deployStatus = []
  for ns in SERVICECONFIG['services']:
    ds = {
      "namespace": ns["namespace"],
      "services": []
    }
    for service in ns['services']:
      key = service['key']
      name = service['name']

      if key in tempStatus:
          tempStatus[key]['name'] = name
          tempStatus[key]['imageKey'] = service['image']

          ds["services"].append(tempStatus[key])
      else:
          ds["services"].append({
                  'key': key,
                  'name': name,
                  'imageKey': service['image'],
                  'replicas': 0,
                  'availableReplicas': 0
              })

    deployStatus.append(ds)

  return deployStatus


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
                  namespace = ns,
                  name = item['metadata']['name'],
                  storageClassName = item['spec']['storageClassName']
                )

      pvcs.append(pvc)

  return pvcs


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


def get_configmap(mapName, namespace):
  cmd = 'kubectl get configmap {} -n {} -o json'.format(mapName, namespace)

  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  output, err = p.communicate()
  result = json.loads(output)

  return result.get('data') or {}


def redeployment(deployName, namespace):
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

