# encoding=utf-8

import logging

from flask import Flask, request, g

from launcher.utils.template import render
from launcher.controller import setup
from launcher.controller import env_check
from launcher.controller import update
from launcher.controller import setting as settingCtrl
from launcher.model import authorize as authorizeMdl

from launcher.utils import decorators

from . import settingsMdl, SERVICECONFIG, STEPS_COMMON, STEPS_INSTALL, STEPS_UPDATE, DOCKERIMAGES


# 全新安装时的路由套装
def register_install_router(app):

  # @app.before_request
  def license_check():
    path = request.path

    # 只在升级时需要检测当前系统的 License 激活状态
    if not path.startswith("/up"):
        return None

    dk_total, status_code= authorizeMdl.get_usage_datakit_total()
    content = settingCtrl.get_activated_license()

    if status_code == 200 and content.get('status', False):
      extra = content.get('license', {}).get('Extra', {})
      # 限制当前已经接入的 DataKit 数量必须小于 License 限制的数量，才允许升级 版本
      if dk_total > extra.get('DKLimit', -1):
        # TO DO
        # 这个逻辑可以在后续的版本中进行限制
        # 留一个过渡的版本,这个之后的版本,必须先升级到此版本后,才允许升级到后续的版本
        pass


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

    # import requests
    # requests.get('http://127.0.0.1:5006/')
    return render("index.html", {"title": "使用协议", "pageData": readme, "steps": STEPS_COMMON + [{'name': '......'}]})


  @app.route("/check")
  def check():
    checkResult = env_check.do_check()
    serviceStatus =setup.service_status()
    
    dbCheckResult = env_check.db_setting_check()
    appVersion = env_check.get_current_version()

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
                "deploy": deploys,
                "db": dbCheckResult,
                "v": appVersion
            }

    setup.init_setting()

    return render("check.html", {"title": "环境检查", "pageData": result, "steps": STEPS_COMMON + [{'name': '......'}]})


  @app.route("/install/database")
  @decorators.upgrade_install
  def database():
    storage_classes: list = env_check.get_storageclass()
    
    return render("database.html", {
      "title": "MySQL 设置",
      "pageData": settingsMdl.mysql,
      "steps": STEPS_COMMON + STEPS_INSTALL,
      'storageClasses': storage_classes
    })


  @app.route("/install/other")
  @decorators.upgrade_install
  def other():
    data = {
      'domain': settingsMdl.domain,
      'other': settingsMdl.other
    }

    if 'manager' not in data['other']:
      data['other']['manager'] = {}

    if 'cc' not in data['other']:
      data['other']['cc'] = {}

    if 'dial' not in data['other']:
      data['other']['dial'] = {}

    if 'tls' not in data['other']:
      data['other']['tls'] = {}

    if 'subDomain' not in data['domain']:
      data['domain']['subDomain'] = SERVICECONFIG.get('defaultSubdomain', {}).copy()

    if 'nodeInternalIP' not in data['other']:
      data['other']['nodeInternalIP'] = setup.get_node_internal_ip()

    if 'storageClassName' not in data['other']:
      data['other']['storageClassName'] = ''

    return render("other.html", {"title": "其他设置", "pageData": data, "steps": STEPS_COMMON + STEPS_INSTALL})


  @app.route("/install/redis")
  def redis():
    storage_classes: list = env_check.get_storageclass()
    
    return render("redis.html", {
      "title": "Redis 设置",
      "pageData": settingsMdl.redis,
      "steps": STEPS_COMMON + STEPS_INSTALL,
      'storageClasses': storage_classes
    })


  @app.route("/install/elasticsearch")
  def elasticsearch():
    storage_classes: list = env_check.get_storageclass()
    
    return render("elasticsearch.html", {
      "title": "Elasticsearch 设置",
      "pageData": settingsMdl.elasticsearch,
      "steps": STEPS_COMMON + STEPS_INSTALL,
      'storageClasses': storage_classes
    })


  @app.route("/install/influxdb")
  def influxdb():
    rps = SERVICECONFIG['influxDB']['replication']
    influxs = settingsMdl.influxdb

    storage_classes: list = env_check.get_storageclass()

    return render("influxdb.html", {
      "title": "时序引擎 设置",
      "pageData": {"influxs": influxs, "rps": rps},
      "steps": STEPS_COMMON + STEPS_INSTALL,
      'storageClasses': storage_classes
    })

  @app.route("/install/external-dataway")
  def external_dataway():
    nodes = env_check.list_nodes()
    node_ips = []
    for node in nodes:
      for item in node['status']['addresses']:
        if item['type'] == 'InternalIP':
          node_ips.append(item['address'])

    return render("external-dataway.html", {
      "title": "安装数据网关",
      "node_ips": node_ips,
      "steps": STEPS_COMMON + STEPS_INSTALL
    })

  @app.route("/install/aksk")
  def aksk():
    ccAK = settingsMdl.other.get('cc', {})
    dialAK = settingsMdl.other.get('dial', {})

    return render("aksk.html", {"title": "AK 配置", "pageData": {"cc": ccAK, "dial": dialAK}, "steps": STEPS_COMMON + STEPS_INSTALL})


  @app.route("/install/setup/info")
  def setup_info():
    return render("setup-info.html", {"title": "安装信息", "pageData": settingsMdl, "steps": STEPS_COMMON + STEPS_INSTALL})


  @app.route("/install/config/review")
  def config_review():
    config = setup.config_template()

    # print('```>> ', config)
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

  @app.route("/up/preparation")
  def up_preparation():
    launcherPreparation = update.list_launcher_preparation()

    return render("up/preparation.html", {"title": "升级准备", "pageData": launcherPreparation, "steps": STEPS_COMMON + STEPS_UPDATE})


  @app.route("/up/newconfigmap")
  def up_new_configmap():
    newConfigmap = update.new_configmap_check()

    newCount = sum([len(item['configmaps']) for item in newConfigmap])

    return render("up/new-config.html", {"title": "新增应用配置", "pageData": {"data": newConfigmap, "count": newCount}, "steps": STEPS_COMMON + STEPS_UPDATE})


  @app.route("/up/service")
  def up_service():
    deployStatus = update.deploy_check()

    allUpdated = True
    for ns in deployStatus:
      ns['updateCount'] = 0
      ns['newCount']    = 0

      for deploy in ns['services']:
        # if deploy['newImagePath'] != deploy.get('fullImagePath', '') or deploy['replicas'] != deploy['availableReplicas']:
        #   allUpdated = False

        if deploy['isUpdate']:
          ns['updateCount'] = ns['updateCount'] + 1
          allUpdated = False

        if deploy['isNew'] and not deploy['disabled']:
          ns['newCount'] = ns['newCount'] + 1
          allUpdated = False

    return render("up/service.html", {"title": "升级应用", "pageData": { "deployStatus": deployStatus, "allUpdated": allUpdated}, "steps": STEPS_COMMON + STEPS_UPDATE })


  @app.route("/up/configmap")
  def up_configmap():
    configmaps = update.list_source_and_update_configmaps()

    return render("up/configmap.html", {"title": "升级应用配置", "pageData": configmaps, "steps": STEPS_COMMON + STEPS_UPDATE })


  @app.route("/up/database")
  def up_database():
    databaseSQL = update.list_update_database_sql()

    noUpdate = True

    for key, val in databaseSQL.items():
      sqls = val.get('sqls')

      if sqls and len(sqls) > 0:
        noUpdate = False
        break

    return render("up/database.html", {"title": "升级数据库", "pageData": databaseSQL, "noUpdate": noUpdate, "steps": STEPS_COMMON + STEPS_UPDATE })


  @app.route("/up/service/status")
  def up_service_status():
    serviceStatus = setup.service_status()

    return render("up/finished.html", {"title": "应用启动状态", "pageData": serviceStatus, "steps": STEPS_COMMON + STEPS_UPDATE })


  @app.route("/setting/configmap")
  def setting_configmap():
    configmaps = update.list_source_and_update_configmaps()

    return render("setting/configmap.html", {"title": "修改应用配置", "pageData": configmaps, "steps": STEPS_COMMON + STEPS_UPDATE })


def register_blueprint(app):
  from launcher.route import setup_bp

  app.register_blueprint(setup_bp, url_prefix="/api/v1")


def create_app():
  app = Flask(__name__, static_url_path='')

  register_install_router(app)
  register_update_router(app)

  register_blueprint(app)

  return app
