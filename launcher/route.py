# encoding=utf-8

from flask import Blueprint, request
from launcher.utils.handler import response_jsonify

from launcher.controller import setting
from launcher.controller import setup
from launcher.controller import db_setup_core
from launcher.controller import db_setup_message_desk
from launcher.controller import db_setup_func
from launcher.controller import redis_setup
from launcher.controller import elasticsearch_setup
from launcher.controller import influxdb_setup
from launcher.controller import update

setup_bp = Blueprint('setup', __name__)


@setup_bp.route("/setting/init", methods=["POST"])
def init_setting():
  return response_jsonify(setup.init_setting())


@setup_bp.route("/database/ping", methods=["GET"])
def database_ping():
  args = request.args.to_dict()

  return response_jsonify(db_setup_core.database_ping(args))


@setup_bp.route("/database/setup", methods=["POST"])
def database_setup():
  db_setup_core.database_setup()
  db_setup_message_desk.database_setup()
  db_setup_func.database_setup()

  return response_jsonify(True)


@setup_bp.route("/aksk/save", methods=["POST"])
def aksk_save():
  data = request.json

  return response_jsonify(setup.aksk_save(data))


@setup_bp.route("/other/config", methods=["POST"])
def other_config():
  data = request.json

  return response_jsonify(setup.other_config(data))


@setup_bp.route("/database/manager/create", methods=["POST"])
def database_manage_account_create():
  return response_jsonify(db_setup_core.database_manage_account_create())
  

@setup_bp.route("/redis/ping", methods=["GET"])
def redis_ping():
  args = request.args.to_dict()

  return  response_jsonify(redis_setup.redis_ping(args))


@setup_bp.route("/influxdb/ping", methods=["POST"])
def influxdb_ping():
  data = request.json

  return response_jsonify(influxdb_setup.influxdb_ping_all(data))
  

@setup_bp.route("/influxdb/add", methods=["POST"])
def influxdb_add():
  data = request.json

  return  response_jsonify(influxdb_setup.influxdb_add(data))


@setup_bp.route("/influxdb/remove", methods=["POST"])
def influxdb_remove():
  data = request.json

  return  response_jsonify(influxdb_setup.influxdb_remove(data))


@setup_bp.route("/influxdb/setup", methods=["POST"])
def init_influxdb_all():
  return  response_jsonify(influxdb_setup.init_influxdb_all())


@setup_bp.route("/certificate/create", methods=["POST"])
def certificate_create():
  return  response_jsonify(setup.certificate_create())


@setup_bp.route("/configmap/create", methods=["POST"])
def configmap_create():
  data = request.json

  return  response_jsonify(setup.configmap_create(data))


@setup_bp.route("/service/create", methods=["POST"])
def service_create():
  data = request.json

  return  response_jsonify(setup.service_create(data))


@setup_bp.route("/setting/get", methods=["get"])
def setting_get():
  args = request.args.to_dict()

  return  response_jsonify(setting.setting_get(**args))


@setup_bp.route("/setting/save", methods=["post"])
def setting_save():
  data = request.json

  return  response_jsonify(setting.setting_save(data))


@setup_bp.route("/setting/activate", methods=["post"])
def setting_activate():
  data = request.json

  return  response_jsonify(setting.setting_activate(data))


# @setup_bp.route("/setting/fc/get", methods=["get"])
# def setting_feature_code_get():
#   return  response_jsonify(setting.get_feature_code())


@setup_bp.route("/setting/sync_integration", methods=["post"])
def sync_integration():
  data = request.json

  return  response_jsonify(setup.sync_integration())


@setup_bp.route("/setting/sync_pipeline", methods=["post"])
def sync_pipeline():
  data = request.json

  return  response_jsonify(setup.sync_pipeline())


@setup_bp.route("/service/status", methods=["GET"])
def service_status():
  return  response_jsonify(setup.service_status())


@setup_bp.route("/service/redeploy/all", methods=["GET"])
def redeploy_all():
  return  response_jsonify(setup.redeploy_all())


@setup_bp.route("/version/save", methods=["POST"])
def save_version():
  return  response_jsonify(setup.save_version())


@setup_bp.route("/workspace/init", methods=["POST"])
def workspace_init():
  return  response_jsonify(setup.workspace_init())


@setup_bp.route("/elasticsearch/init", methods=["POST"])
def elasticsearch_init():
  return  response_jsonify(setup.elasticsearch_init())
  

@setup_bp.route("/elasticsearch/ping", methods=["POST"])
def elasticsearch_ping():
  args = request.json

  return  response_jsonify(elasticsearch_setup.elasticsearch_ping(args))


@setup_bp.route("/elasticsearch/setup", methods=["POST"])
def init_elasticsearch():
  return  response_jsonify(elasticsearch_setup.init_elasticsearch())


@setup_bp.route("/studio/init", methods=["POST"])
def studio_init():
  return  response_jsonify(setup.studio_init())


@setup_bp.route("/up/service/status", methods=["GET"])
def up_service_status():
  return  response_jsonify(update.deploy_check())


@setup_bp.route("/up/service/update", methods=["POST"])
def up_service_update():
  return  response_jsonify(update.deploy_update())


@setup_bp.route("/up/configmap/create", methods=["POST"])
def up_configmap_create():
  data = request.json

  return  response_jsonify(update.configmap_create(data))


@setup_bp.route("/up/configmap/update", methods=["POST"])
def up_configmap_update():
  data = request.json

  return  response_jsonify(update.configmap_update(data))


@setup_bp.route("/up/database/update", methods=["POST"])
def up_database_update():
  data    = request.json
  project = data.get('project')

  return  response_jsonify({"project": project, "errorSeq": update.database_update(project)})

