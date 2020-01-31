# encoding=utf-8

import os, re, subprocess
import markdown, shortuuid, pymysql
import json, time, yaml

from launcher import SETTINGS, SERVICECONFIG, DOCKERIMAGES


class Setting(object):
  instance = None
  def __new__(cls, *args, **kwargs):
    if cls.instance is None:
      cls.instance = super().__new__(cls, *args, **kwargs)

    return cls.instance


  def __init__(self, *args, **kwargs):
    self._settingJson = self.load()

    return _settingJson


  def __save(self):
    settingsYaml = yaml.dump(self._settingJson, default_flow_style=False)

    base_path = os.path.dirname(os.path.abspath(__file__))
    path = base_path + "/../config/settings.yaml"

    with open(path, 'w') as f:
      f.write(settingsYaml)
      f.close()

    return True


  def load(self):
    settingJson = None
    base_path = os.path.dirname(os.path.abspath(__file__))
    path = base_path + "/../config/settings.yaml"

    if not os.path.exists(path):
      return {}

    with open(path) as f:
        settingJson = yaml.safe_load(f)

    return settingJson or {}


  @property
  def mysql(self):
    return self._settingJson.get('mysql', None)


  @mysql.setter
  def mysql(self, value):
    self._settingJson['mysql'] = value

    self.__save()

  @property
  def redis(self):
    return self._settingJson.get('redis', None)

  @redis.setter
  def redis(self, value):
    self._settingJson['redis'] = value

    self.__save()

  @property
  def influxdb(self):
    return self._settingJson.get('influxdb', None)

  @influxdb.setter
  def influxdb(self, value):
    self._settingJson['influxdb'] = value

    self.__save()

  @property
  def domain(self):
    return self._settingJson.get('domain', None)

  @domain.setter
  def domain(self, value):
    self._settingJson['domain'] = value

    self.__save()

