# encoding=utf-8

import time
import logging

from launcher.utils.helper import api_helper as apiHelper


def fix_script_exec():
  logging.info('do after_container_update, 2023.02.23 sprint upgrade start')
  ping_url  = "http://inner.forethought-core:5000/api/v1/inner/const/ping"
  url       = "http://inner.forethought-core:5000/api/v1/inner/upgrade/tasks/execute_task_func"

  for i in range(0, 60):
    content, status_code = apiHelper.do_get(ping_url)
    if status_code == 200:
      break

    time.sleep(1)

  if status_code != 200:
    return False
  else:
    # 智能巡检下架
    d1 = '{"script_name": "sync_permission_tasks", "func_name": "reset_init_permissions"}'

    apiHelper.do_post(url, data = d1)

  logging.info('do after_container_update, 2023.02.23 sprint upgrade finish')
  return True


def after_container_update():

  return fix_script_exec()


