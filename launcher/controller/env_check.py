# encoding=utf-8

import os, re, subprocess
import json, time

import redis
import pymysql
import requests

from requests.auth import HTTPBasicAuth
from influxdb import InfluxDBClient

from launcher.utils.helper.db_helper import dbHelper
from launcher.model import version as versionMdl
from launcher import SERVICECONFIG, settingsMdl, DOCKERIMAGES


def __get_k8s_cluster_info():
  cmd = "kubectl cluster-info"
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  output, err = p.communicate()

  if not output:
      return []

  output = str(output, encoding = "utf-8")
  clusterInfo = []

  for line in output.split('\n'):
    if 'is running at' not in line:
        continue

    clusterInfo.append(re.sub(r"\x1b\[\d+(;\d+)?m", "", line))

  return clusterInfo


def __deploy_info():
  cmd = "kubectl get namespaces {} -o json".format(' '.join(SERVICECONFIG['namespaces']))
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  output, err = p.communicate()
  namespaceJson = json.loads(output)

  namespaces = [ ns['metadata']['name'] for ns in namespaceJson['items'] ]

  return '; '.join(namespaces)


def __get_storageclass():
  cmd = "kubectl get storageclass -o json"
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  output, err = p.communicate()
  storage = json.loads(output)

  storageNames = []
  for item in storage['items']:
    storageNames.append(item['metadata']['name'])

  return '; '.join(storageNames)


def __redis_ping():
  redisSettings = settingsMdl.redis

  if 'host' not in redisSettings:
    return None
  
  params = {

            "host": redisSettings['host'],
            "password": redisSettings['password'],
            "port": redisSettings['port'],
            "ssl": redisSettings.get('ssl', False)
          }

  params['port'] = int(params['port'])

  strictRedis = redis.StrictRedis(**params)

  pingStatus = False

  try:
    pingStatus =strictRedis.ping()
  except:
    pingStatus = False

  return {"key": "{}:{}".format(params['host'],  params['port']), "status": pingStatus}


def __tdengine_ping(dbInfo):
  pingError = True

  use_ssl = dbInfo.get('ssl', False)
  http_auth = HTTPBasicAuth(dbInfo.get('username'), dbInfo.get('password'))
  url = "{protocol}://{host}:{port}".format(**{"protocol": "https" if use_ssl else "http", "host": dbInfo.get('host'), "port": dbInfo.get('port')})

  try:
    resp = requests.get(url + "/-/ping", auth = http_auth)

    if resp.status_code == 200:
      pingError = False

    sql = "SHOW DATABASES"
    resp = requests.post(url + "/rest/sql", data = sql, auth = http_auth)

    if resp.status_code != 200:
      pingError = True
    else:
      result = resp.json()

      if result.get('code', -1) != 0:
        pingError = True
        return False
  except Exception as ex:
    print(ex)
    pingError = True

  return not pingError


def __influxdb_ping(db):
  dbInfo = {
    "host": db.get('host', '').strip(),
    "port": int(db.get('port', '').strip()),
    "username": db.get('username', '').strip(),
    "password": db.get('password', '').strip(),
    "ssl": db.get('ssl')
  }

  pingError = True
  client = InfluxDBClient(**dbInfo)

  try:
    pingError = not client.ping()

    if not pingError:
      client.query("SHOW DATABASES")
  except:
    pingError = True

  return not pingError


def __series_ping():
  influxdbSettings = settingsMdl.influxdb
  result = []  

  if not influxdbSettings[0]['host']:
    return None

  for item in influxdbSettings:
    dbInfo = {
      "host": item.get('host', '').strip(),
      "port": int(item.get('port', '0').strip()),
      "username": item.get('username', '').strip(),
      "password": item.get('password', '').strip(),
      "ssl": item.get('ssl')
    }

    engine = item.get('engine', "influxdb")
    if engine == 'influxdb':
      pingSuccess = __influxdb_ping(dbInfo)
    else:
      pingSuccess = __tdengine_ping(dbInfo)

    result.append({
        "key": "{}:{}".format(dbInfo['host'],  dbInfo['port']),
        "engine": engine,
        "status": pingSuccess
      })

  return result


def __elasticsearch_ping():
  esSettings = settingsMdl.elasticsearch

  if 'host' not in esSettings:
    return None

  params = {  
    "host": esSettings['host'],
    "port": int(esSettings['port']),
    "ssl": esSettings['ssl'],
    "user": esSettings['user'],
    "password": esSettings['password']
  }

  use_ssl = params.get('ssl', False)
  http_auth = HTTPBasicAuth(params.get('user'), params.get('password'))
  url = "{protocol}://{host}:{port}".format(**{"protocol": "https" if use_ssl else "http", "host": params.get('host'), "port": params.get('port')})

  pingStatus = False

  try:
    resp = requests.get(url, auth = http_auth)
    if resp.status_code == 200:
      pingStatus = True
  except Exception as e:
    print(e)

  return {"key": "{}:{}".format(params['host'],  params['port']), "status": pingStatus}


def __mysql_ping():
  mysqlSettings = settingsMdl.mysql

  if 'base' not in mysqlSettings:
    return None

  params = {
      "host": mysqlSettings['base']['host'],
      "port": int(mysqlSettings['base']['port'])
  }

  dbs = ['core', 'dataflux-func', 'messageDesk']
  result = {
          "dbs": [], 
          "server": {
              "host": params['host'],
              "port": params['port'],
              "status": False
            }
          }

  params['user'] = mysqlSettings['base']['user']
  params['password'] = mysqlSettings['base']['password']

  with dbHelper(params) as db:
      result['server']['status'] = not not db.connection

  for dbName in dbs:
    dbSetting = mysqlSettings.get(dbName)

    if not dbSetting:
      result['dbs'].append({
          "key": dbName,
          "status": False
        })
    else:
      params['user'] = dbSetting.get('user')
      params['password'] = dbSetting.get('password')

      try:
        with dbHelper(params) as db:
          result['dbs'].append({
              "key": dbName,
              "status": not not db.connection
            })
      except:
        result['dbs'].append({
            "key": dbName,
            "status": False
          })

  return result


def db_setting_check():
  return {
            "mysql": __mysql_ping(),
            "influxdb": __series_ping(),
            "redis": __redis_ping(),
            "elasticsearch": __elasticsearch_ping()
          }


def get_current_version():
  return {"version": versionMdl.get_current_version(), "launcher": DOCKERIMAGES["apps"]["version"]}


def do_check():
  checkResult = {
                    "clusterInfo": __get_k8s_cluster_info()
                }

  if len(checkResult['clusterInfo']) > 0:
    checkResult['deploy_info'] = __deploy_info()

  if len(checkResult['clusterInfo']) > 0:
    checkResult['storage'] = __get_storageclass()

  return checkResult


