# encoding=utf-8

import os, re, subprocess
import markdown, shortuuid, pymysql

from utils.template import jinjia2_render
from . import SETTINGS


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
  tmpPath = "/tmp/k8s-service/configmap.yaml"
  configmap = jinjia2_render('template/k8s-service/configmap.yaml', {"config": maps})

  if not os.path.exists('/tmp/k8s-service'):
    os.mkdir('/tmp/k8s-service')

  try:
    with open(os.path.abspath(tmpPath), 'w') as f:
      f.write(configmap)

    cmd = "kubectl apply -f {}".format(os.path.abspath("resource/v1/template/k8s-service/namespace.yaml"))
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

    cmd = "kubectl apply  -f {}".format(tmpPath)
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
  except:
    return False

  return True


# 服务镜像配置
def service_image_config():
  d = {
      "imageRegistry": "",
      "images": [ {
          "key": "front-backend",
          "image": ""
        },{
          "key": "manage-backend",
          "image": ""
        },{
          "key": "inner",
          "image": ""
        },{
          "key": "integration-scanner",
          "image": ""
        },{
          "key": "websocket",
          "image": ""
        },{
          "key": "kodo",
          "image": ""
        },{
          "key": "kodo-inner",
          "image": ""
        },{
          "key": "kodo-nginx",
          "image": ""
        },{
          "key": "front-webclient",
          "image": ""
        },{
          "key": "manage-webclient",
          "image": ""
        }
      ]
    }

  return d


def service_create(data):
  yamls = []
  for key, val in data.items():
    serviceYaml = jinjia2_render("template/k8s-service/{}.yaml".format(key), {"config": val})
    path = os.path.abspath("/tmp/k8s-service/{}.yaml".format(key))

    with open(path, 'w') as f:
      f.write(serviceYaml)

      yamls.append(path)

  cmd = "kubectl apply -f {}".format(' -f '.join(yamls))
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  return True

def init_setting():
  SETTINGS["core"] = {
    "secret": {
      "frontAuth": shortuuid.ShortUUID().random(length=48),
      "manageAuth": shortuuid.ShortUUID().random(length=48)
    }
  }

  return True
