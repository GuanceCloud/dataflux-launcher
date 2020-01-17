# encoding=utf-8

import os
import shortuuid
import pymysql


from launcher.utils.helper.db_helper import dbHelper
from launcher import SETTINGS, SERVICECONFIG

def database_create_db():
  mysqlInfo = SETTINGS['mysql']
  dbInfo = SETTINGS['messageDesk']['dbInfo']

  # dbSQL = "CREATE DATABASE IF NOT EXISTS {dbName} DEFAULT CHARSET utf8 COLLATE utf8_general_ci;".format(**dbInfo)
  # userSQL = "CREATE USER '{dbUser}'@'%' IDENTIFIED BY '{dbUserPassword}'; GRANT ALL PRIVILEGES ON {dbName}.* TO '{dbUser}'@'%' WITH GRANT OPTION;".format(**dbInfo)
  SQL = '''
        SET SQL_MODE = 'NO_AUTO_CREATE_USER';CREATE DATABASE IF NOT EXISTS {dbName} DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
        CREATE USER '{dbUser}'@'%' IDENTIFIED BY '{dbUserPassword}';
        GRANT ALL PRIVILEGES ON {dbName}.* TO '{dbUser}'@'%';
        '''.format(**dbInfo)

  with dbHelper(mysqlInfo) as db:
    db.execute(SQL)

  return True


def database_ddl():
  mysqlInfo = SETTINGS['mysql']

  SETTINGS['messageDesk']['dbInfo'] = dbInfo = {
    "dbName": SERVICECONFIG['databases']['message_desk'],
    "dbUser": SERVICECONFIG['databases']['message_desk'],
    "dbUserPassword": shortuuid.ShortUUID().random(length=12)
  }

  database_create_db()

  with dbHelper(mysqlInfo) as db:
    with open(os.path.abspath("launcher/resource/v1/ddl/message-desk.sql"), 'r') as f:
      ddl = f.read()
      db.execute(ddl, dbName = dbInfo['dbName'])

  return True


def database_init_data():
  mysqlInfo = SETTINGS['mysql']
  dbInfo = SETTINGS['messageDesk']['dbInfo']

  with dbHelper(mysqlInfo) as db:
    with open(os.path.abspath("launcher/resource/v1/data/message-desk.sql"), 'r') as f:
      sql = f.read()
      db.execute(sql, dbName = dbInfo['dbName'])

  return True


def database_setup():
  database_ddl()
  database_init_data()

  return True
