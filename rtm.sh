#!/bin/bash

tmpRTMDir=/tmp/rtm
workDir=$(pwd)
imageYaml=config/docker-image.yaml


function init(){
  opt=$1

  git fetch --tag
  lastRTM=$(git tag --list | grep -E "^rtm_\d{1,2}_" | sort -V | tail -1)

  [[ ${#lastRTM} > 0 ]] && {
    v=(${lastRTM//_/ })

    releaseCount=$[10#${v[3]} + 10001]
    releaseCount=${releaseCount:1:4}

    case ${opt} in
      f )
        minorVersion=${v[2]}
        ;;
      m )
        minorVersion=$[10#${v[2]} + 1]
        ;;
    esac

    version=${v[1]}_${minorVersion}_${releaseCount}_$(date +%Y%m%d)
  } || {
    version=1_0_0001_$(date +%Y%m%d)
  }

  VDIR=v${version//_/.}
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
  lastReleaseTag=$(git tag --list | grep -E '^release_' | sort -V | tail -1)
  # echo ${#lastReleaseTag}
  [[ ${#lastReleaseTag} == 0 ]] && return

  git checkout $lastReleaseTag

  # 格式化成 release_20191216_01 格式
  lastReleaseTag=${lastReleaseTag//[\.-\/]/_}

  [[ ${lastReleaseTag:0-3:1} != _ ]] && lastReleaseTag=${lastReleaseTag}_01

  rtmTag=rtm_${version}_${lastReleaseTag//release_/}

  git tag $rtmTag
  git push --tag

  echo "\033[33m${rtmTag}\033[00m \t\t \033[32m[${project}]\033[00m"
  echo "\n"

  [[ $project != "launcher" ]] && {
    echo "    ${project}: ${VDIR}:${project}_${lastReleaseTag//release_/rc_}" >> ${workDir}/${imageYaml}
  }
}

function start(){
  init $1

  : > ${imageYaml}
  echo "apps:" > ${workDir}/${imageYaml}
  echo "  registry: pubrepo.jiagouyun.com" >> ${workDir}/${imageYaml}
  echo "  image_dir: dataflux/" >> ${workDir}/${imageYaml}
  echo "  images:" >> ${workDir}/${imageYaml}
  echo "    nsq: basis:nsq_1.2.0" >> ${workDir}/${imageYaml}
  echo "    nginx: basis:nginx_1.13.3" >> ${workDir}/${imageYaml}
  echo "    kapacitor: basis:kapacitor_1.5.3" >> ${workDir}/${imageYaml}

  rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/cloudcare-forethought-backend.git" "core"
  rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/kodo.git" "kodo"
  rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare/cloudcare-forethought-webclient.git" "front-webclient"
  rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare/cloudcare-forethought-webmanage.git" "management-webclient"

  rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/middlewares/message-desk.git" "message-desk"
  rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/middlewares/message-desk-worker.git" "message-desk-worker"

  rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/middlewares/ft-data-processor.git" "func"
  rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/middlewares/ft-data-processor-worker.git" "func-worker"

  rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/cloudcare-forethought-trigger.git" "trigger"

  echo "  version: ${VDIR}" >> ${workDir}/${imageYaml}

  cd $workDir
  git add ${imageYaml}
  git commit -m 'auto commit: RTM release'
  git push

  sh release.sh -r

  rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/cloudcare-forethought-setup.git" "launcher"
} 

while getopts ":fm" opt; do
  case ${opt} in
    f )
      start "f"
      ;;
    m )
      start "m"
      ;;
    \? ) 
      echo "支持的选项: "
      echo "  -f  问题修复版本，主版本号、次版本号都不递增"
      echo "  -m  小功能迭代，小版本号递增"
      ;;
  esac
done
