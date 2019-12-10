# encoding=utf-8

import os, re

from datetime import datetime

from flask import render_template
from jinja2 import Environment, PackageLoader, FileSystemLoader


def render(fileName, params = None):
  if not params:
    params = {}

  params["__common__"] = {}
  params["__common__"]["year"] = datetime.now().year

  return render_template(fileName, **params)


def jinjia2_render(template_name, params):
  env = Environment(loader=FileSystemLoader(searchpath = os.path.abspath("./resource/v1")))

  env.filters['indent'] = lambda v, size: (' ' * size) + re.sub('(\n)|(\r\n)', '\n' + (' ' * size), (v or '')) 

  template = env.get_template(template_name)

  return template.render(**params)

