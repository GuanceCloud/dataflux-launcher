# encoding=utf-8

from flask import Flask, request, g

from launcher.utils.template import render
from launcher.controller import setup
from launcher.controller import env_check

from . import SETTINGS, STEPS


def register_route(app):

  @app.before_request
  def set_step():
    path = request.path
    isPrev = True

    for step in STEPS:
      if step['key'] == path:
        step['status'] = 'current'
        isPrev = False

        continue

      if isPrev:
        step['status'] = 'prev'
      elif 'status' in step:
        del step['status']


  @app.route("/")
  def index():
    readme = setup.readme()

    return render("index.html", {"title": "安装说明", "pageData": readme, "steps": STEPS})


  @app.route("/check")
  def check():
    result = env_check.do_check()
    setup.init_setting()

    return render("check.html", {"pageData": result, "steps": STEPS})


  @app.route("/database")
  def database():
    return render("database.html", {"title": "MySQL 配置", "pageData": SETTINGS['mysql'], "steps": STEPS})


  @app.route("/other")
  def other():
    return render("other.html", {"title": "其他配置", "pageData": SETTINGS['other'], "steps": STEPS})


  @app.route("/redis")
  def redis():
    return render("redis.html", {"title": "Redis 配置", "pageData": SETTINGS['redis'], "steps": STEPS})


  @app.route("/influxdb")
  def influxdb():
    return render("influxdb.html", {"title": "InfluxDB 配置", "pageData": SETTINGS['influxdb'], "steps": STEPS})


  @app.route("/setup/info")
  def setup_info():
    return render("setup-info.html", {"title": "安装信息", "pageData": SETTINGS, "steps": STEPS})


  @app.route("/config/review")
  def config_review():
    config = setup.config_template()

    return render("config-review.html", {"title": "配置预览", "pageData": config, "steps": STEPS})


  @app.route("/service/config")
  def serviceConfig():
    d = setup.service_image_config()

    return render("service-config.html", {"title": "应用服务配置", "pageData": d, "config": SETTINGS['serviceConfig'], "steps": STEPS})


  @app.route("/service/status")
  def service_status():
    return render("service-status.html", {"title": "服务状态", "pageData": setup.service_status(), "steps": STEPS})


  @app.route("/complete")
  def complete():
    return render("complete.html", {"title": "安装完毕"})


def register_blueprint(app):
  from launcher.route import setup_bp

  app.register_blueprint(setup_bp, url_prefix="/api/v1")


def create_app():
  app = Flask(__name__, static_url_path='')

  register_route(app)
  register_blueprint(app)

  return app
