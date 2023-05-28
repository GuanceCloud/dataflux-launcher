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


def _init_dialtesting_setting():
  settingsMdl.other = { "dialServiceAK": {
      "ak_id":"ak_" + shortuuid.ShortUUID().random(length = 16),
      "ak": shortuuid.ShortUUID().random(length = 16),
      "sk": shortuuid.ShortUUID().random(length = 32)
    }
  }

  # 如果没有配置拨测服务子域名，则默认使用 “dialtesting” 作为子域名
  subDomain = settingsMdl.domain.get("subDomain", {})
  if not subDomain.get("subDomain"):
    subDomain['dialtesting'] = "dialtesting"
    settingsMdl.domain = {"subDomain": subDomain}

  # 默认保持原来的 SaaS 拨测服务
  if not settingsMdl.other.get('dialService'):
    settingsMdl.other = { 'dialService': 'saas' }

  return settingsMdl.other


def _database_create_db():
  mysqlSetting = settingsMdl.mysql
  mysqlInfo = mysqlSetting.get('base')
  dbInfo = mysqlSetting.get('dialtesting')

  SQL = '''
        CREATE DATABASE IF NOT EXISTS {database} DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
        CREATE USER '{user}'@'%' IDENTIFIED BY '{password}';
        GRANT ALL PRIVILEGES ON {database}.* TO '{user}'@'%';
        '''.format(**dbInfo)

  logging.info("升级步骤： 创建 dialtesting 数据库，并初始化数据库访问账号开始。")
  # print(mysqlInfo)
  with dbHelper(mysqlInfo) as db:
    db.execute(SQL)

  logging.info("升级步骤： 创建 dialtesting 数据库，并初始化数据库访问账号完成。")
  return True


def _database_ddl():
  logging.info("初始化 df_dialtesting 数据库 开始")
  mysqlSetting = settingsMdl.mysql
  mysqlInfo = mysqlSetting.get('base')

  password = tools.gen_password(16)

  dbInfo = {
    "database": SERVICECONFIG['databases']['dialtesting'],
    "user": SERVICECONFIG['databases']['dialtesting'],
    "password": password
  }

  settingsMdl.mysql = {'dialtesting': dbInfo}

  _database_create_db()

  with dbHelper(mysqlInfo) as db:
    with open(os.path.abspath("launcher/resource/v1/ddl/dialtesting.sql"), 'r') as f:
      ddl = f.read()
      db.execute(ddl, dbName = dbInfo['database'])

  logging.info("初始化 df_dialtesting 数据库 完成")
  return True


def _database_init_data():
  sql = '''
      INSERT INTO `aksk` (`uuid`, `accessKey`, `secretKey`, `owner`, `parent_ak`, `external_id`, `status`, `version`, `createAt`, `updateAt`)
      VALUES
        (%s, %s, %s, 'system', '-1', 'wksp_system', 'OK', 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());
    '''

  mysqlSetting = settingsMdl.mysql
  mysqlInfo = mysqlSetting.get('base')
  dbInfo = mysqlSetting.get('dialtesting')
  dialAKSK = settingsMdl.other.get('dialServiceAK', {})

  dialAK_id = dialAKSK.get('ak_id')
  dialAK = dialAKSK.get('ak')
  dialSK = dialAKSK.get('sk')

  with dbHelper(mysqlInfo) as db:
    params = (dialAK_id, dialAK, dialSK)

    db.execute(sql, dbName = dbInfo['database'], params = params)

  return True


def do_after_preparation():
  _init_dialtesting_setting()

  _database_ddl()
  _database_init_data()

  return True


def after_container_update():

  return _fix_script_exec()


