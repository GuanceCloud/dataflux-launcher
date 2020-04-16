# encoding=utf-8

import pymysql

class dbHelper(object):
  def __init__(self, connect_info):
    try:
      if connect_info:
        _conn = connect_info.copy()
        _conn['cursorclass'] = pymysql.cursors.DictCursor
        
      self._connection = pymysql.connect(**_conn)
    except:
      self._connection = None
      pass


  def __enter__(self):
    return self


  def __exit__(self, ex_type, ex_value, ex_trace):
    try:
      if self._connection:
        self._connection.commit()
        self._connection.close()
    except:
      print('db exit error')
      pass


  @property
  def connection(self):
    return self._connection


  def commit(self):
    if self._connection:
      self._connection.commit()


  def execute(self, ddl, dbName = None, params = None):
    if dbName is not None:
      self._connection.select_db(dbName)

    result = []
    with self._connection.cursor() as cursor:

      for statement in ddl.split(';\n'):
        statement = statement.strip()

        if len(statement) > 0:
          if not params:
            cursor.execute(statement + ';')
          else:
            cursor.execute(statement + ';', params)

          result.append(cursor.fetchall())

      # self._connection.commit()
      return result

