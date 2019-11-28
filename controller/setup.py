# encoding=utf-8

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

        SETTINGS['mysql_info'] = params

        return True
    except:
        return False

    return False

def database_setup():
    mysqlInfo = SETTINGS['mysql_info']

    with database(mysqlInfo) as db:
        db.create_db("Forethought", "Forethought", "123321")

        db.

def database_create():
    return True