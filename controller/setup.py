# encoding=utf-8

import os
import shortuuid
import pymysql

import markdown

from utils.template import jinjia2_render
from . import SETTINGS


def do_check():
    return {"status": "check OK"}


def readme():
    with open(os.path.abspath("templates/readme.md"), 'r') as f:
        readme = f.read()      
        return markdown.markdown(readme)

    return ""


def config_template():
    coreTemp = jinjia2_render('template/forethought-backend.yaml', SETTINGS)
    messagedeskTemp = jinjia2_render('template/message-desk.yaml', SETTINGS)
    kodoTemp = jinjia2_render('template/kodo.yaml', SETTINGS)

    return {
        "core": coreTemp,
        "messagedesk": messagedeskTemp,
        "kodo": kodoTemp
    }

def init_setting():
    SETTINGS["core"] = {
        "secret": {
            "frontAuth": shortuuid.ShortUUID().random(length=48),
            "manageAuth": shortuuid.ShortUUID().random(length=48)
        }
    }

    return True
