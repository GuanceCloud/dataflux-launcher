# encoding=utf-8

import redis

from launcher import settingsMdl


def redis_ping(params):
  params['port'] = int(params['port'])
  params["ssl"] = (params.get('ssl', "false") == 'true')

  strictRedis = redis.StrictRedis(**params)

  pingStatus = False

  try:
    pingStatus = strictRedis.ping()
  except:
    pass

  if pingStatus:
    settingsMdl.redis = params

    return True

  return False

