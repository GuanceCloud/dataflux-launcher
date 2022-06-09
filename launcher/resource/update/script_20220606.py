# encoding=utf-8

import shortuuid
import json
import time
import requests

from launcher.utils.helper import api_helper as apiHelper
from launcher.utils.helper.db_helper import dbHelper
from launcher import settingsMdl


def migration_metering_data():
  print('migration metering data')
  ping_url  = "http://kodo-inner.forethought-kodo:9527/v1/ping"
  url       = "http://kodo-inner.forethought-kodo:9527/v1/migration/influxdb_to_es"

  for i in range(0, 30):
    content, status_code = apiHelper.do_get(ping_url)
    if status_code == 200:
      break

    time.sleep(1)

  if status_code != 200:
    return False
  else:
    apiHelper.do_post(url)

  return True


def kodo_create_metering_index():
  print('kodo create metering index')
  # url = "http://daily-ft2x-kodo-inner-api.cloudcare.cn/v1/ping"
  url = "http://kodo-inner.forethought-kodo:9527/v1/ping"
  for i in range(0, 30):
    content, status_code = apiHelper.do_get(url)
    if status_code == 200:
      break

    time.sleep(1)

  if status_code != 200:
      return False
  else:
      # url = "http://daily-ft2x-kodo-inner-api.cloudcare.cn/v1/es/create_metering"
      url = "http://kodo-inner.forethought-kodo:9527/v1/es/create_metering"

      content, status_code = apiHelper.do_post(url)

      if status_code != 200:
          return False

  return True


def after_container_update():

  kodo_create_metering_index()
  migration_metering_data()

  return True
