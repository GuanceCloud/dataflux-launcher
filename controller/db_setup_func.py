# encoding=utf-8

import os, shortuuid, pymysql, hashlib

from .db_helper import dbHelper
from . import SETTINGS


def database_create_db():
  mysqlInfo = SETTINGS['mysql']
  dbInfo = SETTINGS['func']['dbInfo']

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

  SETTINGS['func']['dbInfo'] = dbInfo = {
    "dbName": "df_func",
    "dbUser": "df_func",
    "dbUserPassword": shortuuid.ShortUUID().random(length=12)
  }

  database_create_db()

  with dbHelper(mysqlInfo) as db:
    with open(os.path.abspath("resource/v1/ddl/func.sql"), 'r') as f:
      ddl = f.read()
      db.execute(ddl, dbName = dbInfo['dbName'])

  return True


# def database_init_data():
#   mysqlInfo = SETTINGS['mysql']
#   dbInfo = SETTINGS['func']['dbInfo']
#
#   with dbHelper(mysqlInfo) as db:
#     with open(os.path.abspath("resource/v1/data/func.sql"), 'r') as f:
#       sql = f.read()
#       db.execute(sql, dbName = dbInfo['dbName'])
#
#   return True


def _secret_password(salt, secret):
  p = "~{}~{}~{}~".format(salt, 'admin', secret)
  sha512 = hashlib.sha512()
  sha512.update(p.encode('utf-8'))

  return sha512.hexdigest()


def database_account_create():
  sql = '''
        TRUNCATE TABLE `wat_main_organization`;
        TRUNCATE TABLE `wat_main_user`;

        INSERT INTO `wat_main_organization` (`id`, `uniqueId`, `name`, `markers`)
        VALUES ('o-sys','system','System Organization',NULL);
    '''

  userSql =  '''
        INSERT INTO `wat_main_user` (`id`, `organizationId`, `username`, `passwordHash`, `name`, `mobile`, `markers`, `roles`, `customPrivileges`)
        VALUES (%s,'o-sys','admin',%s,'系统管理员',NULL,NULL,'sa','*');
    '''

  mysqlInfo = SETTINGS['mysql']
  dbInfo = SETTINGS['func']['dbInfo']

  with dbHelper(mysqlInfo) as db:
    userId = "u-" + shortuuid.ShortUUID().random(length = 24)
    secret = SETTINGS['func']['secret']
    password = _secret_password(userId, secret)

    db.execute(sql, dbName = dbInfo['dbName'])

    params = (userId,  password)
    db.execute(userSql, dbName = dbInfo['dbName'], params = params)

  return True


def database_setup():
  database_ddl()
  # database_init_data()
  database_account_create()

  return True

