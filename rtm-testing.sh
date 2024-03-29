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
    cp db/core_latest.sql ${workDir}/launcher/resource/v1/ddl/core.sql
    cp db/init_data_latest.sql ${workDir}/launcher/resource/v1/data/core.sql
  # elif [ $project = "trigger" ]; then
  #   cp upgrade.yaml ${workDir}/upgrade/trigger-upgrade.yaml
  elif [ $project = "kodo" ]; then
    cp image/upgrade.yaml ${workDir}/upgrade/kodo-upgrade.yaml
  elif [ $project = "dataflux-func" ]; then
    cp upgrade-info.yaml ${workDir}/upgrade/dataflux-func-upgrade.yaml
    cp db/dataflux_func_latest.sql ${workDir}/launcher/resource/v1/ddl/dataflux-func.sql
  elif [ $project = "message-desk" ]; then
    cp upgrade-info.yaml ${workDir}/upgrade/messageDesk-upgrade.yaml
    cp db/message_desk_latest.sql ${workDir}/launcher/resource/v1/ddl/message-desk.sql
  elif [ $project = "front-webclient" ]; then
    cp upgrade.yaml ${workDir}/upgrade/frontWeb-upgrade.yaml
  elif [ $project = "data-warehouse" ]; then
    cp image/upgrade.yaml ${workDir}/upgrade/data-warehouse-upgrade.yaml
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

# (?<="version"\s*:\s*")[\d\w\.\-]+(?=\")
dwVersion=`curl -s https://static.guance.com/dataway/version | grep -Eo "(\d+\.){2}\d+(-rc\d+)?"`

if [ ! -n "$dwVersion" ]; then
  echo '未获取到 DataWay 的最新版本'
  exit 0
else
  echo "DataWay 最新版本号：$dwVersion \n"
fi

dkVersion=`curl -s https://static.guance.com/datakit/version | grep version\" | grep -Eo "(\d+\.){2}\d+(-rc\d+)?"`

if [ ! -n "$dkVersion" ]; then
  echo '未获取到 DataKit 的最新版本'
  exit 0
else
  echo "DataKit 最新版本号：$dkVersion \n"
fi


: > ${imageYaml}
echo "apps:" > ${workDir}/${imageYaml}
echo "  registry: registry.jiagouyun.com" >> ${workDir}/${imageYaml}
echo "  version: testing" >> ${workDir}/${imageYaml}
echo "  image_dir: ''" >> ${workDir}/${imageYaml}
echo "  images:" >> ${workDir}/${imageYaml}
echo "    nsq: basis:multiarch_nsq_1.2.1" >> ${workDir}/${imageYaml}
echo "    nginx: basis:multiarch_nginx_1.13.7" >> ${workDir}/${imageYaml}
echo "    kapacitor: basis/kapacitor:1.5.4" >> ${workDir}/${imageYaml}

# 最新 DataWay 镜像版本
echo "    internal-dataway: dataway/dataway:v${dwVersion}" >> ${workDir}/${imageYaml}
# 最新 DataKit 镜像版本
echo "    datakit: datakit:${dkVersion}" >> ${workDir}/${imageYaml}

rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/cloudcare-forethought-backend.git" "core" "cloudcare-forethought/cloudcare-forethought-backend"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/kodo.git" "kodo" "kodo/kodo"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare/cloudcare-forethought-webclient.git" "front-webclient" "cloudcare-front/cloudcare-forethought-webclient"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare/cloudcare-forethought-webmanage.git" "management-webclient" "cloudcare-front/cloudcare-forethought-webmanage"

rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/zy-docs/dataflux-doc.git"  "dataflux-doc" "cloudcare-front/dataflux-doc"

rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/middlewares/message-desk.git" "message-desk" "middlewares/message-desk"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/middlewares/message-desk-worker.git" "message-desk-worker" "middlewares/message-desk-worker"

# rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/middlewares/ft-data-processor.git" "func" "middlewares/ft-data-processor"
# rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/middlewares/ft-data-processor-worker.git" "func-worker" "middlewares/ft-data-processor-worker"

rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/middlewares/dataflux-func.git"  "dataflux-func" "middlewares/dataflux-func"

# rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/cloudcare-forethought-trigger.git" "trigger" "cloudcare-forethought/cloudcare-forethought-trigger"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/screenhot-server.git" "utils-server" "cloudcare-forethought/utils-server"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/ft-data-warehouse.git" "data-warehouse" "ft-data-warehouse/ft-data-warehouse"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/cloudcare-forethought-setup.git" "launcher" "cloudcare-forethought/cloudcare-forethought-setup"

