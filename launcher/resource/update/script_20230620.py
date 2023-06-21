# encoding=utf-8

import time
import logging
import shortuuid
import os

from launcher import settingsMdl, SERVICECONFIG
from launcher.utils import tools
from launcher.utils.helper import api_helper as apiHelper
from launcher.utils.helper.db_helper import dbHelper


def _fix_script_exec():
  logging.info('do after_container_update, 2023.06.20 sprint upgrade start')
  ping_url  = "http://inner.forethought-core:5000/api/v1/inner/const/ping"
  url_1     = "http://inner.forethought-core:5000/api/v1/inner/upgrade/fix_data"
  url_2     = "http://inner.forethought-core:5000/api/v1/inner/upgrade/tasks/execute_task_func"

  for i in range(0, 60):
    content, status_code = apiHelper.do_get(ping_url)
    if status_code == 200:
      break

    time.sleep(1)

  if status_code != 200:
    return False
  else:
    # 数据权限更新
    d1 = '{"script_name": "fix_update_permission", "scriptKwargs": {}}'

    # 清空工作空间缓存信息
    d2 = '{"script_name": "sync_tasks", "func_name": "sync_clear_cache", "funcKwargs": {"action_list": [["delete", ["workspaceInfo"]]]}}'

    logging.info('do update 2023.06.20, 数据更新（fix_update_permission）')
    apiHelper.do_post(url_1, data = d1)

    logging.info('do update 2023.06.20, 数据更新（sync_tasks）')
    apiHelper.do_post(url_2, data = d2)

  logging.info('do after_container_update, 2023.06.20 sprint upgrade finish')
  return True


def after_container_update():

  return _fix_script_exec()


