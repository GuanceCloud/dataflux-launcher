#!/bin/bash

tmpRTMDir=/tmp/rtm

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

  # 最后的 rtm tag
  lastRTMTag=$(git tag --list | grep -E '^rtm_' | sort -V | tail -1)

  # 根据 release tag 转换过来的 rtm tag 前缀
  newRTMTagPrefix=${lastReleaseTag//release_/rtm_}

  [[ ${lastRTMTag:0:${#newRTMTagPrefix}} == $newRTMTagPrefix  ]] && {
    # rtm tag 已经存在，后续版本数字递增1
    lastReleaseRTMCount=$[10#${lastRTMTag:${#newRTMTagPrefix} + 1:2} + 101]
    lastReleaseRTMCount=${lastReleaseRTMCount:1:2}

    newRTMTag=${newRTMTagPrefix}_${lastReleaseRTMCount}
  } || {
    # rtm tag 不存在，生成新的 rtm tag
    newRTMTag=${newRTMTagPrefix}_01
  }

  rtmTag=${newRTMTag}_$shortCommitId
  git tag $rtmTag
  # git push --tag

  echo $rtmTag
}

rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/cloudcare-forethought-setup.git" "cloudcare-forethought-setup"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/cloudcare-forethought-backend.git" "cloudcare-forethought-backend"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/kodo.git" "kodo"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare/cloudcare-forethought-webclient.git" "cloudcare-forethought-webclient"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare/cloudcare-forethought-webmanage.git" "cloudcare-forethought-webmanage"

# 清除临时项目目录
# rm -rf /tmp/rtm

