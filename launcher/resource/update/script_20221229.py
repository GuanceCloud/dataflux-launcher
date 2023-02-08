# encoding=utf-8

import time
import logging

from launcher.utils.helper import api_helper as apiHelper


def fix_script_exec():
  logging.info('do after_container_update, 2022.12.29 sprint upgrade start')
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
    # 智能巡检下架
    d1 = '{ "script_name": "fix_2022_12_29_clear_obs_checker" }'

    # 更新 biz_pipeline 的 extend 中 appid 字符串为列表
    d2 = '{ "script_name": "fix_update_pipeline_rum_extend" }'

    apiHelper.do_post(url, data = d1)
    apiHelper.do_post(url, data = d2)

  logging.info('do after_container_update, 2022.12.29 sprint upgrade finish')
  return True


def after_container_update():

  return fix_script_exec()

