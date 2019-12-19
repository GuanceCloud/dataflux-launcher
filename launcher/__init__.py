# encoding=utf-8

import os, yaml, json

# SETTINGS = {
#   "mysql": {},
#   "redis": {},
#   "influxdb": [{}],
#   "messageDesk": {},
#   "core": {
#     "dbInfo": {},
#     "secret": {}
#   },
#   "other": {
#     "manager": {
#     "username": "",
#     "email": ""
#     },
#     "domain": ""
#   },
#   "serviceConfig": {}
# }

STEPS = [
    {
        "key": "/",
        "name": "安装说明",
        "status": ""
    },
    {
        "key": "/check",
        "name": "环境检查",
        "status": ""
    },
    {
        "key": "/database",
        "name": "MySQL 配置"
    },
    {
        "key": "/redis",
        "name": "Redis 配置"
    },
    {
        "key": "/influxdb",
        "name": "InfluxDB 配置"
    },
    {
        "key": "/other",
        "name": "其他配置"
    },
    {
        "key": "/setup/info",
        "name": "安装信息"
    },
    {
        "key": "/config/review",
        "name": "应用配置信息"
    },
    {
        "key": "/service/config",
        "name": "应用配置镜像"
    },
    {
        "key": "/service/status",
        "name": "应用服务状态"
    }
]

SERVICECONFIG = {}

def init_config():
    global SERVICECONFIG

    base_path = os.path.dirname(os.path.abspath(__file__))
    with open(base_path + "/../config/config.yaml") as f:
        SERVICECONFIG  = yaml.safe_load(f)

    # print(json.dumps(ServiceConfig, indent=4))

init_config()

# test data
SETTINGS = {
  "mysql": {
    "host": "172.16.0.43",
    "port": 32306,
    "user": "root",
    "password": "rootPassw0rd"
  },
  "core": {
    "dbInfo": {
      "dbName": "Forethought",
      "dbUser": "Forethought",
      "dbUserPassword": "123321"
    },
    "secret": {}
  },
  "messageDesk": {
    "dbInfo": {
      "dbName": "",
      "dbUser": "",
      "dbUserPassword": ""
    }
  },
  "func": {
    "dbInfo": {
      "dbName": "ft_dp",
      "dbUser": "ft_dp",
      "dbUserPassword": "123321"
    }
  },
  "redis": {
    "host": "172.16.0.43",
    "port": 30397,
    "password": "viFRKZiZkoPmXnyF"
  },
  "influxdb": [
    {
      "host": "172.16.0.43",
      "port": 32086,
      "username": "admin",
      "password": "admin@influxdb",
      "ssl": False,
      "dbName": "test_db",
      "kapacitorHost": "http://127.0.0.1:1234"
    }
  ],
  "other": {
    "manager": {
      "username": "admin",
      "email": "lhm@jiagouyun.com"
    },
    "domain": ""
  },
  "serviceConfig":{}
}


''' 结构
  ============================

  mysql:
    host:
    port:
    user:
    password:

  core:
    dbInfo:
      dbName:
      dbUser:
      dbUserPassword:
    manager:
      username:
      email:

  messageDesk:
    dbInfo:
      dbName:
      dbUser:
      dbUserPassword:

  redis:
    host:
    port:
    password:

  influxdb:
  -   host:
    port:
    username:
    password:
    ssl:
    dbName:
    kapacitorHost:
  other:
    manager:
    domain
  serviceConfig:
'''
