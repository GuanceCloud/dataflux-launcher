# encoding=utf-8

import redis
import json, yaml

from launcher.model import k8s as k8sMdl
from launcher import settingsMdl, SERVICECONFIG


def setting_deploy_replicas():
  result = {}

  for ns in SERVICECONFIG['services']:
    nsName = ns['namespace']
    result[nsName] = {}

    for service in ns['services']:
      serviceKey = service['key']
      serviceDisabled = service.get('deleted', False)
      serviceReplicas = service.get('replicas', 0)

      if not serviceDisabled:
        result[nsName][serviceKey] = {'replicas': serviceReplicas}

  print(result)
  return result 

def setting_get(key):
  settingJson = getattr(settingsMdl, key)

  if key == 'deploy_replicas':
    replicasSetting = setting_deploy_replicas()

  settingsYaml = yaml.dump(settingJson, default_flow_style=False)

  return settingsYaml


def setting_save(data):
  key = data['key']
  content = data['content']

  if key == 'mysql':
    pass
  elif key == 'redis':
    pass
  elif key == 'elasticsearch':
    pass
  elif key == 'influxdb':
    pass

  setattr(settingsMdl, key, content)

  return True
