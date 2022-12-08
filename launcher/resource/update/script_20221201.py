# encoding=utf-8

import time
import logging

from launcher.utils.helper import api_helper as apiHelper


def fix_script_exec():
  logging.info('do after_container_update, 2022.12.01 sprint upgrade start')
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
    # pipeline 表数据结构更新
    d1 = '{ "script_name": "fix_update_inner_config_order" }'

    apiHelper.do_post(url, data = d1)

  logging.info('do after_container_update, 2022.12.01 sprint upgrade finish')
  return True


def after_container_update():

  return fix_script_exec()

