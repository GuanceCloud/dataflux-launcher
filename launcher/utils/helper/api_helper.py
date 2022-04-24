# encoding=utf-8

import os, re, subprocess, time
import markdown, shortuuid
import json, yaml
import requests


def __do_call(url, method, params, data, headers):

  if method == 'get':
    resp = requests.get(url, params = params, data = data, headers = headers)
  elif method == 'post':
    resp = requests.post(url, params = params, data = data, headers = headers)
  else:
    raise Exception("Method Not Allowed")

  return resp.json(), resp.status_code


def do_get(url, params = None, data = None,  headers = {"Content-Type": "application/json"}):
  return __do_call(url, "get", params, data, headers)


def do_post(url, params = None, data = None,  headers = {"Content-Type": "application/json"}):
  return __do_call(url, "post", params, data, headers)