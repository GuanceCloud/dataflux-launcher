# encoding=utf-8

import subprocess, requests
import json, functools

from flask import redirect, url_for


def upgrade_install(func):
  @functools.wraps(func)
  def wrapper(*args, **kwargs):
    cmd = "kubectl get deploy -n forethought-core -o json"
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

    output, err = p.communicate()
    deploys = json.loads(output)

    # 已经有了 deploy，不是全新安装，强制跳转到升级部署页面
    if len(deploys['items']) > 0:
      return redirect(url_for("check"))

    return func(*args, **kwargs)
  return wrapper

