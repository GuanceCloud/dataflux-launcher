# encoding=utf-8

import requests
import os, re, subprocess
import markdown, shortuuid, pymysql
import json, time, logging

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
    'dial': params.get('dial', {}),
  }

  return True


def other_config(params):
  settingsMdl.domain = {
    'domain': params.get('domain', ''),
    'subDomain': params.get('subDomain', {}),
    'kodoLoadBalancerType': params.get('kodoLoadBalancerType', "")
  }

  settingsMdl.other = {
    'manager': params.get('manager'),
    'tls': params.get('tls'),
    'nodeInternalIP': params.get('nodeInternalIP'),
    'studioHideHelp': params.get('studioHideHelp')
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
        'services': [tmpServiceDict[item]['name'] for item in configmap['services']],
        'format': configmap.get('format', '')
      }
      configmaps['configmaps'].append(cm)

    result.append(configmaps)

  return result


def certificate_create():
  k8sMdl.apply_namespace()
  k8sMdl.certificate_create_all_namespace()

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
    logging.error(e)
    return False

  return True


# 服务镜像配置
def service_image_config():
  # 使用 docker-image.yaml 中的镜像列表
  apps = DOCKERIMAGES.get('apps', {})
  imageDir = apps.get('image_dir', '')
  defaultImage  = apps.get('images', {})

  registrySecrets = k8sMdl.registry_secret_get('launcher', 'registry-key')

  registry      = registrySecrets[0]
  registryAddr  = registry.get('address') or ''
  registryUser  = registry.get('username') or ''
  registryPwd   = registry.get('password') or ''


  d = {
    "imageRegistry": registryAddr,
    "imageRegistryUser": registryUser,
    "imageRegistryPwd": registryPwd,
    "imageDir": imageDir,
    "storageClassName": settingsMdl.other.get("storageClassName"),
    "imagePullPolicy": settingsMdl.other.get("imagePullPolicy", "IfNotPresent"),
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
  imagePullPolicy = data.get('imagePullPolicy') or ''
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
    "storageClassName": storageClassName,
    "imagePullPolicy": imagePullPolicy
  }

  _registry_secret_create(settingsMdl.registry)
  _PVC_create(storageClassName)

  for key, val in images.items():
    imagePath = '{}/{}/{}'.format(registryAddr, imageDir, val.get('imagePath') or '')
    val['fullImagePath'] = re.sub('/+', '/', imagePath)

    # 0 副本的服务，不创建
    if val.get('replicas', 1) == 0:
      continue

    serviceYaml = jinjia2_render("template/k8s/app-{}.yaml".format(key), {"config": val, "settings": {"imagePullPolicy": imagePullPolicy, "domain": settingsMdl.domain}})
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


def service_done_check():
  headers = {"Content-Type": "application/json"}

  resp = requests.get("http://inner.forethought-core:5000/api/v1/inner/const/ping", headers = headers)

  return resp.status_code == 200


def call_service_url(url, jsonData = None):
  headers = {"Content-Type": "application/json"}
  isDone = False

  for i in range(0, 50):
    if not service_done_check():
      time.sleep(0.5)
    else:
      isDone = True
      break

  if isDone:
    resp = requests.post(url, json = jsonData, headers = headers)
    return {"status_code": resp.status_code}
  else:
    return {"status_code": 429}


# 初始化工作空间的 ES
def elasticsearch_init():
  url = "http://inner.forethought-core:5000/api/v1/inner/es/init"

  return call_service_url(url)


def workspace_init():
  url = "http://inner.forethought-core:5000/api/v1/inner/system/init"

  data = {
    "workspaceSet": {
      "name": "系统工作空间",
      "token": settingsMdl.other["workspace"]["token"]
    }
  }

  return call_service_url(url, data)


#  ES 计量数据索引模板初始化
def metering_init():
  url = "http://inner.forethought-core:5000/api/v1/inner/es/init_subsequent"

  return call_service_url(url)


# 安装成功之后，初始化一些 studio 的相关配置
def studio_init():
  url = "http://inner.forethought-core:5000/api/v1/inner/upgrade/tasks/execute_task_func"

  data = {
    "script_name": "data_package_task",
    "func_name": "distribute_data_package",
    "funcKwargs": {
      "keys": [
        "geo",                  # 拨测的地理信息
        "internal_pipeline",    # 内置 Pipeline 库
        "measurements_meta",    # 内置 指标字典
        # "dataflux_integration", # 集成包
        "dataflux_template",    # 内置视图模板
        "dataflux_template_en",    # 内置视图模板 en
        "internal_field_cfg",    # 同步官方字段说明
        "permission"            # 同步权限相关的数据
      ]
    }
  }

  return call_service_url(url, data)


# 触发同步视图模板等集成包
def sync_integration():
  url = "http://inner.forethought-core:5000/api/v1/inner/upgrade/fix_data"

  data = {
    "script_name": "fix_update_integration"
  }

  return call_service_url(url, data)


# 触发官方 Pipeline 库同步到数据库
def sync_pipeline():
  url = "http://inner.forethought-core:5000/api/v1/inner/upgrade/tasks/execute_task_func"

  data = {
    "script_name": "timed_sync_pipeline_template",
    "func_name": "timed_sync_pull",
    "funcKwargs": {
      "need_sync_pipline": True
    }
  }

  return call_service_url(url, data)


# 触发官方 字段 库同步到数据库
def sync_field_list():
  url = "http://inner.forethought-core:5000/api/v1/inner/upgrade/tasks/execute_task_func"

  data = {
    "script_name": "timed_sync_field_cfg_template",
    "func_name": "timed_sync_pull",
    "funcKwargs": {
      "need_sync_field_cfg": True
    }
  }

  return call_service_url(url, data)


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
    },
    'dialtesting_AK':{
      "ak_id":"ak_" + shortuuid.ShortUUID().random(length = 16),
      "ak": shortuuid.ShortUUID().random(length = 16),
      "sk": shortuuid.ShortUUID().random(length = 32)
    }
  }

  return True
