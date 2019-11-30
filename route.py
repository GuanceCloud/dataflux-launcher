# encoding=utf-8

from flask import Blueprint, request
from utils.handler import response_jsonify

from controller import setup
from controller import db_setup_core
from controller import redis_setup
from controller import influxdb_setup

setup_bp = Blueprint('setup', __name__)


@setup_bp.route("/setting/init", methods=["POST"])
def init_setting():
    d = request.json

    return response_jsonify(setup.init_setting(d))


@setup_bp.route("/database/ping", methods=["GET"])
def database_ping():
    args = request.args.to_dict()

    return response_jsonify(db_setup_core.database_ping(args))


@setup_bp.route("/database/setup", methods=["POST"])
def database_setup():
    return response_jsonify(db_setup_core.database_setup())


@setup_bp.route("/database/manager/add", methods=["POST"])
def database_manage_account():
    data = request.json

    return response_jsonify(db_setup_core.database_manage_account(data))
    

@setup_bp.route("/redis/ping", methods=["GET"])
def redis_ping():
    args = request.args.to_dict()

    return  response_jsonify(redis_setup.redis_ping(args))
    

@setup_bp.route("/influxdb/ping", methods=["POST"])
def influxdb_ping():
    data = request.json

    return  response_jsonify(influxdb_setup.influxdb_ping_all(data))
    

@setup_bp.route("/influxdb/add", methods=["POST"])
def influxdb_add():
    data = request.json

    return  response_jsonify(influxdb_setup.influxdb_add(data))


@setup_bp.route("/influxdb/remove", methods=["POST"])
def influxdb_remove():
    data = request.json

    return  response_jsonify(influxdb_setup.influxdb_remove(data))

    return  response_jsonify(influxdb_setup.influxdb_add(data))


@setup_bp.route("/influxdb/setup", methods=["POST"])
def init_influxdb_all():
    # data = request.json

    return  response_jsonify(influxdb_setup.init_influxdb_all())
