# encoding=utf-8

import os, re, subprocess
import markdown, shortuuid, pymysql
import json, time

from launcher.model import k8s
from launcher.utils.template import jinjia2_render

from launcher import SETTINGS, SERVICECONFIG, DOCKERIMAGES


def deploy_check():
  deployStatus = k8s.deploy_status()

  apps = DOCKERIMAGES.get('apps', {})
  imageDir = apps.get('image_dir', '')
  defaultImage  = apps.get('images', {})

  for ns in deployStatus:
    for deploy in ns['services']:
      newImagePath = '{}/{}/{}'.format(apps.get('registry', ''), imageDir, defaultImage.get(deploy['imageKey'], ''))

      deploy['newImagePath'] = re.sub('/+', '/', newImagePath)

  return deployStatus


def deploy_update():
  deployStatus = deploy_check()

  for ns in deployStatus:
    for deploy in ns['services']:
      if deploy['fullImagePath'] == deploy['newImagePath']:
        continue

      cmd = 'kubectl patch deploy {0} -p \'{{"spec": {{"template": {{"spec": {{"containers": [{{"image": "{1}", "name": "{0}"}}] }} }} }} }}\' -n {2}'
      cmd = cmd.format(deploy['key'], deploy['newImagePath'], ns['namespace'])

      p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  return True
