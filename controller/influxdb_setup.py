# encoding=utf-8

import shortuuid
import json

from . import SETTINGS
from .db_helper import dbHelper

from influxdb import InfluxDBClient


def influxdb_ping(db):
    dbInfo = {
        "host": db.get('host'),
        "port": int(db.get('port')),
        "username": db.get('username'),
        "password": db.get('password'),
        "ssl": db.get('ssl')
    }

    client = InfluxDBClient(**dbInfo)

    pingError = True

    try:
        pingError = not client.ping()
    except:
        pingError = True
        pass

    db["pingError"] = pingError

    return True

def influxdb_ping_all(dbs):
    for db in dbs:
        influxdb_ping(db)

    influxdb = SETTINGS['influxdb']

    SETTINGS['influxdb'] = n = []
    for idx, db in enumerate(dbs):
        n.append(dict(influxdb[idx] if idx < len(influxdb) else {}, **db))

    print(SETTINGS['influxdb'])

    return True


def influxdb_remove(d):
    idx = d['index']

    if len(SETTINGS['influxdb']) > idx:
        del SETTINGS['influxdb'][idx]

    return True


def influxdb_add(dbs):
    influxdb = SETTINGS['influxdb']

    SETTINGS['influxdb'] = n = []
    for idx, db in enumerate(dbs):
        n.append(dict(influxdb[idx] if idx < len(influxdb) else {}, **db))

    n.append({})

    return True

def _init_influxdb(instance):
    dbInfo = {
        "host": instance.get('host'),
        "port": int(instance.get('port')),
        "username": instance.get('username'),
        "password": instance.get('password'),
        "ssl": instance.get('ssl')
    }

    client = InfluxDBClient(**dbInfo)

    dbNames = ['ifdb_forethought_alert', 'ifdb_forethought_baseline', 'ifdb_ftinternal']

    userDB = instance.get('dbName', '').strip()
    if userDB:
        dbNames.append(userDB)

    for db in dbNames:
        params = {
            "db": db,
            "rp": "rp_365",
            "ro_user": dbInfo['username'], 
            "rw_user": dbInfo['password']
        }

        querySQL = '''
            CREATE DATABASE {db};
            CREATE RETENTION POLICY "{rp}" ON "{db}" DURATION 365d REPLICATION 1 DEFAULT;
            GRANT READ ON {db} TO {ro_user};
            GRANT WRITE ON {db} TO {rw_user};
        '''.format(**params)

        client.query(querySQL)

    return True


def _init_db_instance(instance):
    user = {
        "username": instance.get('username'),
        "password": instance.get('password')
    }

    authorization = {
                    "ro": user,
                    "wr": user,
                    "admin": user
                }

    mysqlInfo = SETTINGS['mysql']
    dbInfo = SETTINGS['core']['dbInfo']

    with dbHelper(mysqlInfo) as db:
        # influx instance 
        influxdb_uuid = "iflx-" + shortuuid.ShortUUID().random(length = 24)
        host = "{protocol}://{host}:{port}".format(**{
                "protocol": 'https' if instance.get('ssl') else 'http',
                "host": instance.get('host'),
                "port": instance.get('port')
            })

        params = [
            influxdb_uuid,
            host,
            json.dumps(authorization)
        ]
        sql = "INSERT INTO `main_influx_instance` (`uuid`, `host`, `authorization`, `dbcount`, `user`, `pwd`, `status`) VALUES (%s, %s, %s, 4, '', '', 0);"
        db.execute(sql, dbName = dbInfo['dbName'], params = params)

        kapacitorHost = instance.get('kapacitorHost')

        if kapacitorHost:
            # kapa instance
            params = [
                "kapa-" + shortuuid.ShortUUID().random(length = 24),
                instance.get('kapacitorHost'),
                influxdb_uuid
            ]
            sql = "INSERT INTO `main_kapa` (`uuid`, `host`, `influxInstanceUUID`, `status`) VALUES (%s, %s, %s, 0);"
            db.execute(sql, dbName = dbInfo['dbName'], params = params)

    return True


def init_influxdb_all():
    instances = SETTINGS['influxdb']

    for instance in instances:
        _init_influxdb(instance)
        _init_db_instance(instance)

    return True

