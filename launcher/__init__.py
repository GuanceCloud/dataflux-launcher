# encoding=utf-8

import os, yaml, json

STEPS_COMMON = [
  {
      "key": "/",
      "name": "安装说明",
      "status": ""
  },
  {
      "key": "/check",
      "name": "环境检查",
      "status": ""
  }
]

STEPS_INSTALL = [
  {
      "key": "/install/database",
      "name": "MySQL 设置"
  },
  {
      "key": "/install/redis",
      "name": "Redis 设置"
  },
  {
      "key": "/install/influxdb",
      "name": "InfluxDB 设置"
  },
  {
      "key": "/install/other",
      "name": "其他设置"
  },
  {
      "key": "/install/setup/info",
      "name": "安装信息"
  },
  {
      "key": "/install/config/review",
      "name": "应用配置文件"
  },
  {
      "key": "/install/service/config",
      "name": "应用镜像"
  },
  {
      "key": "/install/service/status",
      "name": "应用状态"
  }
]

# 1、namespace 更新 + PVC 更新
# 2、新增应用配置
# 3、应用更新（升级与新增）
# 4、应用配置升级
# 5、数据库升级
# 6、升级完成

STEPS_UPDATE = [
  # {
  #     "key": "/up/newconfig",
  #     "name": "新增应用配置"
  # },
  {
      "key": "/up/service",
      "name": "应用升级"
  },
  {
      "key": "/up/configmap",
      "name": "升级应用配置"
  },
  {
      "key": "/up/database",
      "name": "数据库升级"
  }
]


SETTINGS = {}
SERVICECONFIG = {}
DOCKERIMAGES = {}

def __init_config():
  global SERVICECONFIG

  base_path = os.path.dirname(os.path.abspath(__file__))
  with open(base_path + "/../config/config.yaml") as f:
    SERVICECONFIG  = yaml.safe_load(f)

def __init_docker_image():
  global DOCKERIMAGES

  base_path = os.path.dirname(os.path.abspath(__file__))
  if not os.path.exists(base_path + "/../config/docker-image.yaml"):
    return

  with open(base_path + "/../config/docker-image.yaml") as f:
    DOCKERIMAGES = yaml.safe_load(f)


def __init_settings():
  global SETTINGS

  if not SERVICECONFIG['debug']:
    SETTINGS = {
      "mysql": {},
      "redis": {},
      "influxdb": [{}],
      "messageDesk": {},
      "core": {
        "dbInfo": {},
        "secret": {}
      },
      "func": {
        "dbInfo": {}
      },
      "other": {
        "manager": {
          "username": "",
          "email": ""
        },
        "domain": "",
        "subDomain": {
          "console": "console",
          "consoleApi": "console-api",
          "management": "management",
          "managementApi": "management-api",
          "websocket": "ws",
          "function": "func",
          "kodo": "kodo",
          "integration": "integration"
        }
      },
      "serviceConfig": {}
    }


  else:
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
        "domain": "",
        "subDomain": {
          "console": "console",
          "consoleApi": "console-api",
          "management": "management",
          "managementApi": "management-api",
          "websocket": "ws",
          "function": "func",
          "kodo": "kodo",
          "integration": "integration"
        }
      },
      "serviceConfig":{}
    }


__init_config()
__init_docker_image()
__init_settings()


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
