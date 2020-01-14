# encoding=utf-8

import os, re, subprocess
import markdown, shortuuid, pymysql
import json, time

from launcher.utils.template import jinjia2_render

from launcher import SETTINGS, SERVICECONFIG, DOCKERIMAGES


def deploy_status():
  namespaces = SERVICECONFIG['namespaces']

  tempStatus = {}
  for ns in namespaces:
    cmd = 'kubectl get deployments -n {} -o json'.format(ns)
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

    output, err = p.communicate()
    deploys = json.loads(output)

    for item in deploys['items']:
      key = item['metadata']['name']
      image = item['spec']['template']['spec']['containers'][0]['image']

      status = {}
      if 'conditions' in item['status']:
        status = {c['type']: c['status'] for c in item['status']['conditions']}

      status['fullImagePath'] = image
      status['key'] = key
      status['replicas'] = item['status'].get('replicas', 0)
      status['availableReplicas'] = item['status'].get('availableReplicas', 0)

      tempStatus[key] = status

  deployStatus = []
  for ns in SERVICECONFIG['services']:
    ds = {
      "namespace": ns["namespace"],
      "services": []
    }
    for service in ns['services']:
      key = service['key']
      name = service['name']

      if key in tempStatus:
          tempStatus[key]['name'] = name
          tempStatus[key]['imageKey'] = service['image']

          ds["services"].append(tempStatus[key])
      else:
          ds["services"].append({
                  'key': key,
                  'name': name,
                  'imageKey': service['image'],
                  'replicas': 0,
                  'availableReplicas': 0
              })

    deployStatus.append(ds)

  return deployStatus


def deploy_patch(patch):
  cmd = 'kubectl get deployments -n {} -o json'.format(ns)
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
