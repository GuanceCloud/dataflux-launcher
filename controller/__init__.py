# encoding=utf-8

# SETTINGS = {
#     "mysql": {},
#     "redis": {},
#     "influxdb": [{}],
#     "messageDesk": {},
#     "core": {
#         "dbInfo": {},
#         "secret": {}
#     }
# }


# test data
SETTINGS = {
  "mysql": {
    "host": "127.0.0.1",
    "port": "3306",
    "user": "root",
    "password": "qwe123123"
  },
  "core": {
    "dbInfo": {
      "dbName": "Forethought",
      "dbUser": "Forethought",
      "dbUserPassword": "123321"
    },
    "manager": {
      "username": "admin",
      "email": "lhm@jiagouyun.com"
    }
  },
  "messageDesk": {
    "dbInfo": {
      "dbName": "",
      "dbUser": "",
      "dbUserPassword": ""
    }
  },
  "redis": {
    "host": "172.16.0.20",
    "port": "10391",
    "password": "Fd6cQ4cvd8"
  },
  "influxdb": [
    {
      "host": "127.0.0.1",
      "port": "8086",
      "username": "admin",
      "password": "123123",
      "ssl": False,
      "dbName": "test_db",
      "kapacitorHost": "http://127.0.0.1:1234"
    }
  ]
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
'''