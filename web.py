# encoding=utf-8

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
  
  args = parser.parse_args()
  start(args.host, args.port)
