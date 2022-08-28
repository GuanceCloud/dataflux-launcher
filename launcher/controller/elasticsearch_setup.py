# encoding=utf-8

import shortuuid
import json
import time
import requests

from requests.auth import HTTPBasicAuth

from launcher.utils.helper.db_helper import dbHelper
from launcher import settingsMdl


def elasticsearch_ping(params):
  use_ssl = params.get('ssl', False)
  http_auth = HTTPBasicAuth(params.get('user'), params.get('password'))
  url = "{protocol}://{host}:{port}".format(**{"protocol": "https" if use_ssl else "http", "host": params.get('host'), "port": params.get('port')})

  pingStatus = False

  try:
    resp = requests.get(url, auth = http_auth)
    if resp.status_code == 200:
      pingStatus = True
  except Exception as e:
    print(e)

  if pingStatus:
    settingsMdl.elasticsearch = params

    return True

  return False


def init_elasticsearch():
  instance = settingsMdl.elasticsearch

  mysqlSetting = settingsMdl.mysql
  mysqlInfo = mysqlSetting.get('base')
  dbInfo = mysqlSetting.get('core')


  with dbHelper(mysqlInfo) as db:
    # elasticsearch instance 
    es_uuid = "es_" + shortuuid.ShortUUID().random(length = 24)
    host = "{protocol}://{host}:{port}".format(**{
        "protocol": 'https' if instance.get('ssl') else 'http',
        "host": instance.get('host'),
        "port": instance.get('port')
      })

    provider = instance.get('provider', 'elastic')
    if provider == 'aliyun':
      if instance.get('isOpenStore', False):
        provider = provider + '_openstore'
      else:
        provider = provider + '_elasticsearch'
    elif provider == 'aws':
      if instance.get('isUltrawarm', False):
        provider = provider + '_opensearch'
      else:
        provider = provider + '_ultrawarm'
    elif provider == 'huawei':
      provider = provider + '_opensearch'

    authorization = {"admin": {"password": instance['password'], "username": instance['user'] }}
    configJson = {'provider': provider}

    if provider == 'aliyun_openstore':
      configJson['settings'] = instance.get('openStoreSettings', {})

    params = [
      es_uuid,
      host,
      json.dumps(authorization),
      json.dumps(configJson)
    ]
    sql = "INSERT INTO `main_es_instance` (`uuid`, `host`, `authorization`, `configJSON`, `isParticipateElection`, `wsCount`, `provider`, `version`, `timeout`, `extend`, `status`, `creator`, `updator`, `createAt`, `deleteAt`, `updateAt`) VALUES (%s, %s, %s, %s, 1, 0, '', '', '60s', NULL, 0, 'sys', 'sys', UNIX_TIMESTAMP(), -1, UNIX_TIMESTAMP());"

    db.execute(sql, dbName = dbInfo['database'], params = params)
