# encoding=utf-8

import os, re, subprocess
import markdown, shortuuid, pymysql
import json, time

from launcher.model import k8s as k8sMdl
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


def other_config(params):
  settingsMdl.domain = {
    'domain': params.get('domain', ''),
    'subDomain': params.get('subDomain', {})
  }

  settingsMdl.other = {
    'manager': params.get('manager'),
    'tls': params.get('tls')
  }

  return True


def config_template():
  result = []

  for ns in SERVICECONFIG['services']:
    configmaps = {
      'namespace': ns['namespace'],
      'configmaps': []
    }

    tmpServiceDict = {item['key']: item for item in ns['services']}

    for configmap in ns['configmaps']:
      content = jinjia2_render('template/config/{}'.format(configmap['file']), settingsMdl.toJson)

      cm = {
        'key': configmap['key'],
        'content': content,
        'services': [tmpServiceDict[item]['name'] for item in configmap['services']]
      }
      configmaps['configmaps'].append(cm)

    result.append(configmaps)

  return result


def certificate_create():
  tlsSetting = settingsMdl.other.get('tls')

  certificate = dict(
              privateKey = tlsSetting['certificatePrivateKey'],
              content = tlsSetting['certificateContent']
          )
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

  k8sMdl.apply_namespace()

  namespaces = SERVICECONFIG['namespaces']
  for ns in namespaces:
    cmd = "kubectl create secret tls {} --cert='{}' --key='{}' -n {}".format(domain, certFile, certKeyFile, ns)
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  return True


def configmap_create(maps):
  tmpDir = SERVICECONFIG['tmpDir']
  tmpPath = tmpDir + "/configmap.yaml"
  configmap = jinjia2_render('template/k8s/configmap.yaml', {"config": maps})

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

  d['images'] = services
  d['storageNames'] = _get_storageclass()

  return d


def ingress_create():
  tmpDir = SERVICECONFIG['tmpDir']
  ingressTemplate = jinjia2_render("template/k8s/ingress.yaml", {"config": settingsMdl})
  ingressYaml = os.path.abspath(tmpDir + "/ingress.yaml")

  with open(ingressYaml, 'w') as f:
    f.write(ingressTemplate)

  # 创建所有 deployment & service
  cmd = "kubectl apply -f {}".format(ingressYaml)
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  return True


def _get_storageclass():
  cmd = "kubectl get storageclass -o json"
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  output, err = p.communicate()
  storage = json.loads(output)

  storageNames = []
  for item in storage['items']:
    storageNames.append(item['metadata']['name'])

  return storageNames


def _registry_secret_create(registry, user, pwd):
  patch = { "imagePullSecrets": [{"name": "registry-key"}] }
  for ns in SERVICECONFIG['namespaces']:
    cmd = 'kubectl create secret docker-registry registry-key --docker-server={} --docker-username={} --docker-password={} -n {}'.format(registry, user, pwd, ns)
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

    cmd = "kubectl patch sa default -p '{}' -n {}".format(json.dumps(patch), ns)
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  return True


def _PVC_create(storageClassName):
  tmpDir = SERVICECONFIG['tmpDir']
  pvcYaml = jinjia2_render("template/k8s/pvc.yaml", {"storageClassName": storageClassName})
  path = os.path.abspath(tmpDir + "/pvc.yaml")

  with open(os.path.abspath(path), 'w') as f:
    f.write(pvcYaml)

  cmd = "kubectl apply  -f {}".format(path)
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  return True


def service_create(data):
  tmpDir = SERVICECONFIG['tmpDir']
  appYamls = []

  imageRegistry = data.get('imageRegistry') or ''
  imageDir = data.get('imageDir') or ''
  imageRegistryUser = data.get('imageRegistryUser') or ''
  imageRegistryPwd = data.get('imageRegistryPwd') or ''
  storageClassName = data.get('storageClassName') or ''
  images = data.get('images', {})

  imageSettings = {
    "imageRegistry": imageRegistry,
    "imageDir": imageDir,
    "images": {}
  }

  _registry_secret_create(imageRegistry, imageRegistryUser, imageRegistryPwd)
  _PVC_create(storageClassName)

  for key, val in images.items():
    imagePath = '{}/{}/{}'.format(imageRegistry, imageDir, val.get('imagePath') or '')
    val['fullImagePath'] = re.sub('/+', '/', imagePath)

    serviceYaml = jinjia2_render("template/k8s/app-{}.yaml".format(key), {"config": val})
    path = os.path.abspath(tmpDir + "/app-{}.yaml".format(key))

    with open(path, 'w') as f:
      f.write(serviceYaml)
      appYamls.append(path)

    imageSettings['images'][key] = val

  # 创建所有 deployment & service
  cmd = "kubectl apply -f {}".format(' -f '.join(appYamls))
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  ingress_create()

  return True


def redeploy_all():
  for ns in SERVICECONFIG['services']:
    namespace = ns['namespace']

    for deploy in ns['services']:
      k8sMdl.redeploy(deploy['key'], namespace)

  return True


def service_status():
  return k8sMdl.deploy_status()


def init_setting():
  settingsMdl.other = {
    "core": {
      "secret": {
        "frontAuth": shortuuid.ShortUUID().random(length=48),
        "manageAuth": shortuuid.ShortUUID().random(length=48),
        "shareAuth": shortuuid.ShortUUID().random(length=48)
      }
    },
    'func': {
      "secret": shortuuid.ShortUUID().random(length=48)
    }
  }

  return True
