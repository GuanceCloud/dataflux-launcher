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
  dbInfo = mysqlSetting.get('core')

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
  logging.info("初始化 df_core 数据库 DDL 开始")
  mysqlSetting = settingsMdl.mysql
  mysqlInfo = mysqlSetting.get('base')

  password = tools.gen_password(16)

  dbInfo = {
    "database": SERVICECONFIG['databases']['core'],
    "user": SERVICECONFIG['databases']['core'],
    "password": password
  }

  settingsMdl.mysql = {'core': dbInfo}

  database_create_db()

  with dbHelper(mysqlInfo) as db:
    with open(os.path.abspath("launcher/resource/v1/ddl/core.sql"), 'r') as f:
      ddl = f.read()
      db.execute(ddl, dbName = dbInfo['database'])

  logging.info("初始化 df_core 数据库 DDL 完成")
  return True


def database_init_data():
  mysqlSetting = settingsMdl.mysql
  mysqlInfo = mysqlSetting.get('base')
  dbInfo = mysqlSetting.get('core')

  with dbHelper(mysqlInfo) as db:
    with open(os.path.abspath("launcher/resource/v1/data/core.sql"), 'r') as f:
      sql = f.read()
      db.execute(sql, dbName = dbInfo['database'])

  return True


# def database_init_data_geo():
#   mysqlSetting = settingsMdl.mysql
#   mysqlInfo = mysqlSetting.get('base')
#   dbInfo = mysqlSetting.get('core')
#
#   params = {**mysqlInfo.copy(), **dbInfo}
#   params['sql_path'] = '~/work/cloudcare/dataflux/cloudcare-forethought-setup/launcher/resource/v1/ddl/geo.sql'
#
#   cmd = "mysql -h {host} --port {port} -u{user} -p{password} -D{database} < {sql_path}".format(**params)
#
#   print("cmd:", cmd)
#
#   p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
#   output, err = p.communicate()
#
#   print("err:", err)
#
#   return True



# def database_init_kapa():
#   # kapa instance
#   # 固定两个 kapa 实例，如调整实例个数，要相应调整这里的代码
#   mysqlSetting = settingsMdl.mysql
#   mysqlInfo = mysqlSetting.get('base')
#   dbInfo = mysqlSetting.get('core')

#   with dbHelper(mysqlInfo) as db:
#     nodeInternalIP = settingsMdl.other.get('nodeInternalIP', "")
#     ips = re.split('\s*[;,、]\s*', nodeInternalIP)

#     kapacitorHost1 = "http://{}:30991".format(ips[0])
#     kapacitorHost2 = "http://{}:30992".format(ips[0])

#     params = [
#       "kapa-" + shortuuid.ShortUUID().random(length = 24),
#       kapacitorHost1
#     ]
#     sql = "INSERT INTO `main_kapa` (`uuid`, `host`, `influxInstanceUUID`, `status`, `createAt`) VALUES (%s, %s, '', 0, UNIX_TIMESTAMP());"
#     db.execute(sql, dbName = dbInfo['database'], params = params)

#     params = [
#       "kapa-" + shortuuid.ShortUUID().random(length = 24),
#       kapacitorHost2
#     ]
#     sql = "INSERT INTO `main_kapa` (`uuid`, `host`, `influxInstanceUUID`, `status`, `createAt`) VALUES (%s, %s, '', 0, UNIX_TIMESTAMP());"
#     db.execute(sql, dbName = dbInfo['database'], params = params)

#   return True

def database_manage_account_create():
  sql = '''
      INSERT INTO `main_manage_account` (`uuid`, `name`, `role`, `username`, `password`, `email`, `mobile`, `createAt`)
      VALUES (%s, '管理员', 'admin', %s, %s, %s, '', UNIX_TIMESTAMP());
    '''

  mysqlSetting = settingsMdl.mysql
  mysqlInfo = mysqlSetting.get('base')
  dbInfo = mysqlSetting.get('core')
  accountInfo = settingsMdl.other.get('manager', {})

  username = accountInfo.get('username')
  email = accountInfo.get('email')

  if username:
    with dbHelper(mysqlInfo) as db:
      password = 'pbkdf2:sha256:150000$dSCmDxZJ$76950c22b74ce70f468612afe2e313a1fb527cd05902c61bf25f0eedcefd9dfd'

      params = ('mact-' + shortuuid.ShortUUID().random(length = 24), username, password, email)

      db.execute(sql, dbName = dbInfo['database'], params = params)

  return True


def database_setup():
  database_ddl()
  database_init_data()
  # database_init_data_geo()

  # database_init_kapa()

  return True
