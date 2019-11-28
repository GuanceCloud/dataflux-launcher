# encoding=utf-8

import os
import shortuuid
import pymysql


from .database import database
from . import SETTINGS


def do_check():
    return {"status": "check OK"}


def database_ping(params):
    params['port'] = int(params['port'])

    try:
        connect = pymysql.connect(**params)

        connect.close()

        SETTINGS['mysqlInfo'] = params

        return True
    except:
        return False

    return False


def database_setup():
    mysqlInfo = SETTINGS['mysqlInfo']

    SETTINGS['forethoughtDbInfo'] = dbInfo = {
        "dbName": "Forethought",
        "dbUser": "Forethought",
        "dbUserPassword": shortuuid.ShortUUID().random(length=12)
    }

    with database(mysqlInfo) as db:
        db.create_db(**dbInfo)

        with open(os.path.abspath("resource/ddl/core.sql"), 'r') as f:
            ddl = f.read()
            db.import_ddl("Forethought", ddl)

    return True # SETTINGS['forethoughtDbInfo']


def database_create():
    return True