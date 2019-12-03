# encoding=utf-8

import os
import re
import shortuuid
import pymysql

import markdown

from utils.template import jinjia2_render
from . import SETTINGS


def do_check():
    return {"status": "check OK"}


def readme():
    with open(os.path.abspath("templates/README.md"), 'r') as f:
        readme = f.read()
        return markdown.markdown(readme)

    return ""


def config_template():
    coreTemp = jinjia2_render('template/config/forethought-backend.yaml', SETTINGS)
    kodoTemp = jinjia2_render('template/config/kodo.yaml', SETTINGS)
    messageDeskTempApi = jinjia2_render('template/config/message-desk-api.yaml', SETTINGS)
    messageDeskTempWorker = jinjia2_render('template/config/message-desk-worker.yaml', SETTINGS)

    return {
        "core": coreTemp,
        "kodo": kodoTemp,
        "messageDeskApi": messageDeskTempApi,
        "messageDeskWorker": messageDeskTempWorker
    }


def configmap_create(maps):
    configmap = jinjia2_render('template/k8s-service/configmap.yaml', {"config": maps})

    with open(os.path.abspath("/tmp/configmap.yaml"), 'w') as f:
        f.write(configmap)

    return True


def init_setting():
    SETTINGS["core"] = {
        "secret": {
            "frontAuth": shortuuid.ShortUUID().random(length=48),
            "manageAuth": shortuuid.ShortUUID().random(length=48)
        }
    }

    return True
