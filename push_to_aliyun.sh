#!/bin/bash

tmpRTMDir=/tmp/rtm
rm -rf /tmp/rtm

[[ ! -d "$tmpRTMDir" ]] && mkdir $tmpRTMDir
cd $tmpRTMDir

allProject="core trigger front-webclient launcher management-webclient kodo func func-worker message-desk message-desk-worker utils-server "
allAliRepo="zhuyun-forethought-backend zhuyun-forethought-trigger zhuyun-forethought-webclient zhuyun-forethought-launcher zhuyun-forethought-webmanage zhuyun-forethought-kodo zhuyun-forethought-data-processor zhuyun-forethought-data-processor-worker zhuyun-forethought-message-desk zhuyun-forethought-message-desk-worker zhuyun-forethought-utils-server"
allLocalRepo="cloudcare-tools/cloudcare-forethought-backend cloudcare-tools/cloudcare-forethought-trigger cloudcare/cloudcare-forethought-webclient cloudcare-tools/cloudcare-forethought-setup cloudcare/cloudcare-forethought-webmanage cloudcare-tools/kodo middlewares/ft-data-processor middlewares/ft-data-processor-worker middlewares/message-desk middlewares/message-desk-worker cloudcare-tools/screenhot-server"

# allProject="xinxuan"
# allAliRepo="zhuyun-forethought-xinxuan"
# allLocalRepo="cloudcare-tools/forethought-xinxuan"

allProject=($allProject)
allAliRepo=($allAliRepo)
allLocalRepo=($allLocalRepo)

function push_to_aliyun(){
  project=$1
  aliRepo=$2
  localRepo=$3

  localGitUrl="ssh://git@gitlab.jiagouyun.com:40022/${localRepo}.git"
  aliGitUrl="git@code.aliyun.com:dataflux_xinxuan/${aliRepo}.git"

  git clone $localGitUrl ${tmpRTMDir}/$project
  cd ${tmpRTMDir}/$project
  git fetch --tag
  git checkout master

  lastRTMVersion=$(git tag --list | grep -E "\d+\.\d+\.\d+-\w+-\d+-prod" | sort -V | tail -1)
  arrV=(${lastRTMVersion//[-]/ })
  mainVersion=${arrV[0]}

  header=Content-Type:application/json\;X-XinXuan-Auth-Token:tbfCkUr8kv2AnY23Fay5EjMouJt3TobIaqLI
  data={\"project\":\"${project}\",\"version\":\"${mainVersion}\",\"subVersion\":\"${lastRTMVersion}\"}

  # 提交版本信息到服务端
  curl https://xinxuan.dataflux.cn/api/v1/version/add -X POST -H $header -d $data

  git remote add aliyun ${aliGitUrl}
  git push aliyun master
}

for i in $(seq 0 10)
do
  project=${allProject[i]}
  aliRepo=${allAliRepo[i]}
  localRepo=${allLocalRepo[i]}

  push_to_aliyun $project $aliRepo $localRepo
done

