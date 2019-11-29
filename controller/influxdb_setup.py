# encoding=utf-8

from . import SETTINGS
from influxdb import InfluxDBClient


def influxdb_ping(db):
    dbInfo = {
        "host": db.get('host'),
        "port": int(db.get('port')),
        "username": db.get('username'),
        "password": db.get('password'),
    }

    client = InfluxDBClient(**dbInfo)

    pingError = True

    try:
        pingError = client.ping()
        print(pingError)
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
