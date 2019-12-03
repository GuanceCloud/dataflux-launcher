

# encoding=utf-8

import os
import shortuuid
import pymysql


from .db_helper import dbHelper
from . import SETTINGS

def database_ping(params):
    params['port'] = int(params['port'])

    with dbHelper(params) as db:
        if not db.connection:
            return False

        SETTINGS["mysql"] = params

    return True

def database_create_db():
    mysqlInfo = SETTINGS['mysql']
    dbInfo = SETTINGS['core']['dbInfo']

    dbSQL = "CREATE DATABASE IF NOT EXISTS {dbName} DEFAULT CHARSET utf8 COLLATE utf8_general_ci;".format(**dbInfo)
    userSQL = "GRANT ALL PRIVILEGES ON {dbName}.* TO '{dbUser}'@'%' IDENTIFIED BY '{dbUserPassword}';".format(**dbInfo)

    with dbHelper(mysqlInfo) as db:
        db.execute("{}{}".format(dbSQL, userSQL))

    return True


def database_ddl():
    mysqlInfo = SETTINGS['mysql']

    SETTINGS['core']['dbInfo'] = dbInfo = {
        "dbName": "Forethought",
        "dbUser": "Forethought",
        "dbUserPassword": shortuuid.ShortUUID().random(length=12)
    }

    database_create_db()

    with dbHelper(mysqlInfo) as db:
        with open(os.path.abspath("resource/v1/ddl/core.sql"), 'r') as f:
            ddl = f.read()
            db.execute(ddl, dbName = dbInfo['dbName'])

    return True


def database_init_data():
    mysqlInfo = SETTINGS['mysql']
    dbInfo = SETTINGS['core']['dbInfo']

    with dbHelper(mysqlInfo) as db:
        with open(os.path.abspath("resource/v1/data/core.sql"), 'r') as f:
            sql = f.read()
            db.execute(sql, dbName = dbInfo['dbName'])

    return True


def database_manage_account_create():
    sql = '''
            INSERT INTO `main_manage_account` (`uuid`, `name`, `username`, `password`, `email`, `mobile`)
            VALUES (%s, '管理员', %s, %s, %s, '');
        '''

    mysqlInfo = SETTINGS['mysql']
    dbInfo = SETTINGS['core']['dbInfo']
    accountInfo = SETTINGS['other'].get('manager', {})

    username = accountInfo.get('username')
    email = accountInfo.get('email')

    if not username:
        with dbHelper(mysqlInfo) as db:
            password = 'pbkdf2:sha256:150000$dSCmDxZJ$76950c22b74ce70f468612afe2e313a1fb527cd05902c61bf25f0eedcefd9dfd'

            params = ('mact-' + shortuuid.ShortUUID().random(length = 24), username, password, email)

            db.execute(sql, dbName = dbInfo['dbName'], params = params)

    return True


def database_setup():
    database_ddl()
    database_init_data()

    return True