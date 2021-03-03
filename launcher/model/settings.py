# encoding=utf-8

import os, re, subprocess
import json, yaml

from launcher.utils import utils
from launcher.utils import encrypt

_SETTING_ENCRYPT_KEY = "wcjGFpkXWyMDZ2Vpkmewizs5yub35Dz"

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
    cipheredSetting = encrypt.cipher_by_aes(settingsYaml, _SETTING_ENCRYPT_KEY)

    self.__save_to_configmap(str(cipheredSetting, encoding="utf-8"))

    # base_path = os.path.dirname(os.path.abspath(__file__))
    # dirPath = base_path + "/../../persistent-data"

    # if not os.path.exists(dirPath):
    #   os.mkdir(dirPath)

    # path = dirPath + "/settings.yaml"
    # with open(path, 'w') as f:
    #   cipheredSetting = encrypt.cipher_by_aes(settingsYaml, _SETTING_ENCRYPT_KEY)
    #   f.write(str(cipheredSetting, encoding="utf-8"))
    #   f.close()

    return True


  def __dict_merge(self, key, value):
    if key not in self._settingJson:
      self._settingJson[key] = {}

    dist = self._settingJson[key]
    self._settingJson[key] = dict(dist, **(value or {}))

    return self._settingJson[key]


  def __save_to_configmap(self, content):
    # print('__save: ', content)
    from launcher.utils.template import jinjia2_render

    tmpDir  = "/tmp"
    tmpPath = tmpDir + "/configmap.yaml"

    item = dict(
              namespace = "launcher",
              key       = "key",
              mapname   = "setting-yaml",
              mapkey    = "setting.yaml",
              content   = content
            )

    configmap = jinjia2_render('template/k8s/configmap.yaml', {"config": [item]})

    if not os.path.exists(tmpDir):
      os.mkdir(tmpDir)

    try:
      with open(os.path.abspath(tmpPath), 'w') as f:
        f.write(configmap)

      cmd = "kubectl apply  -f {}".format(tmpPath)
      p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
    except Exception as e:
      print(e)
      return False

    return True



  def __load_from_configmap(self):
    cmd = 'kubectl get configmap setting-yaml -n launcher -o json'
    result = None

    try:
      p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

      output, err = p.communicate()

      data = json.loads(output).get('data') or {}

      result = yaml.safe_load(data.get('setting.yaml', ''))

    except:
      result = None

    # print('__load: ', result)
    return result


  def __load_from_nas(self):
    result = None
    base_path = os.path.dirname(os.path.abspath(__file__))
    path = base_path + "/../../persistent-data/settings.yaml"

    if not os.path.exists(path):
      return {}

    with open(path) as f:
        result = yaml.safe_load(f)

    return result


  def load(self):
    # 原存储在 nas 中的配置信息，改成存储到 configmap 中
    # 因为 nas 可能配置归档，配置信息也会被归档。
    settingJson = self.__load_from_configmap() or self.__load_from_nas()

    # 兼容旧的未加密情况
    if isinstance(settingJson, str):
      settingContent = encrypt.decipher_by_aes(settingJson, _SETTING_ENCRYPT_KEY)
      settingJson = yaml.safe_load(settingContent)

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

    # if 'mysql' in self.toJson and 'func' in self.toJson['mysql']:
    #   del self.toJson['mysql']['func']

    self.__save()

  @property
  def redis(self):
    return self._settingJson.get('redis') or {}

  @redis.setter
  def redis(self, value):
    self.__dict_merge('redis', value)

    self.__save()


  @property
  def elasticsearch(self):
    return self._settingJson.get('elasticsearch') or {}


  @elasticsearch.setter
  def elasticsearch(self, value):
    self.__dict_merge('elasticsearch', value)

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

  @property
  def registry(self):
    return self._settingJson.get('registry') or {}

  @registry.setter
  def registry(self, value):
    self.__dict_merge('registry', value)
    self.__save()

