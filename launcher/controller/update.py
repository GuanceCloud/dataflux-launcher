# encoding=utf-8

import os, re, subprocess
import markdown, shortuuid, pymysql
import json, time, yaml

from launcher.model import k8s
from launcher.utils.template import jinjia2_render

from launcher import SERVICECONFIG, DOCKERIMAGES

updateDeploy = {}

def pvc_check():
  oldPvcs = k8s.get_pvc()

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
  deployStatus = k8s.deploy_status()
  k8sNamespaces = k8s.get_namespace()

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
  k8s.apply_namespace()

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


def configmap_check():
  launcherSettings = k8s.get_launcher_settings()
  mysqlSetting = launcherSettings['mysql']

  connInfo = dict(
                  host = mysqlSetting['host'],
                  port = mysqlSetting['port'],
                  user = mysqlSetting['core']['user'],
                  password = mysqlSetting['core']['password'],
                  database = mysqlSetting['core']['database']
                )

  # TODO
