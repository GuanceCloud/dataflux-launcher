#!/bin/bash

tmpRTMDir=/tmp/rtm
workDir=$(pwd)
imageYaml=config/docker-image.yaml

lastRTM=$(git tag --list | grep -E "^rtm_" | sort -V | tail -1)

[[ ${#lastRTM} > 0 ]] && {
  v=(${lastRTM//_/ })

  releaseCount=$[10#${v[4]} + 1001]
  releaseCount=${releaseCount:1:3}

  version=${v[3]}_${releaseCount}_$(date +%Y%m%d)
} || {
  version=1_001_$(date +%Y%m%d)
}

VDIR=v${version//_/.}

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

  rtmTag=${lastReleaseTag//release_/rtm_}_${version}

  git tag $rtmTag
  git push --tag

  echo "${rtmTag}\t\t${project}"

  [[ $project != "setup" ]] && {
    echo "    ${project}: ${project}:${rtmTag//_/-}" >> ${workDir}/${imageYaml}
  }
}

: > ${imageYaml}
echo "apps:" > ${workDir}/${imageYaml}
echo "  registry: pubrepo.jiagouyun.com" >> ${workDir}/${imageYaml}
echo "  image_dir: dataflux/${VDIR}" >> ${workDir}/${imageYaml}
echo "  images:" >> ${workDir}/${imageYaml}

rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/cloudcare-forethought-backend.git" "core"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/kodo.git" "kodo"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare/cloudcare-forethought-webclient.git" "front-webclient"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare/cloudcare-forethought-webmanage.git" "management-webclient"

rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/middlewares/message-desk.git" "message-desk"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/middlewares/message-desk-worker.git" "message-desk-worker"

rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/middlewares/ft-data-processor.git" "func"
rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/middlewares/ft-data-processor-worker.git" "func-worker"

rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/cloudcare-forethought-trigger.git" "trigger"

cd $workDir
git add ${imageYaml}
git commit -m 'auto commit: RTM release'
git push

sh release.sh -r

rtm_tag "ssh://git@gitlab.jiagouyun.com:40022/cloudcare-tools/cloudcare-forethought-setup.git" "setup"
