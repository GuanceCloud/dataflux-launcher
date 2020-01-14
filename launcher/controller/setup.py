# encoding=utf-8

import os, re, subprocess
import markdown, shortuuid, pymysql
import json, time

from launcher.model import k8s
from launcher.utils.template import jinjia2_render

from launcher import SETTINGS, SERVICECONFIG, DOCKERIMAGES


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
  SETTINGS['other'] = params

  return True


def config_template():
  coreTemp = jinjia2_render('template/config/forethought-backend.yaml', SETTINGS)
  kodoTemp = jinjia2_render('template/config/kodo.yaml', SETTINGS)
  kodoInnerTemp = jinjia2_render('template/config/kodo-inner.yaml', SETTINGS)
  kodoNginxTemp = jinjia2_render('template/config/kodo-nginx.conf', SETTINGS)
  messageDeskApiTemp = jinjia2_render('template/config/message-desk-api.yaml', SETTINGS)
  messageDeskWorkerTemp = jinjia2_render('template/config/message-desk-worker.yaml', SETTINGS)

  frontNginxTemp = jinjia2_render('template/config/front-nginx.conf', SETTINGS)
  frontWebTemp = jinjia2_render('template/config/front-web.js', SETTINGS)

  managementNginxTemp = jinjia2_render('template/config/management-nginx.conf', SETTINGS)
  managementWebTemp = jinjia2_render('template/config/management-web.json', SETTINGS)

  funcTemp = jinjia2_render('template/config/func-config.yaml', SETTINGS)
  funcInnerTemp = jinjia2_render('template/config/func-inner-config.yaml', SETTINGS)
  funcWorkerTemp = jinjia2_render('template/config/func-worker-config.yaml', SETTINGS)

  triggerTemp = jinjia2_render('template/config/inner-app-trigger-config.ini', SETTINGS)

  return [
    {
      "key": "core",
      "name": "DataFlux Core",
      "content": coreTemp
    },
    {
      "key": "kodo",
      "name": "Kodo",
      "content": kodoTemp,
    },
    {
      "key": "kodoInner",
      "name": "Kodo Inner",
      "content": kodoInnerTemp,
    },
    {
      "key": "kodoNginx",
      "name": "Kodo Nginx",
      "content": kodoNginxTemp,
    },
    {
      "key": "messageDeskApi",
      "name": "Message Desk API",
      "content": messageDeskApiTemp,
    },
    {
      "key": "messageDeskWorker",
      "name": "Message Desk Worker",
      "content": messageDeskWorkerTemp,
    },
    {
      "key": "frontNginx",
      "name": "Front Nginx",
      "content": frontNginxTemp,
    },
    {
      "key": "frontWeb",
      "name": "Front WebClient",
      "content": frontWebTemp,
    },
    {
      "key": "managementNginx",
      "name": "Management Nginx",
      "content": managementNginxTemp,
    },
    {
      "key": "managementWeb",
      "name": "Management WebClient",
      "content": managementWebTemp,
    },
    {
      "key": "func",
      "name": "Function",
      "content": funcTemp,
    },
    {
      "key": "funcInner",
      "name": "Function Inner",
      "content": funcInnerTemp,
    },
    {
      "key": "funcWorker",
      "name": "Function Worker",
      "content": funcWorkerTemp,
    },
    {
      "key": "innerAppTrigger",
      "name": "Trigger",
      "content": triggerTemp,
    }
  ]

def __create_namespace():
  # 必须要等命名空间创建完，才能继续后续操作
  for i in range(5):
    cmd = "kubectl apply -f {}".format(os.path.abspath("launcher/resource/v1/template/k8s/namespace.yaml"))
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

    # 等待 namespace 创建完成
    for j in range(5):
      cmd = "kubectl get namespaces {} -o json".format(' '.join(SERVICECONFIG['namespaces']))
      p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

      output, err = p.communicate()
      namespace = json.loads(output)

      if len(namespace['items']) == len(SERVICECONFIG['namespaces']):
        break

      time.sleep(0.5)
    else:
      break

  return True


def certificate_create():
  otherConfig = SETTINGS['other']
  certificate = dict(
              privateKey = otherConfig['certificatePrivateKey'],
              content = otherConfig['certificateContent']
          )
  domain = otherConfig['domain']

  tmpPath = '/tmp/k8s'
  certFile = '{}/tls.cert'.format(tmpPath)
  certKeyFile = '{}/tls.key'.format(tmpPath)

  if not os.path.exists(tmpPath):
    os.mkdir(tmpPath)

  with open(os.path.abspath(certFile), 'w') as f:
    f.write(certificate['content'])

  with open(os.path.abspath(certKeyFile), 'w') as f:
    f.write(certificate['privateKey'])

  __create_namespace()

  namespaces = SERVICECONFIG['namespaces']
  for ns in namespaces:
    cmd = "kubectl create secret tls {} --cert='{}' --key='{}' -n {}".format(domain, certFile, certKeyFile, ns)
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  return True


def configmap_create(maps):
  tmpPath = "/tmp/k8s/configmap.yaml"
  configmap = jinjia2_render('template/k8s/configmap.yaml', {"config": maps})

  if not os.path.exists('/tmp/k8s'):
    os.mkdir('/tmp/k8s')

  try:
    with open(os.path.abspath(tmpPath), 'w') as f:
      f.write(configmap)

    __create_namespace()

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
  ingressTemplate = jinjia2_render("template/k8s/ingress.yaml", {"config": SETTINGS})
  ingressYaml = os.path.abspath("/tmp/k8s/ingress.yaml")

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
  pvcYaml = jinjia2_render("template/k8s/pvc.yaml", {"storageClassName": storageClassName})
  path = os.path.abspath("/tmp/k8s/pvc.yaml")

  with open(os.path.abspath(path), 'w') as f:
    f.write(pvcYaml)

  cmd = "kubectl apply  -f {}".format(path)
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  return True


def service_create(data):
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
    path = os.path.abspath("/tmp/k8s/app-{}.yaml".format(key))

    with open(path, 'w') as f:
      f.write(serviceYaml)
      appYamls.append(path)

    imageSettings['images'][key] = val

  # 创建所有 deployment & service
  cmd = "kubectl apply -f {}".format(' -f '.join(appYamls))
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  ingress_create()

  SETTINGS['ServiceImages'] = imageSettings

  return True


def service_status():
  return k8s.deploy_status()


def init_setting():
  SETTINGS["core"] = {
    "secret": {
      "frontAuth": shortuuid.ShortUUID().random(length=48),
      "manageAuth": shortuuid.ShortUUID().random(length=48)
    }
  }

  SETTINGS['func'] = {
    "secret": shortuuid.ShortUUID().random(length=48)
  }

  return True
