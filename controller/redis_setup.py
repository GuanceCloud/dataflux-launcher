# encoding=utf-8

import redis

from . import SETTINGS


def redis_ping(params):
    params['port'] = int(params['port'])

    strictRedis = redis.StrictRedis(**params)

    pingStatus = False

    try:
        pingStatus =strictRedis.ping()
    except:
        pass

    if pingStatus:
        SETTINGS["redis"] = params

        return True

    return False

