# encoding=utf-8

import requests
import os, re, subprocess
import markdown, shortuuid, pymysql
import json, time

from launcher.model import k8s as k8sMdl
from launcher.model import version as versionMdl
from launcher.utils.template import jinjia2_render

from launcher import settingsMdl, SERVICECONFIG, DOCKERIMAGES


def do_check():
  cmd = "kubectl cluster-info"
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  output, err = p.communicate()
  namespace = json.loads(output)

  return {"status": "check OK"}


def readme():
  with open(os.path.abspath("launcher/templates/README.md"), 'r') as f:
    readme = f.read()
    return markdown.markdown(readme)

  return ""


def aksk_save(params):
  settingsMdl.other = {
    'cc': params.get('cc', {}),
    'dail': params.get('dail', {}),
  }

  return True


def other_config(params):
  settingsMdl.domain = {
    'domain': params.get('domain', ''),
    'subDomain': params.get('subDomain', {})
  }

  settingsMdl.other = {
    'manager': params.get('manager'),
    'tls': params.get('tls'),
    'nodeInternalIP': params.get('nodeInternalIP')
  }

  return True


def get_node_internal_ip():
  return '; '.join(k8sMdl.get_node_internal_ip())


def config_template():
  result = []

  for ns in SERVICECONFIG['services']:
    configmaps = {
      'namespace': ns['namespace'],
      'configmaps': []
    }

    tmpServiceDict = {item['key']: item for item in ns['services']}

    for configmap in ns['configmaps']:
      hasRef = False
      for service in configmap['services']:
        enabled = not tmpServiceDict[service].get('deleted', False)
        replicas = tmpServiceDict[service]['replicas']

        hasRef = enabled and replicas > 0

        if hasRef:
          break

      if not hasRef:
        continue

      content = jinjia2_render('template/config/{}'.format(configmap['template']), settingsMdl.toJson)
      cm = {
        'key': configmap['key'],
        'content': content,
        'services': [tmpServiceDict[item]['name'] for item in configmap['services']]
      }
      configmaps['configmaps'].append(cm)

    result.append(configmaps)

  return result


def certificate_create():
  k8sMdl.apply_namespace()
  k8sMdl.certificate_create_all_namespace()

  # tlsSetting = settingsMdl.other.get('tls')
  #
  # certificate = dict(
  #             privateKey = tlsSetting['certificatePrivateKey'],
  #             content = tlsSetting['certificateContent'],
  #             disabled = tlsSetting['tlsDisabled']
  #         )
  #
  # if not certificate["privateKey"] or not certificate["content"]:
  #   return True
  #
  # domain = settingsMdl.domain.get('domain')
  #
  # tmpPath = SERVICECONFIG['tmpDir']
  # certFile = '{}/tls.cert'.format(tmpPath)
  # certKeyFile = '{}/tls.key'.format(tmpPath)
  #
  # if not os.path.exists(tmpPath):
  #   os.mkdir(tmpPath)
  #
  # with open(os.path.abspath(certFile), 'w') as f:
  #   f.write(certificate['content'])
  #
  # with open(os.path.abspath(certKeyFile), 'w') as f:
  #   f.write(certificate['privateKey'])
  #
  # k8sMdl.apply_namespace()
  #
  # namespaces = SERVICECONFIG['namespaces']
  # for ns in namespaces:
  #   cmd = "kubectl create secret tls {} --cert='{}' --key='{}' -n {}".format(domain, certFile, certKeyFile, ns)
  #   p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  return True


def _configmap_to_template_data(maps):
  result = []

  for ns in SERVICECONFIG['services']:
    configmaps = ns["configmaps"]
    namespace  = ns['namespace']

    for cm in configmaps:
      key     = cm['key']
      mapname = cm['mapname']
      mapkey  = cm['mapkey']

      item = dict(
                namespace = namespace,
                key       = key,
                mapname   = mapname,
                mapkey    = mapkey,
                content   = maps.get(key, '')
              )

      result.append(item)

  return result


def configmap_create(maps):
  tmpDir  = SERVICECONFIG['tmpDir']
  tmpPath = tmpDir + "/configmap.yaml"

  configmap = jinjia2_render('template/k8s/configmap.yaml', {"config": _configmap_to_template_data(maps)})

  if not os.path.exists(tmpDir):
    os.mkdir(tmpDir)

  try:
    with open(os.path.abspath(tmpPath), 'w') as f:
      f.write(configmap)

    k8sMdl.apply_namespace()

    cmd = "kubectl apply  -f {}".format(tmpPath)
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
  except Exception as e:
    print(e)
    return False

  return True


# 服务镜像配置
def service_image_config():
  # 使用 docker-image.yaml 中的镜像列表
  apps = DOCKERIMAGES.get('apps', {})
  imageDir = apps.get('image_dir', '')
  defaultImage  = apps.get('images', {})

  d = {
    "imageRegistry": apps.get('registry', ''),
    "imageDir": imageDir,
    "images": []
  }

  services = SERVICECONFIG['services']
  for ns in services:
    for item in ns['services']:
      if 'image' in item:
        item['imagePath'] = defaultImage.get(item['image'], '')

      item['replicas'] = item.get('replicas', 1)

      if SERVICECONFIG['debug'] and item['replicas'] != 0:
        item['replicas'] = 1

  d['images'] = services
  d['storageNames'] = k8sMdl.get_storageclass()

  return d


