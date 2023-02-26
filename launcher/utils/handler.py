# encoding=utf-8

import copy
import logging
import traceback

from flask import jsonify, Response


class JSONMarshal(object):
  """Make marshal data for flask response object.
  usage:
    marshal = JSONMarshal(content=processing_completed_data, status_code=200, foo='bar')
    return marshal.make_response() -> flask.Response
  """

  default_json_response = {
    # 'code': 200,
    'content': {},
    'errorCode': '',
    'message': ''
    # 'success': True
  }

  def __init__(self, content=None, *, status_code=200, **options):
    self._body = copy.deepcopy(self.default_json_response)
    self._status_code = status_code
    # self._body['code'] = status_code
    self._body['content'] = content
    self._body.update(options)

  @property
  def body(self) -> dict:
    return self._body

  def update_params(self, **kwargs) -> None:
    self._body.update(**kwargs)

  def make_response(self) -> Response:
    resp = jsonify(self.body)
    resp.status_code = self._status_code
    return resp


def response_jsonify(*args, **kwargs):
  marshal = JSONMarshal(*args, **kwargs)
  return marshal.make_response()


def handle_exception(e: Exception):
  logging.exception(e)
  return response_jsonify(success=False, status_code = 500, message=str(e))
