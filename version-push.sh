#!/bin/bash

# 向 shrine 系统推送当前发布的最新的版本号，以便 shrine 去邮件通知相关 TAM 为客户升级 DF 系统。

git fetch --tag
lastRTM=$(git tag --list | grep -E "\d+\.\d+\.\d+-\w+-\d+-prod" | sort -V | tail -1)

v=(${lastRTM//[\.-]/ })
version=${v[0]}.${v[1]}.${v[2]}

curl 'https://shrine-via-core-stone.cloudcare.cn/resources/action/dataFluxVersionUpdate@customerXAdmin' \
  -X POST \
  -H 'content-type: application/json;charset=UTF-8' \
  --data-raw '{"content": {"version": "v'${version}'"} }' \
  --compressed
