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
  mysqlSetting = settingsMdl.mysql
  mysqlInfo = mysqlSetting.get('base')
  dbInfo = mysqlSetting.get('dialtesting')

  with dbHelper(mysqlInfo) as db:
    with open(os.path.abspath("launcher/resource/v1/data/dialtesting.sql"), 'r') as f:
      sql = f.read()
      db.execute(sql, dbName = dbInfo['database'])

  return True


# def database_manage_account_create():
#   sql = '''
#       INSERT INTO `main_manage_account` (`uuid`, `name`, `role`, `username`, `password`, `email`, `mobile`, `createAt`)
#       VALUES (%s, '管理员', 'admin', %s, %s, %s, '', UNIX_TIMESTAMP());
#     '''

#   mysqlSetting = settingsMdl.mysql
#   mysqlInfo = mysqlSetting.get('base')
#   dbInfo = mysqlSetting.get('core')
#   accountInfo = settingsMdl.other.get('manager', {})

#   username = accountInfo.get('username')
#   email = accountInfo.get('email')

#   if username:
#     with dbHelper(mysqlInfo) as db:
#       password = 'pbkdf2:sha256:150000$dSCmDxZJ$76950c22b74ce70f468612afe2e313a1fb527cd05902c61bf25f0eedcefd9dfd'

#       params = ('mact-' + shortuuid.ShortUUID().random(length = 24), username, password, email)

#       db.execute(sql, dbName = dbInfo['database'], params = params)

#   return True


def database_setup():
  database_ddl()
  database_init_data()
  # database_init_data_geo()

  # database_init_kapa()

  return True
