import os
import json
import logging
import shortuuid
import subprocess

from launcher import settingsMdl, DOCKERIMAGES, SERVICECONFIG
from launcher.utils.template import jinjia2_render
from launcher.model.k8s import registry_secret_get
from launcher.utils.helper.db_helper import dbHelper

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

def install_external_dataway(**params):
    logging.debug(f"install external dataway: {params}")

    namespace = 'utils'
    deployment = 'external-dataway'
    # 已经安装时直接返回
    result = subprocess.run(f"kubectl get deploy -n {namespace} -o json {deployment}", shell=True, check=True, capture_output=True)
    status = json.loads(result.stdout.decode()).get('status')
    logging.debug(f"dataway deploy status: {status}")
    if status['replicas'] == status['readyReplicas']:
        return

    base_settings = settingsMdl.mysql.get('base')
    core_settings = settingsMdl.mysql.get('core')

    docker_config = registry_secret_get(namespace, 'registry-key').pop()
    registry_address = docker_config['address'].rstrip('/')
    image_dir = DOCKERIMAGES['apps']['image_dir'].rstrip('/')
    dataway_image = DOCKERIMAGES['apps']['images']['internal-dataway']

    params['other'] = settingsMdl.other
    params['image'] = f'{registry_address}/{image_dir}/{dataway_image}'
    params['uuid'] = f'agnt_{shortuuid.ShortUUID().random(length=24)}'
    
    sql  = '''
    INSERT INTO `main_agent` (`uuid`, `name`, `url`, `workspaceUUID`, `createAt`, `uploadAt`, `deleteAt`, `updateAt`)
    VALUES ('{uuid}', '{name}', '{url}', 'wksp_system', UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), -1, UNIX_TIMESTAMP());
    '''.format(**params)
    logging.debug(f"create dataway record: {sql}")
    
    results = []
    with dbHelper(base_settings) as db:
        results.extend(db.execute(sql, dbName=core_settings['database']))
    
    tmp_dir = SERVICECONFIG['tmpDir']
    if not os.path.exists(tmp_dir):
        os.mkdir(tmp_dir)

    yaml_name = 'external-dataway.yaml'
    yaml_path: str = os.path.join(tmp_dir, yaml_name)
    yaml_data: str = jinjia2_render(f"template/poc/{yaml_name}", params)
    with open(yaml_path, 'w') as fs:
        fs.write(yaml_data)
    subprocess.run(f"kubectl apply -n {namespace} -f {yaml_path}", shell=True)
