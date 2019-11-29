# encoding=utf-8

import os
import shortuuid
import pymysql

from . import SETTINGS


def do_check():
    return {"status": "check OK"}

def init_setting(params):
    SETTINGS["core"] = {
        "secret": {
            "frontAuth": shortuuid.ShortUUID().random(length=48),
            "manageAuth": shortuuid.ShortUUID().random(length=48)
        }
    }

    return True