# def ingress_create():
#   tmpDir = SERVICECONFIG['tmpDir']
#   ingressTemplate = jinjia2_render("template/k8s/ingress.yaml", {"config": settingsMdl})
#   ingressYaml = os.path.abspath(tmpDir + "/ingress.yaml")

#   with open(ingressYaml, 'w') as f:
#     f.write(ingressTemplate)

#   # 创建所有 ingress
#   cmd = "kubectl apply -f {}".format(ingressYaml)
#   p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

#   return True


def _registry_secret_create(registrySetting):
  for ns in SERVICECONFIG['namespaces']:
    k8sMdl.registry_secret_create(ns, **registrySetting)

  return True


def _PVC_list():
  result = []

  for ns in SERVICECONFIG['services']:
    namespace = ns['namespace']

    for pvc in ns.get('pvcs', []):
      result.append(dict(
          namespace = namespace,
          name      = pvc['name'],
          storage   = pvc['storage']
        ))

  return result


def _PVC_create(storageClassName):
  tmpDir = SERVICECONFIG['tmpDir']
  pvcYaml = jinjia2_render("template/k8s/pvc.yaml", {"pvcs": _PVC_list(),  "storageClassName": storageClassName})
  path = os.path.abspath(tmpDir + "/pvc.yaml")

  with open(os.path.abspath(path), 'w') as f:
    f.write(pvcYaml)

  cmd = "kubectl apply  -f {}".format(path)
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  return True


def service_create(data):
  tmpDir = SERVICECONFIG['tmpDir']
  appYamls = []

  imageDir = data.get('imageDir') or ''
  storageClassName = data.get('storageClassName') or ''
  images = data.get('images', {})

  registrySecrets = k8sMdl.registry_secret_get('launcher', 'registry-key')
  
  registry      = registrySecrets[0]
  registryAddr  = registry.get('address') or ''
  registryUser  = registry.get('username') or ''
  registryPwd   = registry.get('password') or ''

  imageSettings = {
    "imageRegistry": registryAddr,
    "imageDir": imageDir,
    "images": {}
  }

  settingsMdl.registry = {
    "server": registryAddr,
    "username": registryUser,
    "password": registryPwd
  }

  settingsMdl.other = {
    "storageClassName": storageClassName
  }

  _registry_secret_create(settingsMdl.registry)
  _PVC_create(storageClassName)

  for key, val in images.items():
    imagePath = '{}/{}/{}'.format(registryAddr, imageDir, val.get('imagePath') or '')
    val['fullImagePath'] = re.sub('/+', '/', imagePath)

    # 0 副本的服务，不创建
    if val.get('replicas', 1) == 0:
      continue

    serviceYaml = jinjia2_render("template/k8s/app-{}.yaml".format(key), {"config": val})
    path = os.path.abspath(tmpDir + "/app-{}.yaml".format(key))

    with open(path, 'w') as f:
      f.write(serviceYaml)
      appYamls.append(path)

    imageSettings['images'][key] = val

  # 创建所有 deployment & service
  cmd = "kubectl apply -f {}".format(' -f '.join(appYamls))
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  k8sMdl.ingress_apply()

  return True


def redeploy_all():
  for ns in SERVICECONFIG['services']:
    namespace = ns['namespace']

    for deploy in ns['services']:
      k8sMdl.redeploy(deploy['key'], namespace)

  return True


def service_status():
  return k8sMdl.deploy_status()


def save_version():
  # version        = DOCKERIMAGES['version']
  try:
    projects = [item['project'] for item in SERVICECONFIG['updates']]
    projectLastSeq = versionMdl.get_project_last_seq(projects + ['launcher'])

    for project, seq in projectLastSeq.items():
      versionMdl.save_version(project, 'database', seq)
      versionMdl.save_version(project, 'config', seq)
  except:
    return False

  return True


# 初始化工作空间的 ES 
def elasticsearch_init():
  headers = {"Content-Type": "application/json"}

  resp = requests.post("http://inner.forethought-core:5000/api/v1/inner/es/init", headers = headers)

  return { "status_code": resp.status_code }


def workspace_init():
  headers = {"Content-Type": "application/json"}

  data = {
    "workspaceSet": {
      "name": "系统工作空间",
      "token": settingsMdl.other["workspace"]["token"]
    }
  }
  resp = requests.post("http://inner.forethought-core:5000/api/v1/inner/system/init", json = data, headers = headers)

  return { "status_code": resp.status_code }


def sync_integration():
  headers = {"Content-Type": "application/json"}

  data = {
    "script_name": "fix_update_integration"
  }

  resp = requests.post("http://inner.forethought-core:5000/api/v1/inner/upgrade/fix_data", json = data, headers = headers)

  return { "status_code": resp.status_code }


def init_setting():
  settingsMdl.other = {
    "core": {
      "secret": {
        "frontAuth": shortuuid.ShortUUID().random(length=31),
        "manageAuth": shortuuid.ShortUUID().random(length=31),
        "shareAuth": shortuuid.ShortUUID().random(length=31),
        "encryptKey": shortuuid.ShortUUID().random(length=31)
      }
    },
    'func': {
      "secret": shortuuid.ShortUUID().random(length=31)
    }
  }

  return True
