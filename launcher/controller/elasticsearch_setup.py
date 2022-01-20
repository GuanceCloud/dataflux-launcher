# encoding=utf-8

import shortuuid
import json
import time

from elasticsearch import Elasticsearch, RequestsHttpConnection
from launcher.utils.helper.db_helper import dbHelper
from launcher import settingsMdl


def elasticsearch_ping(params):
  params['port'] = int(params['port'])

  esHosts = [{
              'host': params.get('host'),
              'port': params.get('port')
            }]

  http_auth = (params.get('user'), params.get('password'))

  use_ssl = params.get('ssl', False)

  es = Elasticsearch(esHosts, http_auth = http_auth, use_ssl = use_ssl, connection_class = RequestsHttpConnection)

  pingStatus = False

  try:
    pingStatus =es.ping()
    print(pingStatus)
  except:
    pass

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

    authorization = {"admin": {"password": instance['password'], "username": instance['user'] }}
    configJson = {'provider': provider}

    if provider == 'aliyun_openstore':
      configJson['settings'] = instance.get('openStoreSettings', {})

    params = [
      es_uuid,
      host,
      json.dumps(authorization),
      str(configJson)
    ]
    sql = "INSERT INTO `main_es_instance` (`uuid`, `host`, `authorization`, `configJSON`, `isParticipateElection`, `wsCount`, `provider`, `version`, `timeout`, `extend`, `status`, `creator`, `updator`, `createAt`, `deleteAt`, `updateAt`) VALUES (%s, %s, %s, %s, 1, 0, '', '', '60s', NULL, 0, 'sys', 'sys', UNIX_TIMESTAMP(), -1, UNIX_TIMESTAMP());"

    db.execute(sql, dbName = dbInfo['database'], params = params)
