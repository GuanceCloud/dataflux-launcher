# encoding=utf-8

import os, re, subprocess
import markdown, shortuuid
import json, time

from flask import request

from launcher.utils.template import jinjia2_render
from launcher import SETTINGS, SERVICECONFIG, DOCKERIMAGES


def __get_update_content(url, seq):
  pass


def get_configmap_items():
  maps = []
  for project in SERVICECONFIG['updates']:
    for configItem in project['config']:
      mapItem = {
                "api": project['api'],
                "namespace": project['namespace'],
                "project": project['project'],

                "key": configItem['key'],
                "mapName": configItem['mapName'],
                "mapKey": configItem['mapKey']
            }

      maps.append(mapItem)

  return maps


