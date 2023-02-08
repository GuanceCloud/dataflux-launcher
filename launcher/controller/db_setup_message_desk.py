# encoding=utf-8

import os
import shortuuid
import pymysql


from launcher.utils.helper.db_helper import dbHelper
from launcher import settingsMdl, SERVICECONFIG

def database_create_db():
  mysqlSetting = settingsMdl.mysql
  mysqlInfo = mysqlSetting.get('base')
  dbInfo = mysqlSetting.get('messageDesk')

  SQL = '''
        CREATE DATABASE IF NOT EXISTS {database} DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
        CREATE USER '{user}'@'%' IDENTIFIED BY '{password}';
        GRANT ALL PRIVILEGES ON {database}.* TO '{user}'@'%';
        '''.format(**dbInfo)

  with dbHelper(mysqlInfo) as db:
    db.execute(SQL)

  return True


def database_ddl():
  mysqlSetting = settingsMdl.mysql
  mysqlInfo = mysqlSetting.get('base')

  dbInfo = {
    "database": SERVICECONFIG['databases']['message_desk'],
    "user": SERVICECONFIG['databases']['message_desk'],
    "password": shortuuid.ShortUUID().random(length=12)
  }

  settingsMdl.mysql = {'messageDesk': dbInfo}

  database_create_db()

  with dbHelper(mysqlInfo) as db:
    with open(os.path.abspath("launcher/resource/v1/ddl/message-desk.sql"), 'r') as f:
      ddl = f.read()
      db.execute(ddl, dbName = dbInfo['database'])

  return True


def database_init_data():
  mysqlSetting = settingsMdl.mysql
  mysqlInfo = mysqlSetting.get('base')
  dbInfo = mysqlSetting.get('messageDesk')

  with dbHelper(mysqlInfo) as db:
    with open(os.path.abspath("launcher/resource/v1/data/message-desk.sql"), 'r') as f:
      sql = f.read()
      db.execute(sql, dbName = dbInfo['database'])

  return True


def database_setup():
  database_ddl()
  database_init_data()

  return True
