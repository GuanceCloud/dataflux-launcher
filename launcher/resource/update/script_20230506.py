# encoding=utf-8

import time
import logging

from launcher.utils.helper import api_helper as apiHelper


def fix_script_exec():
  logging.info('do after_container_update, 2023.05.06 sprint upgrade start')
  logging.info('influde 04.28、05.06 hotfix version')
  ping_url  = "http://inner.forethought-core:5000/api/v1/inner/const/ping"
  url      = "http://inner.forethought-core:5000/api/v1/inner/upgrade/fix_data"

  for i in range(0, 60):
    content, status_code = apiHelper.do_get(ping_url)
    if status_code == 200:
      break

    time.sleep(1)

  if status_code != 200:
    return False
  else:
    # 数据权限更新
    d1 = '{"script_name": "fix_update_permission"}'
    d2 = '{"script_name": "fix_2023_04_20_update_workspace_incident_menu"}'

    logging.info('do update 2023.05.06, 数据更新')
    apiHelper.do_post(url, data = d1)
    
    logging.info('do update 2023.05.06, 数据更新')
    apiHelper.do_post(url, data = d2)

  logging.info('do after_container_update, 2023.05.06 sprint upgrade finish')
  return True


def after_container_update():

  return fix_script_exec()


