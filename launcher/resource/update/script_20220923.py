# encoding=utf-8

import shortuuid
import json
import time
import requests

from launcher.utils.helper import api_helper as apiHelper
from launcher.utils.helper.db_helper import dbHelper
from launcher import settingsMdl


def black_list_upgrade():
  print('black list upgrade')
  ping_url  = "http://inner.forethought-core:5000/api/v1/inner/const/ping"
  url       = "http://inner.forethought-core:5000/api/v1/inner/upgrade/fix_data"

  # curl 'http://inner.forethought-core:5000/api/v1/inner/upgrade/fix_data' -H 'Content-Type: application/json' --data-raw $'{"script_name": "fix_2022_09_15_blacklist_notin"}'

  for i in range(0, 30):
    content, status_code = apiHelper.do_get(ping_url)
    if status_code == 200:
      break

    time.sleep(1)

  if status_code != 200:
    return False
  else:
    d1 = '{ "script_name": "fix_2022_09_15_blacklist_notin" }'

    apiHelper.do_post(url, data = d1)


  return True


def after_container_update():

  black_list_upgrade()

  return True
