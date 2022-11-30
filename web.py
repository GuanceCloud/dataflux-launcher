# encoding=utf-8

import sys
import logging
import argparse

from flask import Flask

from launcher.app import create_app
from launcher.utils.handler import handle_exception

def start(host="0.0.0.0", port=5000, debug=False, app_log=logging.INFO, http_log=logging.ERROR):
  app: Flask = create_app()
  app.register_error_handler(Exception, handle_exception)

  app.logger.setLevel(app_log)
  logging.getLogger('werkzeug').setLevel(http_log)

  app.run(host=host, port=port, debug=True)


if __name__ == "__main__":
  parser = argparse.ArgumentParser(description='Start web server.')

  parser.add_argument('--host', dest='host',
                      default="0.0.0.0",
                      help='bind host(default: 0.0.0.0)')

  parser.add_argument('--port', dest='port', type=int,
                      default=5000,
                      help='bind port(default: 5000)')
  
  parser.add_argument('--debug', dest='debug', type=bool, default=False, help='debug mode')
  parser.add_argument('--app-log', dest='app_log', type=str,default='INFO', help='app log level')
  parser.add_argument('--http-log', dest='http_log', type=str, default='ERROR', help='http log level')
  
  args = parser.parse_args()
  logging.basicConfig(
    format="%(asctime)s\t%(levelname)s\t%(filename)s:%(lineno)d\t%(message)s",
    level=getattr(logging, args.app_log, logging.INFO),
    stream=sys.stdout
  )
  start(args.host, args.port, args.debug, args.app_log, args.http_log)
