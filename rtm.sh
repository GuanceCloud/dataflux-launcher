#!/bin/bash

version=$1
tmpRTMDir=/tmp/rtm

[[ ${#version} == 0 ]] && {
  echo 请提供版本号
  exit
}

version=${version//[v\.]/_}

function rtm_tag(){
  gitUrl=$1
  project=$2

  [[ ! -d "$tmpRTMDir" ]] && mkdir $tmpRTMDir

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

  shortCommitId=$(git rev-parse --short $lastReleaseTag)
  git checkout $lastReleaseTag

  # 格式化成 release_20191216_01 格式
  lastReleaseTag=${lastReleaseTag//[\.-\/]/_}

  [[ ${lastReleaseTag:0-3:1} != _ ]] && lastReleaseTag=${lastReleaseTag}_01

  rtmTag=${lastReleaseTag//release_/rtm_}${version}

  git tag $rtmTag
  git push --tag

  echo "${rtmTag}\t\t${project}"
}

rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/cloudcare-forethought-setup.git" "cloudcare-forethought-setup"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/cloudcare-forethought-backend.git" "cloudcare-forethought-backend"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/kodo.git" "kodo"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare/cloudcare-forethought-webclient.git" "cloudcare-forethought-webclient"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare/cloudcare-forethought-webmanage.git" "cloudcare-forethought-webmanage"

