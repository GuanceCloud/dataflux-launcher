# encoding=utf-8

import os, re, subprocess
import markdown, shortuuid, pymysql
import json

from utils.template import jinjia2_render

from . import SETTINGS, SERVICECONFIG


def do_check():
  return {"status": "check OK"}


def readme():
  with open(os.path.abspath("templates/README.md"), 'r') as f:
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
  frontWebTemp = jinjia2_render('template/config/front-web.json', SETTINGS)

  managementNginxTemp = jinjia2_render('template/config/management-nginx.conf', SETTINGS)
  managementWebTemp = jinjia2_render('template/config/management-web.json', SETTINGS)

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
    }
  ]


def configmap_create(maps):
  tmpPath = "/tmp/k8s/configmap.yaml"
  configmap = jinjia2_render('template/k8s/configmap.yaml', {"config": maps})

  if not os.path.exists('/tmp/k8s'):
    os.mkdir('/tmp/k8s')

  try:
    with open(os.path.abspath(tmpPath), 'w') as f:
      f.write(configmap)

    cmd = "kubectl apply -f {}".format(os.path.abspath("resource/v1/template/k8s/namespace.yaml"))
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

    cmd = "kubectl apply  -f {}".format(tmpPath)
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
  except:
    return False

  return True


# 服务镜像配置
def service_image_config():
  d = None

  if SERVICECONFIG.get('debug'):
    # 调试模式
    d = {
        "imageRegistry": "registry.jiagouyun.com/",
        # "images": []
        "images": [ {
            "key": "front-backend",
            "name": "用户前台 API",
            "imagePath": "cloudcare-forethought/cloudcare-forethought-backend:release-20191210-01"
            },{
            "key": "management-backend",
            "name": "后台管理平台 API",
            "imagePath": "cloudcare-forethought/cloudcare-forethought-backend:release-20191210-01"
            },{
            "key": "inner",
            "name": "Inner API",
            "imagePath": "cloudcare-forethought/cloudcare-forethought-backend:release-20191210-01"
            },{
            "key": "integration-scanner",
            "name": "集成扫描 Worker",
            "imagePath": "cloudcare-forethought/cloudcare-forethought-backend:release-20191210-01"
            },{
            "key": "websocket",
            "name": "Websocket",
            "imagePath": "cloudcare-forethought/cloudcare-forethought-backend:release-20191210-01"
            },{
            "key": "kodo",
            "name": "Kodo",
            "imagePath": "kodo/kodo:release-20191209"
            },{
            "key": "kodo-inner",
            "name": "Kodo Inner",
            "imagePath": "kodo/kodo:release-20191209"
            },{
            "key": "kodo-nginx",
            "name": "Kodo Nginx",
            "imagePath": "basis/nginx:devops"
            },{
            "key": "front-webclient",
            "name": "用户前台前端",
            "imagePath": "cloudcare-front/cloudcare-forethought-webclient:release-20191206-03"
            },{
            "key": "management-webclient",
            "name": "管理后台前端",
            "imagePath": "cloudcare-front/cloudcare-forethought-webmanage:release-20191206"
            }
        ]
    }
  else:
    d = {
      "imageRegistry": "",
      "images": []
    }

    services = SERVICECONFIG['services']
    for item in services:
        d['images'].append(item)

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


def service_create(data):
  appYamls = []

  imageRegistry = data.get('imageRegistry') or ''
  images = data.get('images', {})

  imageSettings = {
    "imageRegistry": imageRegistry,
    "images": {}
  }

  for key, val in images.items():
    imagePath = '{}/{}'.format(imageRegistry, val.get('imagePath') or '')
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
  namespaces = SERVICECONFIG['namespaces']

  tempStatus = {}
  for ns in namespaces:
    cmd = 'kubectl get deployments -n {} -o json'.format(ns)
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

    # print(p.returncode)
    # if p.returncode != 0:
    #     continue

    output, err = p.communicate()
    deploys = json.loads(output)

    for item in deploys['items']:
      key = item['metadata']['name']
      image = item['spec']['template']['spec']['containers'][0]['image']

      status = {}
      if 'conditions' in item['status']:
        status = {c['type']: c['status'] for c in item['status']['conditions']}

      status['fullImagePath'] = image
      status['key'] = key

      tempStatus[key] = status

  deployStatus = []
  for service in SERVICECONFIG['services']:
    key = service['key']
    name = service['name']

    if key in tempStatus:
        tempStatus[key]['name'] = name
        deployStatus.append(tempStatus[key])
    else:
        deployStatus.append({
                'key': key,
                'name': name,
                'Progressing': 'True'
            })

  return deployStatus


def init_setting():
  SETTINGS["core"] = {
    "secret": {
      "frontAuth": shortuuid.ShortUUID().random(length=48),
      "manageAuth": shortuuid.ShortUUID().random(length=48)
    }
  }

  return True
