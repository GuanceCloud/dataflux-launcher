# encoding=utf-8

import os, re, subprocess
import json, time

from launcher import SETTINGS, SERVICECONFIG


def __get_k8s_cluster_info():
  cmd = "kubectl cluster-info"
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  output, err = p.communicate()

  if not output:
      return []

  output = str(output, encoding = "utf-8")
  clusterInfo = []

  for line in output.split('\n'):
    if 'is running at' not in line:
        continue

    clusterInfo.append(re.sub(r"\x1b\[\d+(;\d+)?m", "", line))

  return clusterInfo


def __deploy_info():
  cmd = "kubectl get namespaces {} -o json".format(' '.join(SERVICECONFIG['namespaces']))
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  output, err = p.communicate()
  namespaceJson = json.loads(output)

  namespaces = [ ns['metadata']['name'] for ns in namespaceJson['items'] ]

  return '; '.join(namespaces)


def __get_storageclass():
  cmd = "kubectl get storageclass -o json"
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

  output, err = p.communicate()
  storage = json.loads(output)

  storageNames = []
  for item in storage['items']:
    storageNames.append(item['metadata']['name'])

  return '; '.join(storageNames)


def do_check():
  checkResult = {
                    "clusterInfo": __get_k8s_cluster_info()
                }

  if len(checkResult['clusterInfo']) > 0:
    checkResult['deploy_info'] = __deploy_info()

  if len(checkResult['clusterInfo']) > 0:
    checkResult['storage'] = __get_storageclass()

  return checkResult


