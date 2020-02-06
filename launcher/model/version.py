# encoding=utf-8

import os, re, subprocess, time
import markdown, shortuuid
import json, yaml
import requests

from launcher import SERVICECONFIG, DOCKERIMAGES


def get_current_versions():
  pass


def list_project_versions(url, versionSeq, dataKey):
  if not url:
    return []
    
  url = "{}?seq={}".format(url, versionSeq)

  rsp = requests.get(url)
  content = rsp.json()
  data = None

  if content and dataKey in content:
    data = content[dataKey]

  return data

  # return  [
  #           {
  #             "seq": 1,
  #             "database": "# 数据库更新脚本",
  #             "config": {
  #               "kodo": "log:\n  level: info",
  #               "kodoInner": "log:\n  level: info"
  #             }
  #           },
  #           {
  #             "seq": 2,
  #             "config": {
  #               "kodo": "log:\n  level: warning\n\nglobal:\n  # 原 enable_inner 修改为 enable_inner_api\n  enable_inner_api: true"
  #             }
  #           }
  #         ]
