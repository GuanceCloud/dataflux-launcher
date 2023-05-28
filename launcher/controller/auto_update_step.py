# encoding=utf-8

import markdown, shortuuid, pymysql
import json, time, yaml
import importlib

from launcher.model import version as versionMdl

from launcher import settingsMdl, SERVICECONFIG, DOCKERIMAGES, CACHEDATA

from launcher.resource import *


class AutoUpdateStep(object):
  instance = None

  def __new__(cls, *args, **kwargs):
    if cls.instance is None:
      cls.instance = super().__new__(cls, *args, **kwargs)

    return cls.instance

  def __init__(self, *args, **kwargs):
    self.__projectCurrentSeqs = None
    self.__launcherSeqs = None


  def get_upgrade_seqs(self):
    if self.__projectCurrentSeqs is not None:
      return self.__projectCurrentSeqs

    mysqlSetting = settingsMdl.mysql
    baseInfo     = mysqlSetting.get('base') or {}
    coreInfo     = mysqlSetting.get('core') or {}
    mysql        = {
                    'host': baseInfo.get('host'),
                    'port': baseInfo.get('port'),
                    'user': coreInfo.get('user'),
                    'password': coreInfo.get('password')
                  }
    dbName       = coreInfo.get('database')
    currentSeqs  = versionMdl.get_current_update_seq(mysql, dbName)

    for upProject in SERVICECONFIG['updates']:
      projectName = upProject['project']
      if projectName in currentSeqs:
        continue

      currentSeqs[projectName] = {
        "config": -1,
        "database": -1
      }

    self.__projectCurrentSeqs = currentSeqs

    return self.__projectCurrentSeqs


  def get_launcher_seqs(self):
    if self.__launcherSeqs is not None:
      return __launcherSeqs

    currentSeqs = self.get_upgrade_seqs()
    launcherSeq = currentSeqs.get('launcher', {'config': -1})
    updateVersions  = versionMdl.list_project_versions('launcher', launcherSeq['config'])

    self.__launcherSeqs = updateVersions

    return self.__launcherSeqs

  def __load_package(self, package_name):
    pk = importlib.import_module(f"launcher.resource.update.{package_name}")

    return pk


  # 升级准备完成之后开始执行的升级步骤
  def do_after_preparation(self):
    pass


  # 在数据库升级完毕、容器升级之前需要自动执行的升级操作。
  def do_before_container_update(self):
    launcherSeqs = self.get_launcher_seqs()

    for ls in launcherSeqs:
      package_name = ls.get('func_exec', None)
      if package_name is None:
        continue

      pk = self.__load_package(package_name)

      if 'before_container_update' in dir(pk):
        pk.before_container_update()


  # 在所有容器都升级完毕后自动执行
  def do_after_container_update(self):
    launcherSeqs = self.get_launcher_seqs()

    for ls in launcherSeqs:
      package_name = ls.get('func_exec', None)
      if package_name is None:
        continue

      pk = self.__load_package(package_name)

      if 'after_container_update' in dir(pk):
         pk.after_container_update()

