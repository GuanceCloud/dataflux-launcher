# encoding=utf-8

import os, re, subprocess, time
import shortuuid
import pymysql
import time
import logging

from launcher.utils import tools
from launcher.utils.helper.db_helper import dbHelper
from launcher import settingsMdl, SERVICECONFIG

def database_ping(params):
  params['port'] = int(params['port'])

  try:
    with dbHelper(params) as db:
      if not db.connection:
        return {"connected": False}

      sql = "SHOW DATABASES;"
      result = db.execute(sql)

      settingsMdl.mysql = {'base': params}
      if len(result) == 0:
        return {"connected": True}

      dbNames = []
      for line in result[0]:
        dbName = line['Database']
        if dbName in SERVICECONFIG['databases'].values():
          dbNames.append(dbName)
  except Exception as e:
    logging.error(e)
    return {"connected": False}

  return {"connected": True, "dbNames": dbNames}

def database_create_db():
  mysqlSetting = settingsMdl.mysql
  mysqlInfo = mysqlSetting.get('base')
  dbInfo = mysqlSetting.get('dialtesting')

  SQL = '''
        CREATE DATABASE IF NOT EXISTS {database} DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
        CREATE USER '{user}'@'%' IDENTIFIED BY '{password}';
        GRANT ALL PRIVILEGES ON {database}.* TO '{user}'@'%';
        '''.format(**dbInfo)

  # print(mysqlInfo)
  with dbHelper(mysqlInfo) as db:
    db.execute(SQL)

  return True


def database_ddl():
  logging.info("初始化 df_dialtesting 数据库 DDL 开始")
  mysqlSetting = settingsMdl.mysql
  mysqlInfo = mysqlSetting.get('base')

  password = tools.gen_password(16)

  dbInfo = {
    "database": SERVICECONFIG['databases']['dialtesting'],
    "user": SERVICECONFIG['databases']['dialtesting'],
    "password": password
  }

  settingsMdl.mysql = {'dialtesting': dbInfo}

  database_create_db()

  with dbHelper(mysqlInfo) as db:
    with open(os.path.abspath("launcher/resource/v1/ddl/dialtesting.sql"), 'r') as f:
      ddl = f.read()
      db.execute(ddl, dbName = dbInfo['database'])

  logging.info("初始化 df_dialtesting 数据库 DDL 完成")
  return True


def database_init_data():
  sql = '''
      INSERT INTO `aksk` (`uuid`, `accessKey`, `secretKey`, `owner`, `parent_ak`, `external_id`, `status`, `version`, `createAt`, `updateAt`)
      VALUES
        (%s, %s, %s, 'system', '-1', 'wksp_system', 'OK', 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());
    '''

  mysqlSetting = settingsMdl.mysql
  mysqlInfo = mysqlSetting.get('base')
  dbInfo = mysqlSetting.get('dialtesting')
  dialAKSK = settingsMdl.other.get('dialtesting_AK', {})

  dialAK_id = dialAKSK.get('ak_id')
  dialAK = dialAKSK.get('ak')
  dialSK = dialAKSK.get('sk')

  with dbHelper(mysqlInfo) as db:
    params = (dialAK_id, dialAK, dialSK)

    db.execute(sql, dbName = dbInfo['database'], params = params)

  return True


def database_setup():
  database_ddl()
  database_init_data()

  return True
