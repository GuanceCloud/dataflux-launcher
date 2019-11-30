# encoding=utf-8

SETTINGS = {
    "mysql": {},
    "redis": {},
    "influxdb": [{}],
    "messageDesk": {},
    "core": {}
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