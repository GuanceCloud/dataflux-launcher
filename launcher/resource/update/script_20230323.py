# encoding=utf-8

import time
import logging

from launcher.utils.helper import api_helper as apiHelper


def fix_script_exec():
  logging.info('do after_container_update, 2023.03.23 sprint upgrade start')
  ping_url  = "http://inner.forethought-core:5000/api/v1/inner/const/ping"
  url       = "http://inner.forethought-core:5000/api/v1/inner/upgrade/tasks/execute_task_func"
  url2      = "http://inner.forethought-core:5000/api/v1/inner/upgrade/fix_data"

  for i in range(0, 60):
    content, status_code = apiHelper.do_get(ping_url)
    if status_code == 200:
      break

    time.sleep(1)

  if status_code != 200:
    return False
  else:
    # 初始化API接口权限表相关数据和缓存
    d1 = '{"script_name": "sync_permission_tasks", "func_name": "reset_init_biz_api_permissions"}'
    logging.info('do update 2023.03.23, 初始化API接口权限表相关数据和缓存')
    apiHelper.do_post(url, data = d1)

    d2 = '{"script_name": "fix_update_log_multi_index_count"}'
    logging.info('do update 2023.03.23, 初始化多索引配置的允许数量信息')
    apiHelper.do_post(url2, data = d2)

    d3 = '{"script_name": "fix_2023_03_23_refresh_notes_chart_notes_uuid"}'
    logging.info('do update 2023.03.23,  补全笔记图表的 notesUUID 字段值')
    apiHelper.do_post(url2, data = d3)

    d4 = '{"script_name": "fix_2023_03_23_update_ws_owner_role"}'
    logging.info('do update 2023.03.23, 更新拥有着的角色, 空间拥有者在该空间只能有owner一个角色, 清除该空间拥有者拥有的其他角色')
    apiHelper.do_post(url2, data = d4)


  logging.info('do after_container_update, 2023.03.23 sprint upgrade finish')
  return True


def after_container_update():

  return fix_script_exec()


