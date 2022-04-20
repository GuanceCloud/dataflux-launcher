# encoding=utf-8

import os, re, subprocess, time
import markdown, shortuuid
import json, yaml
import requests

from launcher.utils.helper.db_helper import dbHelper

from launcher import settingsMdl, SERVICECONFIG, DOCKERIMAGES


def license_validate(license):
  url = "http://daily-ft2x-kodo-inner-api.cloudcare.cn/v1/license/validate"
  # url = "http://kodo-inner.forethought-kodo:9527/v1/license/validate"

  headers = {}
  resp = requests.post(url, data = license.encode('utf-8'), headers = headers)

  return resp.json(), resp.status_code


# def get_feature_code():
#   url = "http://daily-ft2x-kodo-inner-api.cloudcare.cn/v1/ping"
#   # url = "http://kodo-inner.forethought-kodo:9527/v1/ping"

#   headers = {"Content-Type": "application/json"}

#   resp = requests.get(url, headers = headers)

#   if resp.status_code == 200:
#     return resp.json()['content'], resp.status_code

#   return None, resp.status_code


def save_aksk(params):
  version = DOCKERIMAGES['apps']['version']

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

  insertDialSettingSql = '''
          INSERT INTO `main_config`(`keyCode`, `description`, `value`) 
          VALUES ('DialingServerSet', '拨测服务配置', %s) 
          ON DUPLICATE KEY UPDATE description=VALUES(description),value=VALUES(value);
        '''
  insertDialParams = (json.dumps(params))

  insertBOSSSettingSql = '''
          INSERT INTO `main_config`(`keyCode`, `description`, `value`) 
          VALUES ('BossServerSet', 'BOSS 系统对接的 AK/SK 配置', %s) 
          ON DUPLICATE KEY UPDATE description=VALUES(description),value=VALUES(value);
        '''
  insertBOSSParams = (json.dumps({"ak": params.get('ak'), "sk": params.get('sk')}))


  with dbHelper(mysql) as db:
    result = db.execute(insertDialSettingSql, dbName = dbName, params = insertDialParams)
    result = db.execute(insertBOSSSettingSql, dbName = dbName, params = insertBOSSParams)

  return True
