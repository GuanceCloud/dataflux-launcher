# encoding=utf-8

import os, re, subprocess, time
import markdown, shortuuid
import json, yaml
import requests

from launcher.utils.helper import api_helper as apiHelper
from launcher.utils.helper.db_helper import dbHelper
from launcher import settingsMdl, SERVICECONFIG, DOCKERIMAGES


def license_validate(license):
  # url = "http://daily-ft2x-kodo-inner-api.cloudcare.cn/v1/license/validate"
  url = "http://kodo-inner.forethought-kodo:9527/v1/license/validate"

  headers = {}
  resp = requests.post(url, data = license.encode('utf-8'), headers = headers)

  return resp.json(), resp.status_code


def get_activated_license():
  # url = "http://daily-ft2x-kodo-inner-api.cloudcare.cn/v1/license/get"
  url = "http://kodo-inner.forethought-kodo:9527/v1/license/get"

  headers = {}
  resp = requests.get(url, headers = headers)

  if resp.status_code == 200:
    return resp.json(), resp.status_code

  return None, resp.status_code


def save_aksk(data):
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

  private_dial = data.get('private_dial')

  if private_dial == 1:
    dialtesting_AK = settingsMdl.get('other', {}).get('dialtesting_AK', {})
    params = {
            "ak": dialtesting_AK.get('ak'),
            "sk": dialtesting_AK.get('sk'),
            "dataway": data.get('dataway_url')
          }
  else:
    params = {
            "ak": data.get('ak'),
            "sk": data.get('sk'),
            "dataway": data.get('dataway_url')
          }

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
  insertBOSSParams = (json.dumps({"ak": data.get('ak'), "sk": data.get('sk')}))

  with dbHelper(mysql) as db:
    result = db.execute(insertDialSettingSql, dbName = dbName, params = insertDialParams)
    result = db.execute(insertBOSSSettingSql, dbName = dbName, params = insertBOSSParams)

  return True


# 统计平台内, 当前接入的 DataKit 总数量
def get_usage_datakit_total():
  # url_workspace_list  = "http://daily-ft2x-inner.cloudcare.cn/api/v1/inner/workspace/quick_list"
  # url_usage_state     = "http://daily-ft2x-inner.cloudcare.cn/api/v1/inner/bill/query_usage_state"
  url_workspace_list  = "http://inner.forethought-core:5000/api/v1/inner/workspace/quick_list"
  url_usage_state     = "http://inner.forethought-core:5000/api/v1/inner/bill/query_usage_state"

  resp, status_code = apiHelper.do_get(url_workspace_list)

  result = None
  if status_code != 200:
    return None

  breakFor = False
  datakitTotal = 0
  worksapce_list = [item['uuid'] for item in resp.get("content", {}).get("data", [])]

  for item in worksapce_list:
    resp, status_code = apiHelper.do_get(url_usage_state, {"workspaceUUID": item})
    if status_code != 200:
      breakFor = True
      break

    d = resp.get('content', {}).get('data', [])
    if len(d) <= 0:
      breakFor = True
      break

    datakitTotal = datakitTotal + d[0].get('datakitCount', 0)

  # print(resp, status_code)
  return datakitTotal, status_code
 
