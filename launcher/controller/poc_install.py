import os
import logging
import subprocess

from launcher import SERVICECONFIG
from launcher.utils.template import jinjia2_render


def install_mysql(**params):
    logging.debug("install mysql")

    tmp_dir = SERVICECONFIG['tmpDir']
    if not os.path.exists(tmp_dir):
        os.mkdir(tmp_dir)

    yaml_name = 'mysql.yaml'
    yaml_path: str = os.path.join(tmp_dir, yaml_name)
    yaml_data: str = jinjia2_render(f"template/poc/{yaml_name}", params)
    with open(yaml_path, 'w') as fs:
        fs.write(yaml_data)
    
    subprocess.run(f"kubectl apply -n middleware -f {yaml_path}", shell=True)

def install_redis(**params):
    logging.debug("install redis")
    
    tmp_dir = SERVICECONFIG['tmpDir']
    if not os.path.exists(tmp_dir):
        os.mkdir(tmp_dir)

    yaml_name = 'redis.yaml'
    yaml_path: str = os.path.join(tmp_dir, yaml_name)
    yaml_data: str = jinjia2_render(f"template/poc/{yaml_name}", params)
    with open(yaml_path, 'w') as fs:
        fs.write(yaml_data) 
    
    subprocess.run(f"kubectl apply -n middleware -f {yaml_path}", shell=True)

def install_opensearch(**params):
    logging.debug("install opensearch")

    tmp_dir = SERVICECONFIG['tmpDir']  
    if not os.path.exists(tmp_dir):
        os.mkdir(tmp_dir)

    yaml_name = 'opensearch.yaml'
    yaml_path: str = os.path.join(tmp_dir, yaml_name)
    yaml_data: str = jinjia2_render(f"template/poc/{yaml_name}", params)
    with open(yaml_path, 'w') as fs:
        fs.write(yaml_data)
    
    subprocess.run(f"kubectl apply -n middleware -f {yaml_path}", shell=True)

def install_tdengine(**params):
    logging.debug("install tdengine")

    tmp_dir = SERVICECONFIG['tmpDir']  
    if not os.path.exists(tmp_dir):
        os.mkdir(tmp_dir)

    yaml_name = 'tdengine.yaml'
    yaml_path: str = os.path.join(tmp_dir, yaml_name)
    yaml_data: str = jinjia2_render(f"template/poc/{yaml_name}", params)
    with open(yaml_path, 'w') as fs:
        fs.write(yaml_data)
    subprocess.run(f"kubectl apply -n middleware -f {yaml_path}", shell=True)
