#!/bin/bash

tmpRTMDir=/tmp/rtm
workDir=$(pwd)
imageYaml=config/docker-image.yaml
imageTxt=config/docker-image.txt

imageHubHost=pubrepo.guance.com
imageHubProject=dataflux-prev


# 清空临时工作区
# 危险操作，必须显式指定目录
rm -rf /tmp/rtm

function init(){
  opt=$1

  git fetch --tag
  lastRTM=$(git tag --list | grep -E "\d+\.\d+\.\d+-\w+-\d+-prod" | sort -V | tail -1)

  [[ ${#lastRTM} > 0 ]] && {
    v=(${lastRTM//[\.-]/ })

    releaseCount=$[10#${v[2]} + 1]

    case ${opt} in
      f )
        minorVersion=${v[1]}
        ;;
      m )
        minorVersion=$[10#${v[1]} + 1]
        ;;
    esac

    rtmVersion=${v[0]}.${minorVersion}.${releaseCount} #_$(date +%Y%m%d)
  } || {
    rtmVersion=1.0.1 #_$(date +%Y%m%d)
  }

  lastRTMPrev=$(git tag --list | grep -E "${rtmVersion}\.\d+-\w+-prev" | sort -V | tail -1)

  [[ ${#lastRTMPrev} > 0 ]] && {
    v=(${lastRTMPrev//[\.-]/ })

    prevReleaseCount=$[10#${v[3]} + 1]
  } || {
    prevReleaseCount=1
  }

  VDIR=${rtmVersion}.${prevReleaseCount}
}

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
    cp db/dialtesting_latest.sql ${workDir}/launcher/resource/v1/ddl/dialtesting.sql
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
  [[ ${#lastReleaseTag} == 0 ]] && return
  git checkout $lastReleaseTag

  commitId=$(git log -n 1 --format="%h")

  rtmTag=${rtmVersion}.${prevReleaseCount}-${commitId}-prev

  git tag $rtmTag
  git push --tag

  echo "\033[33m${rtmTag}\033[00m \t\t \033[32m[${project}]\033[00m"
  echo "\n"

  [[ $project != "launcher" ]] && {
    # 复制项目内最新的 upgrade 文件到 launcher 内
    copy_upgrade $project

    echo "    ${project}: ${VDIR}:${project}-${commitId}" >> ${workDir}/${imageYaml}

    echo "${imageHubHost}/${imageHubProject}/${VDIR}:${project}-${commitId}" >> ${workDir}/${imageTxt}
  }
}

function start(){
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

  init $1

  # docker 镜像列表 YAML 文件输出
  : > ${imageYaml}
  echo "apps:" > ${workDir}/${imageYaml}
  echo "  registry: ${imageHubHost}" >> ${workDir}/${imageYaml}
  echo "  image_dir: ${imageHubProject}/" >> ${workDir}/${imageYaml}
  echo "  images:" >> ${workDir}/${imageYaml}
  echo "    nsq: basis:multiarch_nsq_1.2.1" >> ${workDir}/${imageYaml}
  echo "    nginx: basis:multiarch_nginx_1.13.7" >> ${workDir}/${imageYaml}
  # 最新 DataWay 镜像版本
  echo "    internal-dataway: dataway:${dwVersion}" >> ${workDir}/${imageYaml}
  # 最新 DataKit 镜像版本
  echo "    datakit: datakit:${dkVersion}" >> ${workDir}/${imageYaml}

  # docker 镜像列表 txt 文件输出，用于离线镜像打包
  : > ${imageTxt}
  echo "# Guance Cloud Version: ${VDIR}" > ${workDir}/${imageTxt}
  echo "${imageHubHost}/${imageHubProject}/basis:multiarch_nsq_1.2.1" >> ${workDir}/${imageTxt}
  echo "${imageHubHost}/${imageHubProject}/basis:multiarch_nginx_1.13.7" >> ${workDir}/${imageTxt}
  echo "${imageHubHost}/${imageHubProject}/dataway:${dwVersion}" >> ${workDir}/${imageTxt}
  echo "${imageHubHost}/${imageHubProject}/datakit:${dkVersion}" >> ${workDir}/${imageTxt}

  rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/cloudcare-forethought-backend.git" "core"
  rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/kodo.git" "kodo"
  rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare/cloudcare-forethought-webclient.git" "front-webclient"
  rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare/cloudcare-forethought-webmanage.git" "management-webclient"

  rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/zy-docs/dataflux-doc.git"  "dataflux-doc"

  rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/middlewares/message-desk.git" "message-desk"
  rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/middlewares/message-desk-worker.git" "message-desk-worker"

  rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/middlewares/dataflux-func.git"  "dataflux-func"

  rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/screenhot-server.git" "utils-server"
  rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/jfr-parser.git" "jfr-parser"
  rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/pprofparser.git" "pprofparser"

  echo "  version: ${VDIR}" >> ${workDir}/${imageYaml}

  cd $workDir
  git add ${imageYaml}
  git add ${imageTxt}
  git add upgrade/*
  git add launcher/resource/v1/ddl/*
  git add launcher/resource/v1/data/*
  git commit -m 'auto commit: 预览版 release'
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
