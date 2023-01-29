# encoding=utf-8

import time
import logging

from launcher.utils.helper import api_helper as apiHelper


def fix_script_exec():
  logging.info('do after_container_update, 2023.01.12 sprint upgrade start')
  ping_url      = "http://inner.forethought-core:5000/api/v1/inner/const/ping"
  url_fix_data  = "http://inner.forethought-core:5000/api/v1/inner/upgrade/fix_data"
  url_template  = "http://inner.forethought-core:5000/api/v1/inner/upgrade/tasks/execute_task_func"

  for i in range(0, 60):
    content, status_code = apiHelper.do_get(ping_url)
    if status_code == 200:
      break

    time.sleep(1)

  if status_code != 200:
    return False
  else:
    # 智能巡检下架
    d1 = '{ "script_name": "fix_update_rule_nodata_action" }'

    # 更新 biz_pipeline 的 extend 中 appid 字符串为列表
    d2 = '{ "script_name": "fix_2022_12_29_clear_obs_checker" }'

    # 更新字段管理文件
    d3 = '{"script_name": "timed_sync_field_cfg_template", "func_name": "timed_sync_pull", "funcKwargs": {"need_sync_field_cfg": true}}'

    apiHelper.do_post(url_fix_data, data = d1)
    apiHelper.do_post(url_fix_data, data = d2)
    apiHelper.do_post(url_template, data = d3)

  logging.info('do after_container_update, 2023.01.12 sprint upgrade finish')
  return True


def after_container_update():

  return fix_script_exec()

