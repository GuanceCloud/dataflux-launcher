# encoding=utf-8

import time
import logging

from launcher.utils.helper import api_helper as apiHelper


def fix_script_exec():
  logging.info('do after_container_update, 2023.04.20 sprint upgrade start')
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
    d1 = '{"script_name": "fix_2023_04_20_update_workspace_grant"}'
    d2 = '{"script_name": "fix_2023_04_20_update_workspace_incident_menu"}'
    d3 = '{"script_name": "fix_update_permission", "scriptKwargs": {"custom_permissions":["anomaly.issueManage","anomaly.issueRead","anomaly.issueReplyManage","anomaly.issueReplyRead"]}}'

    logging.info('do update 2023.04.20, 数据更新，fix_2023_04_20_update_workspace_grant')
    apiHelper.do_post(url, data = d1)
    logging.info('do update 2023.04.20, 数据更新，fix_2023_04_20_update_workspace_incident_menu')
    apiHelper.do_post(url, data = d2)
    logging.info('do update 2023.04.20, 数据更新，fix_update_permission')
    apiHelper.do_post(url, data = d3)

  logging.info('do after_container_update, 2023.04.20 sprint upgrade finish')
  return True


def after_container_update():

  return fix_script_exec()


