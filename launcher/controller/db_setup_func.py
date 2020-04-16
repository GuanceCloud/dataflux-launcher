# encoding=utf-8

import os, shortuuid, pymysql, hashlib

from launcher.utils.helper.db_helper import dbHelper
from launcher import settingsMdl, SERVICECONFIG


def database_create_db():
  mysqlSetting = settingsMdl.mysql
  mysqlInfo = mysqlSetting.get('base')
  dbInfo = mysqlSetting.get('func')

  SQL = '''
        SET SQL_MODE = 'NO_AUTO_CREATE_USER';
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
    "database": SERVICECONFIG['databases']['func'],
    "user": SERVICECONFIG['databases']['func'],
    "password": shortuuid.ShortUUID().random(length=12)
  }

  settingsMdl.mysql = {'func': dbInfo}

  database_create_db()

  with dbHelper(mysqlInfo) as db:
    with open(os.path.abspath("launcher/resource/v1/ddl/func.sql"), 'r') as f:
      ddl = f.read()
      db.execute(ddl, dbName = dbInfo['database'])

  return True


def _secret_password(salt, secret):
  p = "~{}~{}~{}~".format(salt, '~func@admin#42~', secret)
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

  mysqlSetting = settingsMdl.mysql
  mysqlInfo = mysqlSetting.get('base')
  dbInfo = mysqlSetting.get('func')

  otherSetting = settingsMdl.other

  with dbHelper(mysqlInfo) as db:
    userId = "u-" + shortuuid.ShortUUID().random(length = 24)
    secret = otherSetting.get('func', {}).get('secret')
    password = _secret_password(userId, secret)

    db.execute(sql, dbName = dbInfo['database'])

    params = (userId,  password)
    db.execute(userSql, dbName = dbInfo['database'], params = params)

  return True


def database_setup():
  database_ddl()
  # database_init_data()
  database_account_create()

  return True

