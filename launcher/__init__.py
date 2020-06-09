# encoding=utf-8

import os, yaml, json

from launcher.model.settings import Settings

STEPS_COMMON = [
  {
      "key": "/",
      "name": "使用协议",
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
      "key": "/install/elasticsearch",
      "name": "Elasticsearch 设置"
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
# 3、应用配置升级
# 4、数据库升级
# 5、应用更新（升级与新增）
# 6、升级完成

STEPS_UPDATE = [
  {
      "key": "/up/preparation",
      "name": "升级准备"
  },
  {
      "key": "/up/newconfigmap",
      "name": "新增应用配置"
  },
  {
      "key": "/up/configmap",
      "name": "升级应用配置"
  },
  {
      "key": "/up/database",
      "name": "升级数据库"
  },
  {
      "key": "/up/service",
      "name": "升级应用"
  },
  {
      "key": "/up/service/status",
      "name": "应用启动状态"
  }
]


# SETTINGS = {}
SERVICECONFIG = {}
DOCKERIMAGES = {}

CACHEDATA = {}

settingsMdl = None

def __init_config():
  global SERVICECONFIG

  base_path = os.path.dirname(os.path.abspath(__file__))
  with open(base_path + "/../config/config.yaml") as f:
    SERVICECONFIG  = yaml.safe_load(f)

  tmpDir = SERVICECONFIG['tmpDir']
  if not os.path.exists(tmpDir):
    os.mkdir(tmpDir)


def __init_docker_image():
  global DOCKERIMAGES

  base_path = os.path.dirname(os.path.abspath(__file__))
  if not os.path.exists(base_path + "/../config/docker-image.yaml"):
    return

  with open(base_path + "/../config/docker-image.yaml") as f:
    DOCKERIMAGES = yaml.safe_load(f)


def __init_settings():
  # global SETTINGS
  global settingsMdl

  settingsMdl = Settings()


__init_config()
__init_docker_image()
__init_settings()

