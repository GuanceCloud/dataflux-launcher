# encoding=utf-8

import redis
import json, yaml

from launcher.model import k8s as k8sMdl
from launcher.model import authorize as authorizeMdl
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

  # print(result)
  return result 

def setting_get(key, format = 'yaml'):
  settingJson = getattr(settingsMdl, key)

  # if key == 'deploy_replicas':
  #   replicasSetting = setting_deploy_replicas()

  if format == 'yaml':
    settingsValue = yaml.dump(settingJson, default_flow_style=False)
  else:
    settingsValue = settingJson

  return settingsValue


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


def get_feature_code():
  resp, status_code = authorizeMdl.get_feature_code()

  print(resp, status_code)
  return resp


def setting_activate(data):
  other = settingsMdl.other or {}
  other['guance'] = data
  settingsMdl.other = other
  license_text = data.get('license')

  # TO DO， 校验 License 是否有效
  license_effective = False
  result = ""
  success = False

  resp, status_code = authorizeMdl.license_validate(license_text)

  if status_code == 403:
    return {
      "result": resp['error_code'],
      "success": False
    }
  elif status_code == 200 and resp['content']['status']:
    authorizeMdl.save_aksk({
        "ak": data.get('ak'),
        "sk": data.get('sk'),
        "dataway": data.get('dataway_url')
      })

    k8sMdl.patch_configmap("kodo-license", "license", license_text, "forethought-kodo")

    success = True
  else:
    result = "invaildLicense"
    success = False

  if success:
    k8sMdl.redeploy("kodo", "forethought-kodo")
    k8sMdl.redeploy("kodo-inner", "forethought-kodo")
    k8sMdl.redeploy("kodo-ws", "forethought-kodo")
    k8sMdl.redeploy("kodo-x", "forethought-kodo")
    k8sMdl.redeploy("front-backend", "forethought-core")

  return {
    "result": result,
    "success": success
  }
