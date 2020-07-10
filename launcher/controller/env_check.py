# encoding=utf-8

import os, re, subprocess
import json, time

import redis
import pymysql
from influxdb import InfluxDBClient
from elasticsearch import Elasticsearch, RequestsHttpConnection

from launcher.utils.helper.db_helper import dbHelper
from launcher import SERVICECONFIG, settingsMdl


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
  
  params = {

            "host": redisSettings['host'],
            "password": redisSettings['password'],
            "port": redisSettings['port']
          }

  params['port'] = int(params['port'])

  strictRedis = redis.StrictRedis(**params)

  pingStatus = False

  try:
    pingStatus =strictRedis.ping()
  except:
    pingStatus = False

  return {"key": params['host'], "status": pingStatus}


def __influxdb_ping():
  influxdbSettings = settingsMdl.influxdb
  result = []

  for item in influxdbSettings:
    dbInfo = {
      "host": item.get('host', '').strip(),
      "port": int(item.get('port', '0').strip()),
      "username": item.get('username', '').strip(),
      "password": item.get('password', '').strip(),
      "ssl": item.get('ssl')
    }

    pingError = True
    client = InfluxDBClient(**dbInfo)

    try:
      pingError = not client.ping()

      if not pingError:
        client.query("SHOW DATABASES")
    except:
      pingError = True

    result.append({
        "key": dbInfo['host'],
        "status": not pingError
      })

  return result


def __elasticsearch_ping():
  esSettings = settingsMdl.elasticsearch

  params = {  
    "host": esSettings['host'],
    "port": int(esSettings['port']),
    "ssl": esSettings['ssl'],
    "user": esSettings['user'],
    "password": esSettings['password']
  }

  esHosts   = [{
                'host': params.get('host'),
                'port': params.get('port')
              }]
  http_auth = (params.get('user'), params.get('password'))
  use_ssl   = params.get('ssl', False)

  es = Elasticsearch(esHosts, http_auth = http_auth, use_ssl = use_ssl, connection_class = RequestsHttpConnection)

  pingStatus = False
  try:
    pingStatus =es.ping()
  except:
    pingStatus = False

  return {"key": params['host'], "status": pingStatus}


def __mysql_ping():
  mysqlSettings = settingsMdl.mysql

  params = {
      "host": mysqlSettings['base']['host'],
      "port": int(mysqlSettings['base']['port'])
  }

  dbs = ['core', 'func', 'messageDesk']

  result = []

  for dbName in dbs:
    params['user'] = mysqlSettings[dbName]['user']
    params['password'] = mysqlSettings[dbName]['password']

    with dbHelper(params) as db:
      result.append({
          "key": dbName,
          "status": not db.connection
        })

  return result


def db_setting_check():
  return {
            "mysql": __mysql_ping(),
            "influxdb": __influxdb_ping(),
            "redis": __redis_ping(),
            "elasticsearch": __elasticsearch_ping()
          }


def do_check():
  checkResult = {
                    "clusterInfo": __get_k8s_cluster_info()
                }

  if len(checkResult['clusterInfo']) > 0:
    checkResult['deploy_info'] = __deploy_info()

  if len(checkResult['clusterInfo']) > 0:
    checkResult['storage'] = __get_storageclass()

  return checkResult


