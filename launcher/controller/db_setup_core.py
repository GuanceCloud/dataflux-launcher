

# encoding=utf-8

import os
import shortuuid
import pymysql
import time


from launcher.utils.helper.db_helper import dbHelper
from launcher import SETTINGS, SERVICECONFIG

def database_ping(params):
  params['port'] = int(params['port'])

  with dbHelper(params) as db:
    if not db.connection:
      return {"connected": False}

    sql = "SHOW DATABASES;"
    result = db.execute(sql)

    SETTINGS["mysql"] = params
    if len(result) == 0:
      return {"connected": True}

    dbNames = []
    for line in result[0]:
      dbName = line[0]
      if dbName in SERVICECONFIG['databases'].values():
        dbNames.append(dbName)

  return {"connected": True, "dbNames": dbNames}

def database_create_db():
  mysqlInfo = SETTINGS['mysql']
  dbInfo = SETTINGS['core']['dbInfo']

  SQL = '''
        SET SQL_MODE = 'NO_AUTO_CREATE_USER';CREATE DATABASE IF NOT EXISTS {dbName} DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
        CREATE USER '{dbUser}'@'%' IDENTIFIED BY '{dbUserPassword}';
        GRANT ALL PRIVILEGES ON {dbName}.* TO '{dbUser}'@'%';
        '''.format(**dbInfo)

  # print(mysqlInfo)
  with dbHelper(mysqlInfo) as db:
    db.execute(SQL)

  return True


def database_ddl():
  mysqlInfo = SETTINGS['mysql']

  SETTINGS['core']['dbInfo'] = dbInfo = {
    "dbName": SERVICECONFIG['databases']['core'],
    "dbUser": SERVICECONFIG['databases']['core'],
    "dbUserPassword": shortuuid.ShortUUID().random(length=12)
  }

  database_create_db()

  with dbHelper(mysqlInfo) as db:
    with open(os.path.abspath("launcher/resource/v1/ddl/core.sql"), 'r') as f:
      ddl = f.read()
      db.execute(ddl, dbName = dbInfo['dbName'])

  return True


def database_init_data():
  mysqlInfo = SETTINGS['mysql']
  dbInfo = SETTINGS['core']['dbInfo']

  with dbHelper(mysqlInfo) as db:
    with open(os.path.abspath("launcher/resource/v1/data/core.sql"), 'r') as f:
      sql = f.read()
      db.execute(sql, dbName = dbInfo['dbName'])

  return True


def database_manage_account_create():
  sql = '''
      INSERT INTO `main_manage_account` (`uuid`, `name`, `username`, `password`, `email`, `mobile`, `createAt`)
      VALUES (%s, '管理员', %s, %s, %s, '', UNIX_TIMESTAMP());
    '''

  mysqlInfo = SETTINGS['mysql']
  dbInfo = SETTINGS['core']['dbInfo']
  accountInfo = SETTINGS['other'].get('manager', {})

  username = accountInfo.get('username')
  email = accountInfo.get('email')

  if username:
    with dbHelper(mysqlInfo) as db:
      password = 'pbkdf2:sha256:150000$dSCmDxZJ$76950c22b74ce70f468612afe2e313a1fb527cd05902c61bf25f0eedcefd9dfd'

      params = ('mact-' + shortuuid.ShortUUID().random(length = 24), username, password, email)

      db.execute(sql, dbName = dbInfo['dbName'], params = params)

  return True


def database_setup():
  database_ddl()
  database_init_data()

  return True
