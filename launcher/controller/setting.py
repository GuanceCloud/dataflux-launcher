# encoding=utf-8

import redis
import json, yaml
import base64

from launcher.model import k8s as k8sMdl
from launcher.model import authorize as authorizeMdl
from launcher import settingsMdl, SERVICECONFIG


def get_usage():
  return authorizeMdl.get_usage_datakit_total()


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


def get_activated_license():
  resp, status_code = authorizeMdl.get_activated_license()

  invaild_content = {
    "license": None,
    "status": False
  }

  if status_code == 200:
    return resp.get('content', invaild_content)

  return invaild_content


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


# def get_feature_code():
#   resp, status_code = authorizeMdl.get_feature_code()

#   # print(resp, status_code)
#   return resp

def setting_activate(data):
  other = settingsMdl.other or {}
  other['guance'] = data
  settingsMdl.other = other
  license_text_b64 = data.get('license', '')

  license_effective = False
  result = ""
  success = False

  license_text = ''
  try:
    license_text = base64.b64decode(license_text_b64).decode('utf-8')
  except:
    return {
      "result": "invaildLicense",
      "success": False
    }

  resp_content, status_code = authorizeMdl.license_validate(license_text)

  if status_code == 403:
    return {
      "result": resp_content['error_code'],
      "success": False
    }
  elif status_code == 200 and resp_content['content']['status']:
    authorizeMdl.save_aksk({
        "ak": data.get('ak'),
        "sk": data.get('sk'),
        "dialService": other.get('dialService'),
        "dataway_url": data.get('dataway_url')
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
    k8sMdl.redeploy("kodo-asynq-client", "forethought-kodo")
    k8sMdl.redeploy("front-backend", "forethought-core")

  return {
    "result": result,
    "success": success
  }

def setting_tls_change(params):
  other = settingsMdl.other or {}
  tls = other.get('tls', {})
  tls['certificatePrivateKey'] = params.get('certificatePrivateKey', '')
  tls['certificateContent'] = params.get('certificateContent', '')
  if tls.get('tlsDisabled', False):
    tls['tlsDisabled'] = False

  other['tls'] = tls
  settingsMdl.other = other

  return {
          "success": k8sMdl.certificate_create_all_namespace()
        }

