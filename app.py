# encoding=utf-8

from flask import Flask, g

from utils.template import render
from controller.setup import do_check

from controller import SETTINGS


def register_route(app):
    @app.route("/")
    def index():
        return render("index.html", {"title": "使用协议"})


    @app.route("/check")
    def check():
        d = do_check()

        return render("check.html", d)


    @app.route("/database")
    def database():
        return render("database.html", {"title": "安装数据库"})


    @app.route("/database/manager")
    def database_manager():
        return render("database-manager.html", {"title": "创建管理员"})


    @app.route("/redis")
    def redis():
        return render("redis.html", {"title": "Redis 配置"})


    @app.route("/influxdb")
    def influxdb():
        print(SETTINGS['influxdb'])
        return render("influxdb.html", {"title": "InfluxDB 配置", "influxdb": SETTINGS['influxdb']})

def register_blueprint(app):
    from route import setup_bp
    
    app.register_blueprint(setup_bp, url_prefix="/api/v1")


def create_app():
    app = Flask(__name__, static_url_path='')

    register_route(app)
    register_blueprint(app)

    return app