# encoding=utf-8

import sys
import logging
import argparse
from launcher.app import create_app

def start(host="0.0.0.0", port=5000):
  app = create_app()

  app.debug = True
  app.run(host=host, port=port)


if __name__ == "__main__":
  parser = argparse.ArgumentParser(description='Start web server.')

  parser.add_argument('--host', dest='host',
                      default="0.0.0.0",
                      help='bind host(default: 0.0.0.0)')

  parser.add_argument('--port', dest='port', type=int,
                      default=5000,
                      help='bind port(default: 5000)')

  parser.add_argument('--log-level', dest='log_level', type=str,
                      default='INFO',
                      help='logging level')
  
  args = parser.parse_args()
  logging.basicConfig(
    format="%(asctime)s\t%(levelname)s\t%(filename)s:%(lineno)d\t%(funcName)s\t%(message)s",
    level=getattr(logging, args.log_level, logging.INFO),
    stream=sys.stdout
  )
  start(args.host, args.port)
