# encoding=utf-8

import os
import shortuuid
import pymysql

from utils.template import jinjia2_render
from . import SETTINGS


def do_check():
    return {"status": "check OK"}

def config_template():
    temp = jinjia2_render('template/forethought-backend.yaml', SETTINGS)

    return {
        "core": temp
    }

def init_setting():
    SETTINGS["core"] = {
        "secret": {
            "frontAuth": shortuuid.ShortUUID().random(length=48),
            "manageAuth": shortuuid.ShortUUID().random(length=48)
        }
    }

    return True
