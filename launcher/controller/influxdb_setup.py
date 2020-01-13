# encoding=utf-8

import shortuuid
import json
import time

from .db_helper import dbHelper
from launcher import SETTINGS, SERVICECONFIG

from influxdb import InfluxDBClient


def influxdb_ping(db):
  dbInfo = {
    "host": db.get('host'),
    "port": int(db.get('port')),
    "username": db.get('username'),
    "password": db.get('password'),
    "ssl": db.get('ssl')
  }

  pingError = True
  client = InfluxDBClient(**dbInfo)

  try:
    pingError = not client.ping()

    if pingError:
      return False

    client.query("SHOW DATABASES")
  except:
    pingError = True

  db["pingError"] = pingError

  return not pingError

def influxdb_ping_all(dbs):
  for db in dbs:
    influxdb_ping(db)

  influxdb = SETTINGS['influxdb']

  SETTINGS['influxdb'] = n = []
  for idx, db in enumerate(dbs):
    n.append(dict(influxdb[idx] if idx < len(influxdb) else {}, **db))

  return [{"pingError": item['pingError']} for item in n]


def influxdb_remove(d):
  idx = d['index']

  if len(SETTINGS['influxdb']) == 1:
    return True

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

def __insert_rp_to_mysql():
  mysqlInfo = SETTINGS['mysql']
  mysqlDBInfo = SETTINGS['core']['dbInfo']
  rps = SERVICECONFIG['influxDB']['replication']

  sql = '''
          INSERT INTO `main_influx_rp` (`uuid`, `name`, `duration`, `shardGroupDuration`, `replication`, `status`, `creator`, `updator`, `createAt`)
          VALUES (%s, %s, %s, '', 1, 0, '', '', UNIX_TIMESTAMP());
        '''

  with dbHelper(mysqlInfo) as dbClient:
    for rp in rps:
      rpName = rp['rpName']
      duration = rp['duration']
      rpUUID = "ifrp_" + shortuuid.ShortUUID().random(length = 24)

      params = (
          rpUUID,
          rpName,
          duration
      )

      dbClient.execute(sql, dbName = mysqlDBInfo['dbName'], params = params)

  return True


def _init_influxdb_create_db(influxDBInfo, defaultRP, dbName):
  client = InfluxDBClient(**influxDBInfo)
  rps = SERVICECONFIG['influxDB']['replication']

  params = {
    "db": dbName,
    "ro_user": influxDBInfo['username'], 
    "rw_user": influxDBInfo['username']
  }

  querySQL = '''
    CREATE DATABASE {db};
    GRANT READ ON {db} TO {ro_user};
    GRANT WRITE ON {db} TO {rw_user};
  '''.format(**params)

  # defaultRPName = ''
  rpSQLs = []
  for rp in rps:
    isDefault = rp['rpName'] == defaultRP
    p = {
      "rp": rp['rpName'],
      "duration": rp['duration'],
      "db": dbName,
      "default": 'DEFAULT' if isDefault else ''
    }

    rpSQLs.append('CREATE RETENTION POLICY "{rp}" ON "{db}" DURATION {duration}h REPLICATION 1 {default};'.format(**p))

  querySQL = querySQL + ''.join(rpSQLs)

  client.query(querySQL)

  return True


def _init_influxdb(instanceUUID, instance):
  mysqlInfo = SETTINGS['mysql']
  mysqlDBInfo = SETTINGS['core']['dbInfo']

  influxDBInfo = {
    "host": instance.get('host'),
    "port": int(instance.get('port')),
    "username": instance.get('username'),
    "password": instance.get('password'),
    "ssl": instance.get('ssl')
  }

  defaultRP = instance.get('defaultRP')
  dbNames = [item for item in SERVICECONFIG['influxDB']['databases']]  # ['internal_alert', 'internal_baseline', 'internal_system', 'internal_keyevent']

  userDB = instance.get('dbName', '').strip()
  if userDB:
    dbNames.append(userDB)

  dbUUIDs = {}

  for dbName in dbNames:
    _init_influxdb_create_db(influxDBInfo, defaultRP, dbName)

    with dbHelper(mysqlInfo) as dbClient:
      db_uuid = "ifdb_" + shortuuid.ShortUUID().random(length = 24)
      params = (
          db_uuid,
          dbName,
          instanceUUID,
          defaultRP
      )

      sql = "INSERT INTO `main_influx_db` (`uuid`, `db`, `influxInstanceUUID`, `influxRpName`, `status`, `createAt`) VALUES (%s, %s, %s, %s, 0, UNIX_TIMESTAMP());"
      dbClient.execute(sql, dbName = mysqlDBInfo['dbName'], params = params)

      dbUUIDs[dbName] = db_uuid

  return dbUUIDs


def _init_system_workspace(sysDBUUID):
  mysqlInfo = SETTINGS['mysql']
  dbInfo = SETTINGS['core']['dbInfo']

  with dbHelper(mysqlInfo) as db:
    ws_uuid = "wksp_system"
    token = "tokn_" + shortuuid.ShortUUID().random(length = 24)
    params = [
        ws_uuid,
        token,
        sysDBUUID
    ]
    wsSQL = '''
              INSERT INTO `main_workspace` (`uuid`, `name`, `token`, `dataRestriction`, `dbUUID`, `dashboardUUID`, `exterId`, `desc`, `bindInfo`, `createAt`) 
              VALUES (%s, '系统工作空间', %s, '{}', %s, NULL, '', NULL, '{}', UNIX_TIMESTAMP());
            '''
    db.execute(wsSQL, dbName = dbInfo['dbName'], params = params)

    # 工作空间 AK
    akSQL = '''
              INSERT INTO `main_workspace_accesskey` (`uuid`, `ak`, `sk`, `workspaceUUID`, `creator`, `updator`, `status`, `createAt`) 
              VALUES (%s, %s, %s, 'wksp_system', '', '', 0, UNIX_TIMESTAMP());
            '''
    params = [
              "wsak_" + shortuuid.ShortUUID().random(length = 24),
              shortuuid.ShortUUID().random(length = 16),
              shortuuid.ShortUUID().random(length = 32)
            ]
    db.execute(akSQL, dbName = dbInfo['dbName'], params = params)

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
    influxdb_uuid = "iflx_" + shortuuid.ShortUUID().random(length = 24)
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
    sql = "INSERT INTO `main_influx_instance` (`uuid`, `host`, `authorization`, `dbcount`, `user`, `pwd`, `status`, `createAt`) VALUES (%s, %s, %s, 4, '', '', 0, UNIX_TIMESTAMP());"
    db.execute(sql, dbName = dbInfo['dbName'], params = params)

    # kapacitorHost = instance.get('kapacitorHost')

    # if kapacitorHost:
    #   # kapa instance
    #   params = [
    #     "kapa-" + shortuuid.ShortUUID().random(length = 24),
    #     instance.get('kapacitorHost'),
    #     influxdb_uuid
    #   ]
    #   sql = "INSERT INTO `main_kapa` (`uuid`, `host`, `influxInstanceUUID`, `status`) VALUES (%s, %s, %s, 0);"
    #   db.execute(sql, dbName = dbInfo['dbName'], params = params)

  return influxdb_uuid


def init_influxdb_all():
  instances = SETTINGS['influxdb']
  __insert_rp_to_mysql()

  for idx, instance in enumerate(instances):
    instanceUUID = _init_db_instance(instance)

    # 创建系统工作空间
    if idx == 0:
      dbUUIDs = _init_influxdb(instanceUUID, instance)
      _init_system_workspace(dbUUIDs['internal_system'])

  return True

