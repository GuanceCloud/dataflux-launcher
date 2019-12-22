# encoding=utf-8

import pymysql

class dbHelper(object):
  def __init__(self, connect_info):
    try:
      self._connection = pymysql.connect(**connect_info)
    except:
      self._connection = None
      pass


  def __enter__(self):
    return self


  def __exit__(self, ex_type, ex_value, ex_trace):
    try:
      if self._connection:
        self._connection.close()
    except:
      print('db exit error')
      pass


  @property
  def connection(self):
    return self._connection


  def execute(self, ddl, dbName = None, params = None):
    if dbName is not None:
      self._connection.select_db(dbName)

    result = []
    with self._connection.cursor() as cursor:

      for statement in ddl.split(';'):
        statement = statement.strip()

        if len(statement) > 0:
          if not params:
            cursor.execute(statement + ';')
          else:
            cursor.execute(statement + ';', params)

          result.append(cursor.fetchall())

      self._connection.commit()

      return result

