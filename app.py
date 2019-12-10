# encoding=utf-8

from flask import Flask, g

from utils.template import render
from controller import setup

from controller import SETTINGS


def register_route(app):
  @app.route("/")
  def index():
    readme = setup.readme()

    return render("index.html", {"title": "安装说明", "data": readme})


  @app.route("/check")
  def check():
    # d = do_check()
    setup.init_setting()

    return render("check.html", None)


  @app.route("/database")
  def database():
    return render("database.html", {"title": "MySQL 配置", "data": SETTINGS['mysql']})


  @app.route("/other")
  def other():
    return render("other.html", {"title": "其他配置", "data": SETTINGS['other']})


  @app.route("/redis")
  def redis():
    return render("redis.html", {"title": "Redis 配置", "data": SETTINGS['redis']})


  @app.route("/influxdb")
  def influxdb():
    return render("influxdb.html", {"title": "InfluxDB 配置", "data": SETTINGS['influxdb']})


  @app.route("/setup/info")
  def setup_info():
    return render("setup-info.html", {"title": "安装信息", "data": SETTINGS})


  @app.route("/config/review")
  def config_review():
    config = setup.config_template()

    return render("config-review.html", {"title": "配置预览", "data": config})


  @app.route("/service/config")
  def serviceConfig():
    d = setup.service_image_config()

    return render("service-config.html", {"title": "应用服务配置", "pageData": d, "config": SETTINGS['serviceConfig']})


  @app.route("/complete")
  def complete():
    return render("complete.html", {"title": "安装完毕"})


def register_blueprint(app):
  from route import setup_bp

  app.register_blueprint(setup_bp, url_prefix="/api/v1")


def create_app():
  app = Flask(__name__, static_url_path='')

  register_route(app)
  register_blueprint(app)

  return app
