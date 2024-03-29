# encoding=utf-8

import time

from launcher.utils.helper import api_helper as apiHelper


def fix_script_exec():
  print('black list upgrade')
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
    # biz_mute 更新
    d1 = '{ "script_name": "fix_mute_tags_range_2022_09_29"}'

    # black_list fix
    d2 = '{ "script_name": "fix_2022_09_15_blacklist_notin" }'

    apiHelper.do_post(url, data = d1)
    apiHelper.do_post(url, data = d2)

  return True


def after_container_update():

  return fix_script_exec()
