#!/bin/bash

git fetch --tag
lastRTM=$(git tag --list | grep -E "\d+\.\d+\.\d+-\w+-\d+-prod" | sort -V | tail -1)

[[ ${#lastRTM} > 0 ]] && {
  v=(${lastRTM//[\.-]/ })

  releaseCount=$[10#${v[2]}]
  minorVersion=${v[1]}

  version=${v[0]}.${minorVersion}.${releaseCount}
}

curl 'https://shrine-via-core-stone.cloudcare.cn/resources/action/dataFluxVersionUpdate@customerXAdmin' \
    -X POST \
    -H 'content-type: application/json;charset=UTF-8' \
    --data-raw '{"content": {"version": "v'${version}'"} }' \
    --compressed
