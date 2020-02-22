# encoding=utf-8

import os, re, subprocess
import markdown, shortuuid, pymysql
import json, time, yaml

from launcher.model import k8s as k8sMdl
from launcher.model import version as versionMdl
from launcher.utils.template import jinjia2_render

from launcher import settingsMdl, SERVICECONFIG, DOCKERIMAGES, CACHEDATA

updateDeploy = {}


def _configmap_to_template_data(maps):
  result = []

  for ns in SERVICECONFIG['services']:
    configmaps = ns["configmaps"]
    namespace  = ns['namespace']

    for cm in configmaps:
      key     = cm['key']
      mapname = cm['mapname']
      mapkey  = cm['mapkey']

      if key not in maps:
        continue

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


def new_configmap_check():
  result = []

  for ns in SERVICECONFIG['services']:
    namespace  = ns['namespace']

    configmaps = {
      'namespace': namespace,
      'configmaps': []
    }

    tmpServiceDict = {item['key']: item for item in ns['services']}

    oldMaps    = k8sMdl.get_configmap_list(namespace)
    oldMapKeys = {item['metadata']['name']: item['data'].keys() for item in oldMaps}

    for cm in ns['configmaps']:
      mapname = cm['mapname']
      mapkey  = cm['mapkey']

      if mapname in oldMapKeys and mapkey in oldMapKeys[mapname]:
        continue

      content = jinjia2_render('template/config/{}'.format(cm['file']), settingsMdl.toJson)

      cm = {
        'key': cm['key'],
        'content': content,
        'services': [tmpServiceDict[item]['name'] for item in cm['services']]
      }
      configmaps['configmaps'].append(cm)

    result.append(configmaps)

  return result


def new_pvc_check():
  oldPvcs     = k8sMdl.get_pvc()
  oldPvcNames = [ item['name'] for item in oldPvcs ]
  newPvcs     = []

  for ns in SERVICECONFIG['services']:
    namespace = ns['namespace']

    for pvc in ns.get('pvcs', []):
      pvcName = pvc['name']

      if pvcName in oldPvcNames:
        continue

      newPvcs.append(dict(
          namespace = namespace,
          name      = pvc['name'],
          storage   = pvc['storage']
        ))

  return newPvcs


def deploy_check():
  deployStatus = k8sMdl.deploy_status()
  k8sNamespaces = k8sMdl.get_namespace()

  apps = DOCKERIMAGES.get('apps', {})
  imageDir = apps.get('image_dir', '')
  defaultImage  = apps.get('images', {})
  version = apps.get('version', '')
  newPvcs = new_pvc_check()

  for ns in deployStatus:
    namespaceName = ns['namespace']
    ns['isNew'] = (namespaceName not in k8sNamespaces)

    for deploy in ns['services']:
      newImagePath = '{}/{}/{}'.format(apps.get('registry', ''), imageDir, defaultImage.get(deploy['imageKey'], ''))

      deploy['newImagePath'] = re.sub('/+', '/', newImagePath)

      if 'fullImagePath' not in deploy:
        deploy['isNew']    = True
        deploy['isUpdate'] = False
      else:
        deploy['isNew']    = False
        deploy['isUpdate'] = deploy['newImagePath'] != deploy.get('fullImagePath', '')


    ns['newPvcs'] = [item for item in newPvcs if item['namespace'] == namespaceName]

  return deployStatus


