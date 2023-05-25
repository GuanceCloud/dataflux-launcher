# encoding=utf-8

import time
import logging

from launcher.utils.helper import api_helper as apiHelper


def fix_script_exec():
  logging.info('do after_container_update, 2023.05.22 sprint upgrade start')
  logging.info('influde 04.28、05.22 hotfix version')
  ping_url  = "http://inner.forethought-core:5000/api/v1/inner/const/ping"
  url_1      = "http://inner.forethought-core:5000/api/v1/inner/upgrade/fix_data"
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
    d1 = '{"script_name": "fix_2023_05_22_field_manage_repair"}'
    d2 = '{"script_name": "fix_2023_04_27_logging_query_rules"}'

    d3 = '{"script_name": "sync_permission_tasks", "func_name": "reset_init_biz_api_permissions"}'
    d4 = '{"script_name": "timed_sync_field_cfg_template", "func_name": "timed_sync_pull", "funcKwargs": {"need_sync_field_cfg": true}}'

    logging.info('do update 2023.05.22, 数据更新（fix_2023_05_22_field_manage_repair）')
    apiHelper.do_post(url_1, data = d1)
    
    logging.info('do update 2023.05.22, 数据更新（fix_2023_04_27_logging_query_rules）')
    apiHelper.do_post(url_1, data = d2)
    
    logging.info('do update 2023.05.22, 数据更新（sync_permission_tasks）')
    apiHelper.do_post(url_2, data = d3)
    
    logging.info('do update 2023.05.22, 数据更新（timed_sync_field_cfg_template）')
    apiHelper.do_post(url_2, data = d4)

  logging.info('do after_container_update, 2023.05.22 sprint upgrade finish')
  return True


def after_container_update():

  return fix_script_exec()


