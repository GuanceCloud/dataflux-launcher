# encoding=utf-8

# SETTINGS = {
#   "mysql": {},
#   "redis": {},
#   "influxdb": [{}],
#   "messageDesk": {},
#   "core": {
#     "dbInfo": {},
#     "secret": {}
#   },
#   "other": {
#     "manager": {
#     "username": "",
#     "email": ""
#     },
#     "domain": ""
#   },
#   "serviceConfig": {}
# }


# test data
SETTINGS = {
  "mysql": {
    "host": "172.16.0.43",
    "port": 32306,
    "user": "root",
    "password": "rootPassw0rd"
  },
  "core": {
    "dbInfo": {
      "dbName": "Forethought",
      "dbUser": "Forethought",
      "dbUserPassword": "123321"
    },
    "secret": {}
  },
  "messageDesk": {
    "dbInfo": {
      "dbName": "",
      "dbUser": "",
      "dbUserPassword": ""
    }
  },
  "redis": {
    "host": "172.16.0.43",
    "port": 30397,
    "password": "viFRKZiZkoPmXnyF"
  },
  "influxdb": [
    {
      "host": "172.16.0.43",
      "port": 32086,
      "username": "admin",
      "password": "admin@influxdb",
      "ssl": False,
      "dbName": "test_db",
      "kapacitorHost": "http://127.0.0.1:1234"
    }
  ],
  "other": {
    "manager": {
      "username": "admin",
      "email": "lhm@jiagouyun.com"
    },
    "domain": ""
  },
  "serviceConfig":{}
}


''' 结构
  ============================

  mysql:
    host:
    port:
    user:
    password:

  core:
    dbInfo:
      dbName:
      dbUser:
      dbUserPassword:
    manager:
      username:
      email:

  messageDesk:
    dbInfo:
      dbName:
      dbUser:
      dbUserPassword:

  redis:
    host:
    port:
    password:

  influxdb:
  -   host:
    port:
    username:
    password:
    ssl:
    dbName:
    kapacitorHost:
  other:
    manager:
    domain
  serviceConfig:
'''
