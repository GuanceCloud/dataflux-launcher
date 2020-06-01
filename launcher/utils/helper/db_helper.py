# encoding=utf-8

import pymysql
import traceback
import io


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
    if ex_type is None:
      self.commit()
    else:
      self.rollback()

      fo = io.StringIO()
      traceback.print_exception(ex_type, ex_value, ex_trace, file = fo)
      trace_message = fo.getvalue()

      print(trace_message)
      raise Exception(trace_message)
      
    self.close()


  @property
  def connection(self):
    return self._connection


  def rollback(self):
    if self._connection:
      self._connection.rollback()


  def commit(self):
    if self._connection:
      self._connection.commit()


  def close(self):
    if self._connection:
      self._connection.close()


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

