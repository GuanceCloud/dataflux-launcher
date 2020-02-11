# encoding=utf-8

import os, re
import json, yaml

from launcher.utils import utils


class Settings(object):
  instance = None
  def __new__(cls, *args, **kwargs):
    if cls.instance is None:
      cls.instance = super().__new__(cls, *args, **kwargs)

    return cls.instance


  def __init__(self, *args, **kwargs):
    self._settingJson = self.load()


  def __save(self):
    settingsYaml = yaml.dump(self._settingJson, default_flow_style=False)

    base_path = os.path.dirname(os.path.abspath(__file__))
    dirPath = base_path + "/../../persistent-data"

    if not os.path.exists(dirPath):
      os.mkdir(dirPath)

    path = dirPath + "/settings.yaml"
    with open(path, 'w') as f:
      f.write(settingsYaml)
      f.close()

    return True


  def __dict_merge(self, key, value):
    if key not in self._settingJson:
      self._settingJson[key] = {}

    dist = self._settingJson[key]
    self._settingJson[key] = dict(dist, **(value or {}))

    return self._settingJson[key]


  def load(self):
    settingJson = None
    base_path = os.path.dirname(os.path.abspath(__file__))
    path = base_path + "/../../persistent-data/settings.yaml"

    if not os.path.exists(path):
      return {}

    with open(path) as f:
        settingJson = yaml.safe_load(f)

    return settingJson or {}

  @property  
  def toJson(self):
    return self._settingJson or {}


  @property
  def mysql(self):
    return self._settingJson.get('mysql') or {}


  @mysql.setter
  def mysql(self, value):
    self.__dict_merge('mysql', value)

    self.__save()

  @property
  def redis(self):
    return self._settingJson.get('redis') or {}

  @redis.setter
  def redis(self, value):
    self.__dict_merge('redis', value)

    self.__save()

  @property
  def influxdb(self):
    return self._settingJson.get('influxdb') or [{
          "host": "",
          "port": "",
          "username": "",
          "password": "",
          "ssl": False,
          "dbName": ""
        }]

  @influxdb.setter
  def influxdb(self, value):
    self._settingJson['influxdb'] = value

    self.__save()

  @property
  def domain(self):
    return self._settingJson.get('domain') or {}

  @domain.setter
  def domain(self, value):
    self.__dict_merge('domain', value)

    self.__save()

  @property
  def other(self):
    return self._settingJson.get('other') or {}

  @other.setter
  def other(self, value):
    self.__dict_merge('other', value)
    self.__save()

