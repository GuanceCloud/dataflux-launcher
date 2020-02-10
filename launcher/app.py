# encoding=utf-8

from flask import Flask, request, g

from launcher.utils.template import render
from launcher.controller import setup
from launcher.controller import env_check
from launcher.controller import update

from launcher.utils import decorators

from . import settingsMdl, SERVICECONFIG, STEPS_COMMON, STEPS_INSTALL, STEPS_UPDATE, DOCKERIMAGES


# 全新安装时的路由套装
def register_install_router(app):

  @app.before_request
  def set_step():
    path = request.path
    isPrev = True

    steps = None
    if path.startswith("/install"):
      steps = STEPS_COMMON + STEPS_INSTALL
    elif path.startswith("/up"):
      steps = STEPS_COMMON + STEPS_UPDATE
    else:
      steps = STEPS_COMMON

    for step in steps:
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

    return render("index.html", {"title": "安装说明", "pageData": readme, "steps": STEPS_COMMON + [{'name': '......'}]})


  @app.route("/check")
  def check():
    checkResult = env_check.do_check()
    serviceStatus =setup.service_status()

    deploys = []
    for deploy in serviceStatus:
      item = {
            "namespace": deploy['namespace'],
            "services": []
          }

      for service in deploy['services']:
        if service.get('fullImagePath'):
            item['services'].append(service)

      if len(item['services']) > 0:
        deploys.append(item)

    result = {
                "check": checkResult,
                "deploy": deploys
            }

    setup.init_setting()

    return render("check.html", {"title": "环境检查", "pageData": result, "steps": STEPS_COMMON + [{'name': '......'}]})


  @app.route("/install/database")
  @decorators.upgrade_install
  def database():
    return render("database.html", {"title": "MySQL 设置", "pageData": settingsMdl.mysql, "steps": STEPS_COMMON + STEPS_INSTALL})


  @app.route("/install/other")
  @decorators.upgrade_install
  def other():
    data = {
      'domain': settingsMdl.domain,
      'other': settingsMdl.other
    }

    if 'manager' not in data['other']:
      data['other']['manager'] = {}

    if 'tls' not in data['other']:
      data['other']['tls'] = {}

    if 'subDomain' not in data['domain']:
      data['domain']['subDomain'] = {}

    return render("other.html", {"title": "其他设置", "pageData": data, "steps": STEPS_COMMON + STEPS_INSTALL})


  @app.route("/install/redis")
  def redis():
    return render("redis.html", {"title": "Redis 设置", "pageData": settingsMdl.redis, "steps": STEPS_COMMON + STEPS_INSTALL})


  @app.route("/install/influxdb")
  def influxdb():
    rps = SERVICECONFIG['influxDB']['replication']
    influxs = settingsMdl.influxdb

    return render("influxdb.html", {"title": "InfluxDB 设置", "pageData": {"influxs": influxs, "rps": rps}, "steps": STEPS_COMMON + STEPS_INSTALL})


  @app.route("/install/setup/info")
  def setup_info():
    return render("setup-info.html", {"title": "安装信息", "pageData": settingsMdl, "steps": STEPS_COMMON + STEPS_INSTALL})


  @app.route("/install/config/review")
  def config_review():
    config = setup.config_template()

    return render("config-review.html", {"title": "应用配置文件", "pageData": config, "steps": STEPS_COMMON + STEPS_INSTALL})


  @app.route("/install/service/config")
  def serviceConfig():
    d = setup.service_image_config()

    return render("service-config.html", {"title": "应用镜像", "pageData": d, "steps": STEPS_COMMON + STEPS_INSTALL})


  @app.route("/install/service/status")
  def service_status():
    return render("service-status.html", {"title": "应用状态", "pageData": setup.service_status(), "steps": STEPS_COMMON + STEPS_INSTALL})


  # @app.route("/complete")
  # def complete():
  #   return render("complete.html", {"title": "安装完毕"})


# 升级安装路由套装
def register_update_router(app):

  @app.route("/up/service")
  def up_service():
    deployStatus = update.deploy_check()

    allUpdated = True
    for ns in deployStatus:
      for deploy in ns['services']:
        print(deploy)
        if deploy['newImagePath'] != deploy['fullImagePath'] or deploy['replicas'] != deploy['availableReplicas']:
          allUpdated = False

          break
      if not allUpdated:
        break

    return render("up/service.html", {"title": "应用升级", "pageData": { "deployStatus": deployStatus, "allUpdated": allUpdated}, "steps": STEPS_COMMON + STEPS_UPDATE })


  @app.route("/up/configmap")
  def up_configmap():
    configmaps = update.list_source_and_update_configmaps()

    return render("up/configmap.html", {"title": "配置升级", "pageData": configmaps, "steps": STEPS_COMMON + STEPS_UPDATE })


def register_blueprint(app):
  from launcher.route import setup_bp

  app.register_blueprint(setup_bp, url_prefix="/api/v1")


def create_app():
  app = Flask(__name__, static_url_path='')

  register_install_router(app)
  register_update_router(app)

  register_blueprint(app)

  return app
