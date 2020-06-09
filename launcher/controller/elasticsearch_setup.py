# encoding=utf-8


from elasticsearch import Elasticsearch, RequestsHttpConnection
from launcher import settingsMdl


def elasticsearch_ping(params):
  params['port'] = int(params['port'])

  esHosts = [{
              'host': params.get('host'),
              'port': params.get('port')
            }]

  http_auth = (params.get('user'), params.get('password'))

  use_ssl = params.get('ssl', False)

  es = Elasticsearch(esHosts, http_auth = http_auth, use_ssl = use_ssl, connection_class = RequestsHttpConnection)

  pingStatus = False

  try:
    pingStatus =es.ping()
    print(pingStatus)
  except:
    pass

  if pingStatus:
    settingsMdl.elasticsearch = params

    return True

  return False

