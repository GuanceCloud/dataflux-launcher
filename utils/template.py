# encoding=utf-8

from datetime import datetime

from flask import render_template

def render(fileName, params = None):
    if not params:
        params = {}

    params["__common__"] = {}
    params["__common__"]["year"] = datetime.now().year

    return render_template(fileName, **params)