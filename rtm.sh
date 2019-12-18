#!/bin/bash

tmpRTMDir=/tmp/rtm

lastRTM=$(git tag --list | grep -E "^rtm_" | sort -V | tail -1)

[[ ${#lastRTM} > 0 ]] && {
  v=(${lastRTM//_/ })

  releaseCount=$[10#${v[4]} + 1001]
  releaseCount=${releaseCount:1:3}

  version=${v[3]}_${releaseCount}_$(date +%Y%m%d)
} || {
  version=1_001_$(date +%Y%m%d)
}


function rtm_tag(){
  gitUrl=$1
  project=$2

  [[ ! -d "$tmpRTMDir" ]] && mkdir $tmpRTMDir
  cd $tmpRTMDir

  [[ ! -d "${tmpRTMDir}/$project" ]] && {
    git clone $gitUrl ${tmpRTMDir}/$project
    cd ${tmpRTMDir}/$project
  } || {
    cd ${tmpRTMDir}/$project
    git fetch --tag
  }

  # 最后的 release tag
  lastReleaseTag=$(git tag --list | grep -E '^release[-\/]' | sort -V | tail -1)
  # echo ${#lastReleaseTag}
  [[ ${#lastReleaseTag} == 0 ]] && return

  git checkout $lastReleaseTag

  # 格式化成 release_20191216_01 格式
  lastReleaseTag=${lastReleaseTag//[\.-\/]/_}

  [[ ${lastReleaseTag:0-3:1} != _ ]] && lastReleaseTag=${lastReleaseTag}_01

  rtmTag=${lastReleaseTag//release_/rtm_}_${version}

  git tag $rtmTag
  git push --tag

  echo "${rtmTag}\t\t${project}"
}

rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/cloudcare-forethought-setup.git" "setup"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/cloudcare-forethought-backend.git" "core"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/kodo.git" "kodo"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare/cloudcare-forethought-webclient.git" "front-webclient"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare/cloudcare-forethought-webmanage.git" "management-webclient"

rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/middlewares/message-desk.git" "message-desk-api"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/middlewares/message-desk-worker.git" "message-desk-worker"

rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/middlewares/ft-data-processor.git" "data-processor"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/middlewares/ft-data-processor-worker.git" "data-processor-worker"

