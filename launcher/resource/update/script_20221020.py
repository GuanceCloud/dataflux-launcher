# encoding=utf-8

import shortuuid
import json
import time
import requests

from launcher.utils.helper import api_helper as apiHelper


def fix_script_exec():
  print('rum black list upgrade')
  ping_url  = "http://inner.forethought-core:5000/api/v1/inner/const/ping"
  url       = "http://inner.forethought-core:5000/api/v1/inner/upgrade/fix_data"

  for i in range(0, 60):
    content, status_code = apiHelper.do_get(ping_url)
    if status_code == 200:
      break

    time.sleep(1)

  if status_code != 200:
    return False
  else:
    # black_list fix
    d1 = '{ "script_name": "fix_2022_10_20_checker_jsonscript_update" }'

    apiHelper.do_post(url, data = d1)

  return True


def after_container_update():

  return fix_script_exec()