def deploy_update():
  tmpDir    = SERVICECONFIG['tmpDir']
  appYamls  = []
  newPvcs   = []  
  deployStatus = deploy_check()

  for ns in deployStatus:
    for deploy in ns['services']:
      if 'fullImagePath' not in deploy or deploy['fullImagePath'] != deploy['newImagePath']:
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

  # 2、新的命名空间，要创建 registry key
  for ns in deployStatus:    
    isNew = ns['isNew']
    if isNew:
      k8sMdl.registry_secret_create(ns['namespace'], **settingsMdl.registry)

  # 3、创建新的 PVC
  storageClassName  = settingsMdl.other.get('storageClassName', '')
  pvcYamlPath       = os.path.abspath(tmpDir + "/pvc.yaml")
  pvcYaml           = jinjia2_render("template/k8s/pvc.yaml", {"pvcs": newPvcs, "storageClassName": storageClassName})

  with open(pvcYamlPath, 'w') as f:
    f.write(pvcYaml)

  cmd = "kubectl apply  -f {}".format(pvcYamlPath)
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  # 4、更新该更新的 deploy 及 service
  cmd = "kubectl apply -f {}".format(' -f '.join(appYamls))
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  return True


def __get_current_seqs():
  mysqlSetting = settingsMdl.mysql
  baseInfo     = mysqlSetting.get('base') or {}
  coreInfo     = mysqlSetting.get('core') or {}
  mysql        = {
                'host': baseInfo.get('host'),
                'port': baseInfo.get('port'),
                'user': coreInfo.get('user'),
                'password': coreInfo.get('password')
              }
  dbName       = coreInfo.get('database')
  currentSeqs  = versionMdl.get_current_update_seq(mysql, dbName)

  return currentSeqs


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

  upInfo      = []
  currentSeqs = __get_current_seqs()

  for project in updateProjects:
    namespace = project['namespace']
    dataKey   = project['dataKey']
    up        = {
      'namespace': namespace,
      'api': project['api'],
      'project': project['project'],
      'configmaps': []
    }

    seq             = currentSeqs.get(project['project'], {}).get('config', 0)
    updateVersions  = versionMdl.list_project_versions(project['api'], seq, project['dataKey'])

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


def list_update_database_sql():
  currentSeqs  = __get_current_seqs()

  allDbUpdates = []
  for ups in SERVICECONFIG['updates']:
    api        = ups['api']
    project    = ups['project']
    dataKey    = ups['dataKey']
    namespace  = ups['namespace']
    noDatabase = ups['noDatabase']

    if noDatabase:
      continue

    currentSeq      = currentSeqs.get(project, {}).get('config', 0)
    updateVersions  = versionMdl.list_project_versions(api, currentSeq, dataKey)

    upItem  = {
                'namespace': namespace,
                'project': project,
                'sqls': []
              }

    for upv in updateVersions:
      sql = upv.get('database')

      if sql:
        upItem['sqls'].append({
            'seq': upv.get('seq'),
            'content': sql
          })

    allDbUpdates.append(upItem)

  CACHEDATA['dbUpdates'] = allDbUpdates

  return allDbUpdates


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


def redeploy(configServices, configKey, namespace):
  services = configServices.get(namespace, {}).get(configKey) or []

  for deployName in services:
    k8sMdl.redeploy(deployName, namespace)

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

      # redeploy(configServices, key, namespace)

  return True


def database_update(project):
  dbUpdates   = CACHEDATA.get('dbUpdates')

  mysqlSetting = settingsMdl.mysql
  baseInfo     = mysqlSetting.get('base') or {}

  vSqls = []
  for item in dbUpdates:
    itemProject = item.get('project')
    sqls    = item.get('sqls', [])

    if project != itemProject or len(sqls) == 0:
      continue

    appMySQLInfo = mysqlSetting.get(itemProject) or {}

    mysql        = {
                  'host': baseInfo.get('host'),
                  'port': baseInfo.get('port'),
                  'user': appMySQLInfo.get('user'),
                  'password': appMySQLInfo.get('password')
                }
    dbName       = appMySQLInfo.get('database')

    versionMdl.excute_update_sql(mysql, dbName, sqls)

    lastSql = sqls[len(sqls) - 1]
    versionMdl.insert_version(itemProject, 'database', lastSql['seq'])

  CACHEDATA['dbUpdates'] = []
  
  return True

