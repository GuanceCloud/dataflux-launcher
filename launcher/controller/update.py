# encoding=utf-8

import os, re, subprocess
import markdown, shortuuid, pymysql
import json, time, yaml

from launcher.model import k8s as k8sMdl
from launcher.model import version as versionMdl
from launcher.utils.template import jinjia2_render

from launcher import SERVICECONFIG, DOCKERIMAGES

updateDeploy = {}

def pvc_check():
  oldPvcs = k8sMdl.get_pvc()

  pvcYamlContent = jinjia2_render("template/k8s/pvc.yaml", {"storageClassName": oldPvcs[0]['storageClassName']})

  pvcYamls = pvcYamlContent.split('---')
  newPvcs = []

  oldPvcNames = [ item['name'] for item in oldPvcs ]

  for item in pvcYamls:
    pvcJson = yaml.safe_load(item)
    pvcName = pvcJson['metadata']['name']
    # pvcStorage = pvcJson['spec']['resources']['requests']['storage']

    if pvcName in oldPvcNames:
      continue

    newPvcs.append(pvcJson)

  return newPvcs

def deploy_check():
  deployStatus = k8sMdl.deploy_status()
  k8sNamespaces = k8sMdl.get_namespace()

  apps = DOCKERIMAGES.get('apps', {})
  imageDir = apps.get('image_dir', '')
  defaultImage  = apps.get('images', {})
  version = apps.get('version', '')
  newPvcs = pvc_check()

  for ns in deployStatus:
    namespaceName = ns['namespace']
    ns['isNew'] = (namespaceName not in k8sNamespaces)

    for deploy in ns['services']:
      newImagePath = '{}/{}/{}'.format(apps.get('registry', ''), imageDir, defaultImage.get(deploy['imageKey'], ''))

      deploy['newImagePath'] = re.sub('/+', '/', newImagePath)

      updateKey = version + deploy['key']

      if updateKey not in updateDeploy:
        updateDeploy[updateKey] = (deploy['newImagePath'] != deploy['fullImagePath'])

      deploy['isUpdate'] = updateDeploy[updateKey]

    ns['newPvcs'] = [item for item in newPvcs if item['metadata']['namespace'] == namespaceName]

  return deployStatus


def deploy_update():
  tmpDir = SERVICECONFIG['tmpDir']
  appYamls = []
  newPvcs = []  
  deployStatus = deploy_check()

  for ns in deployStatus:
    for deploy in ns['services']:
      if deploy['fullImagePath'] != deploy['newImagePath']:
        key = deploy['key']
        params = {
                    "replicas": deploy['replicas'],
                    "fullImagePath": deploy['newImagePath']
                  }
        serviceYaml = jinjia2_render("template/k8s/app-{}.yaml".format(key), {"config": params})
        path = os.path.abspath(tmpDir + "/app-{}.yaml".format(key))

        with open(path, 'w') as f:
          f.write(serviceYaml)
          appYamls.append(path)

    newPvcs = newPvcs + ns['newPvcs']

  # 1、创建新的 namespace
  k8sMdl.apply_namespace()

  # 2、创建新的 PVC
  pvcYamlPath = os.path.abspath(tmpDir + "/pvc.yaml")
  newPvcYamls = [ yaml.dump(item, default_flow_style = False) for item in newPvcs]
  newPvcYamlContent = '\n\n---\n\n'.join(newPvcYamls)

  with open(pvcYamlPath, 'w') as f:
    f.write(newPvcYamlContent)

  cmd = "kubectl apply  -f {}".format(pvcYamlPath)
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  # 3、更新该更新的 deploy 及 service
  cmd = "kubectl apply -f {}".format(' -f '.join(appYamls))
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  return True


def list_source_and_update_configmaps():
  mapKeyVal      = {}
  updateProjects = SERVICECONFIG['updates']

  for ns in SERVICECONFIG['services']:
    maps      = {}
    namespace = ns['namespace']

    mapKeyVal[namespace]  = maps
    tmpServiceDict        = {item['key']: item for item in ns['services']}

    for configmap in ns['configmaps']:
      maps[configmap['key']] = {
        'services': [tmpServiceDict[item]['name'] for item in configmap['services']]
      }

  upInfo = []
  for project in updateProjects:
    namespace = project['namespace']
    dataKey   = project['dataKey']
    up        = {
      'namespace': namespace,
      'api': project['api'],
      'project': project['project'],
      'configmaps': []
    }
    updateVersions  = versionMdl.list_project_versions(project['api'], 1, project['dataKey'])

    for item in project['config']:
      mapName = item['mapName']
      mapKey  = item['mapKey']
      key     = item['key']

      thisKeyUpdateConfig =[]
      for upv in updateVersions:
        updateConfigs = upv.get('config') or {}
        upConfig = updateConfigs.get(key)

        if upConfig:
          thisKeyUpdateConfig.append({
              "seq": upv.get('seq'),
              "content": upConfig
            })

      configmapData = k8sMdl.get_configmap(mapName, namespace)
      config        = {
        'services': mapKeyVal[namespace][key]['services'],
        'key': key,
        'mapName': mapName,
        'mapKey': mapKey,
        'content': configmapData[mapKey],
        'updates': thisKeyUpdateConfig
      }

      up['configmaps'].append(config)

    upInfo.append(up)

  return upInfo


# configmap 相关的服务
def list_config_ref_services():
  result = {}

  for ns in SERVICECONFIG['services']:
    namespace = ns['namespace']

    result[namespace] = {}
    for configmap in ns['configmaps']:
      key      = configmap['key']
      services = configmap['services']

      result[namespace][key] = services

  return result


def redeployment(configServices, configKey, namespace):
  services = configServices.get(namespace, {}).get(configKey) or []

  for deployName in services:
    k8sMdl.redeployment(deployName, namespace)

  return True

def configmap_update(params):
  updateProjects = SERVICECONFIG['updates']
  configServices = list_config_ref_services()

  for project in updateProjects:
    namespace = project['namespace']

    for item in project['config']:
      key     = item['key']
      mapName = item['mapName']
      mapKey  = item['mapKey']

      content = params.get(key)

      if not content:
        continue

      k8sMdl.patch_configmap(mapName, mapKey, content, namespace)

      redeployment(configServices, key, namespace)

  return True




