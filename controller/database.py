# encoding=utf-8

import pymysql

class database(object):
    def __init__(self, connect_info):
        try:
            self.connection = pymysql.connect(**connect_info)
        except:
            pass

    def __enter__(self):
        return self

    def __exit__(self, ex_type, ex_value, ex_trace):
        if self.connection:
            self.connection.close()

    def create_db(self, dbName, dbUser, dbUserPassword):
        dbSQL = "CREATE DATABASE IF NOT EXISTS {dbName} DEFAULT CHARSET utf8 COLLATE utf8_general_ci;".format(dbName = dbName)
        userSQL = "GRANT ALL PRIVILEGES ON {dbName}.* TO '{dbUser}'@'%' IDENTIFIED BY '{dbUserPassword}';".format(dbName = dbName, dbUser = dbUser, dbUserPassword = dbUserPassword)


        with self.connection.cursor() as cursor:
            cursor.execute(dbSQL)
            cursor.execute(userSQL)

            self.connection.commit()

    def import_ddl(self, dbName, ddl):
        self.connection.select_db(dbName)

        with self.connection.cursor() as cursor:

            for statement in ddl.split(';'):
                if len(statement) > 0:
                     cursor.execute(statement + ';')

            self.connection.commit()

            return True

