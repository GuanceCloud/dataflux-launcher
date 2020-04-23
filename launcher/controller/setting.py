# encoding=utf-8

import redis
import json, yaml

from launcher import settingsMdl


def setting_get(key):
  settingJson = getattr(settingsMdl, key)

  settingsYaml = yaml.dump(settingJson, default_flow_style=False)

  return settingsYaml
