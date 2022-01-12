# encoding=utf-8

import shortuuid
import json
import time

from launcher.utils.helper.db_helper import dbHelper
from launcher import settingsMdl


def __write_elasticsearch_instance():
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

    authorization = {"admin": {"password": instance['password'], "username": instance['user'] }}

    params = [
      es_uuid,
      host,
      json.dumps(authorization),
      instance.get('provider'),
      instance.get('version')
    ]
    sql = "INSERT INTO `main_es_instance` (`uuid`, `host`, `authorization`, `isParticipateElection`, `wsCount`, `provider`, `version`, `timeout`, `extend`, `status`, `creator`, `updator`, `createAt`, `deleteAt`, `updateAt`) VALUES (%s, %s, %s, 0, 0, %s, %s, '60s', NULL, 0, 'sys', 'sys', UNIX_TIMESTAMP(), -1, UNIX_TIMESTAMP());"

    db.execute(sql, dbName = dbInfo['database'], params = params)

  return params


def before_container_update():
  mysqlSetting = settingsMdl.mysql
  mysqlInfo = mysqlSetting.get('base')
  dbInfo = mysqlSetting.get('core')

  esInfo = __write_elasticsearch_instance()

  # 更新所有 工作空间的 ES 实例 UUID
  with dbHelper(mysqlInfo) as db:
    params = [
      esInfo[0]
    ]

    sql = "UPDATE `main_workspace` set `esInstanceUUID` = %s;"

    db.execute(sql, dbName = dbInfo['database'], params = params)

  return True