# encoding=utf-8

import shortuuid
import json
import time
import requests

from launcher.utils.helper import api_helper as apiHelper
from launcher.utils.helper.db_helper import dbHelper
from launcher import settingsMdl


def after_container_update():
  url = "http://daily-ft2x-kodo-inner-api.cloudcare.cn/v1/ping"
  # url = "http://kodo-inner.forethought-kodo:9527/v1/ping"
  for i in range(0, 30):
    content, status_code = apiHelper.get(url)
    if status_code == 200:
        break

    time.sleep(1)

  if status_code != 200:
      return False
  else:
      url = "http://daily-ft2x-kodo-inner-api.cloudcare.cn/v1/inner/modify_old_object_ilm"
      # url = "http://kodo-inner.forethought-kodo:9527/v1/inner/modify_old_object_ilm"

      content, status_code = apiHelper.post(url)

      if status_code != 200:
          return False

  return True
