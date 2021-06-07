# encoding=utf-8

from launcher.app import create_app

def start(host="0.0.0.0", port=5005):
  app = create_app()

  app.debug = True
  app.run(host=host, port=port)


if __name__ == "__main__":
  start()

