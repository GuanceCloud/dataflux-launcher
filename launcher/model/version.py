# encoding=utf-8

import os, re, subprocess, time
import markdown, shortuuid
import json, yaml
import requests

from launcher.utils.helper.db_helper import dbHelper

from launcher import settingsMdl, SERVICECONFIG, DOCKERIMAGES


def get_current_update_seq(mysqlInfo, dbName):
  ''' 返回值格式示例

    {
        "core": {
            "config": 2, 
            "database": 1
        }, 
        "kodo": {
            "config": 2, 
            "database": 2
        }
    }
  '''
  sql = '''
          SELECT project, seqType, max(upgradeSeq) AS upgradeSeq 
          FROM sys_version 
          GROUP BY project, seqType;
        '''

  with dbHelper(mysqlInfo) as db:
    result = db.execute(sql, dbName = dbName)

  seqs = result[0] if result and len(result) > 0 else []

  dictResult = {}
  for item in seqs:
    project    = item['project']
    seqType    = item['seqType']
    upgradeSeq = item['upgradeSeq']

    if project not in dictResult:
      dictResult[project] = {}

    if seqType not in dictResult[project]:
      dictResult[project][seqType] = {}

    dictResult[project][seqType] = upgradeSeq

  return dictResult


def save_version(project, seqType, seq):
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

  querySql = '''
          SELECT * 
          FROM sys_version
          WHERE project=%s AND version=%s AND seqType=%s;
          '''

  queryParams = (project, version, seqType)

  insertSql = '''
          INSERT INTO `sys_version` (`project`, `version`, `seqType`, `upgradeSeq`, `createAt`, `updateAt`)
          VALUES (%s, %s, %s, %s, UNIX_TIMESTAMP(), -1);        
        '''

  insertParams = (project, version, seqType, seq)

  with dbHelper(mysql) as db:
    result = db.execute(querySql, dbName = dbName, params = queryParams)

    if len(result) == 0 or len(result[0]) == 0:
      db.execute(insertSql, dbName = dbName, params = insertParams)

  return True


def excute_update_sql(mysqlInfo, dbName, sqls):
  with dbHelper(mysqlInfo) as db:
    for sql in sqls:
      db.execute(sql['content'], dbName = dbName)
      db.commit()


# 从当前应用中获取最新的版本 seq
def get_project_last_seq():
  result = {}

  for up in SERVICECONFIG['updates']:
    project = up['project']
    api     = up['api']
    dataKey = up['dataKey']

    url     = "{}?seq={}".format(api, -1)
    rsp     = requests.get(url)
    content = rsp.json()

    if content and dataKey in content:
      data = content.get(dataKey) or []

      if len(data) > 0:
        last = data[len(data) - 1]
        result[project] = last.get('seq', -1)
      else:
        result[project] = -1

  return result


def list_project_versions(url, versionSeq, dataKey):
  # 示例数据
  # return  [
  #           {
  #             "seq": 4,
  #             "database": "-- SELECT project, seqType, max(upgradeSeq) AS upgradeSeq FROM sys_version GROUP BY project, seqType;", 
  #             "config": {
  #               "kodo": "log:\n  level: info",
  #               "kodoInner": "log:\n  level: info"
  #             }
  #           },
  #           {
  #             "seq": 5,
  #             "database": "-- SELECT project, seqType, max(upgradeSeq) AS upgradeSeq FROM sys_version GROUP BY project, seqType;", 
  #             "config": {
  #               "kodo": "log:\n  level: warning\n\nglobal:\n  # 原 enable_inner 修改为 enable_inner_api\n  enable_inner_api: true"
  #             }
  #           }
  #         ]

  if not url:
    return []
    
  url = "{}?seq={}".format(url, versionSeq)

  rsp = requests.get(url)
  content = rsp.json()
  data = None

  if content and dataKey in content:
    data = content[dataKey]

  return data
