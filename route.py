# encoding=utf-8

from flask import Blueprint, request
from utils.handler import response_jsonify

from controller import setup

setup_bp = Blueprint('setup', __name__)


@setup_bp.route("/database/ping", methods=["GET"])
def database_ping():
    args = request.args.to_dict()

    return response_jsonify(setup.database_ping(args))


@setup_bp.route("/database/setup", methods=["POST"])
def database_setup():
    return response_jsonify(setup.database_setup())
    

@setup_bp.route("/redis/ping", methods=["GET"])
def redis_ping():
    return  response_jsonify(True)