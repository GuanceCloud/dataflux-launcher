#!/bin/bash

tmpRTMDir=/tmp/rtm
workDir=$(pwd)
imageYaml=config/docker-image.yaml

# 从各项目中捞各个 upgrade.yaml 文件
function copy_upgrade(){
  project=$1

  [[ ! -d "${workDir}/upgrade" ]] && mkdir "${workDir}/upgrade"

  if [ $project = "core" ]; then
    cp upgrade/upgrade.yaml ${workDir}/upgrade/core-upgrade.yaml
    cp launcher/resource/v1/ddl/core.sql ${workDir}/db/core_latest.sql
  elif [ $project = "trigger" ]; then
    cp upgrade.yaml ${workDir}/upgrade/trigger-upgrade.yaml
  elif [ $project = "kodo" ]; then
    cp image/upgrade.yaml ${workDir}/upgrade/kodo-upgrade.yaml
  elif [ $project = "func" ]; then
    cp upgrade-info.yaml ${workDir}/upgrade/func-upgrade.yaml
    cp launcher/resource/v1/ddl/func.sql ${workDir}/db/ft_data_processor_latest.sql
  elif [ $project = "message-desk" ]; then
    cp upgrade.yaml ${workDir}/upgrade/messageDesk-upgrade.yaml
    cp launcher/resource/v1/ddl/message-desk.sql ${workDir}/db/message_desk_latest.sql
  fi
}

function rtm_tag(){
  gitUrl=$1
  project=$2
  imagePath=$3

  [[ ! -d "$tmpRTMDir" ]] && mkdir $tmpRTMDir
  cd $tmpRTMDir

  [[ ! -d "${tmpRTMDir}/${project}" ]] && {
    git clone $gitUrl ${tmpRTMDir}/${project}
    cd ${tmpRTMDir}/${project}
  } || {
    cd ${tmpRTMDir}/${project}
    git fetch --tag
  }

  # 最后的 release tag
  lastReleaseTag=$(git tag --list | grep -E '^release_' | sort -V | tail -1)
  # echo ${#lastReleaseTag}
  [[ ${#lastReleaseTag} == 0 ]] && return

  git checkout $lastReleaseTag

  [[ ${project} != "launcher" ]] && {
    # 复制项目内最新的 upgrade 文件到 launcher 内
    copy_upgrade $project

    echo "    ${project}: ${imagePath}:${lastReleaseTag}" >> ${workDir}/${imageYaml}
  }
}

: > ${imageYaml}
echo "apps:" > ${workDir}/${imageYaml}
echo "  registry: registry.jiagouyun.com" >> ${workDir}/${imageYaml}
echo "  image_dir: ''" >> ${workDir}/${imageYaml}
echo "  images:" >> ${workDir}/${imageYaml}
echo "    nsq: basis/nsq:v1.2.0" >> ${workDir}/${imageYaml}
echo "    nginx: basis/nginx:devops" >> ${workDir}/${imageYaml}
echo "    kapacitor: basis/kapacitor:1.5.3" >> ${workDir}/${imageYaml}

rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/cloudcare-forethought-backend.git" "core" "cloudcare-forethought/cloudcare-forethought-backend"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/kodo.git" "kodo" "kodo/kodo"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare/cloudcare-forethought-webclient.git" "front-webclient" "cloudcare-front/cloudcare-forethought-webclient"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare/cloudcare-forethought-webmanage.git" "management-webclient" "cloudcare-front/cloudcare-forethought-webmanage"

rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/middlewares/message-desk.git" "message-desk" "middlewares/message-desk"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/middlewares/message-desk-worker.git" "message-desk-worker" "middlewares/message-desk-worker"

rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/middlewares/ft-data-processor.git" "func" "middlewares/ft-data-processor"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/middlewares/ft-data-processor-worker.git" "func-worker" "middlewares/ft-data-processor-worker"

rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/cloudcare-forethought-trigger.git" "trigger" "cloudcare-forethought/cloudcare-forethought-trigger"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/screenhot-server.git" "utils-server" "cloudcare-forethought/utils-server"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/cloudcare-forethought-setup.git" "launcher" "cloudcare-forethought/cloudcare-forethought-setup"

