# encoding=utf-8

import shortuuid
import json
import time
import requests

from launcher.utils.helper import api_helper as apiHelper
from launcher.utils.helper.db_helper import dbHelper
from launcher import settingsMdl


def studio_data_upgrade():
  print('studio data upgrade')
  ping_url  = "http://inner.forethought-core:5000/api/v1/inner/const/ping"
  url       = "http://inner.forethought-core:5000/api/v1/inner/upgrade/fix_data"

  for i in range(0, 30):
    content, status_code = apiHelper.do_get(ping_url)
    if status_code == 200:
      break

    time.sleep(1)

  if status_code != 200:
    return False
  else:
    d1 = { "script_name": "fix_2022_04_21_update_rules_funcid" }
    d2 = { "script_name": "fix_2022_04_21_update_agg_to_metric_rule" }
    d3 = { "script_name": "timed_sync_integration", "func_name": "timed_sync_gitee_code", "funcKwargs": {"need_sync_integration": True} }

    apiHelper.do_post(url, data = d1)
    apiHelper.do_post(url, data = d2)
    apiHelper.do_post(url, data = d3)

  return True


def kodo_object_ilm_upgrade():
  print('kodo object ilm upgrade')
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
      # url = "http://daily-ft2x-kodo-inner-api.cloudcare.cn/v1/inner/modify_old_object_ilm"
      url = "http://kodo-inner.forethought-kodo:9527/v1/inner/modify_old_object_ilm"

      content, status_code = apiHelper.do_post(url)

      if status_code != 200:
          return False

  return True


def after_container_update():

  kodo_object_ilm_upgrade()
  studio_data_upgrade()

  return True
