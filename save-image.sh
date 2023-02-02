#!/bin/bash

set +eux

do_trigger_tag(){
  #lastReleaseTag=$(git fetch --tag && git tag --list | grep -E "^release_" | sort -V | tail -1)
  lastReleaseTag=$(git fetch --tag && git tag --list |awk '/release/{print $NF}'|sort -V|sed -n '$p')
  lastReleaseTagCommitID=$(git rev-list -n 1 ${lastReleaseTag})
  lastDeployTag=$(git tag --list | awk  '/upload_oss_/{print $NF}' | sort -V | awk 'END {print}')

  [[ ${#lastDeployTag} > 0 ]] && {
    v=(${lastDeployTag//_/ })
    v_main=${v[0]}_${v[1]}

    # 当前版本的 tag 已经存在，后续版本数字递增1
    #deployCount=$[10#${lastDeployTag:${#v_main} + 1:5} + 100001]
    deployCount=$[10#${lastDeployTag:11 + 1:5 } + 100001]
    echo $deployCount
    deployCount=${deployCount:1:5}
    echo $deployCount

    newDeployTag=${v_main}_${deployCount}
  } || {
    newDeployTag=upload_oss_00001
  }

  # 在最新的 release tag 处打上 deploy tag，触发 CD 动作
  git tag -a $newDeployTag -m 'upload_oss trigger ${newDeployTag}' $lastReleaseTagCommitID
  git push --tags 
}



guance_package (){
	arc_name=$1
	#lastVer=$(git fetch --tag && git tag --list | grep -E "\d+\.\d+\.\d+-\w+-\d+" | sort -V|awk 'END {print }'|awk -F "-" '{print $1"-"$2"-"$3}')
	lastVer=$(git fetch --tag && git tag --list | grep -E "\d+\.\d+\.\d+-\w+-\d+" | sort -V|awk 'END {print }')
	v=(${lastVer//[-]/ })
	temp_dest="/tmp/guance-images-release"
	launVer="pubrepo.guance.com/dataflux/${v[0]}:launcher-${v[1]}-${v[2]}"
	list="$(dirname $0)/config/docker-image.txt"
	version=$(sed -n "1p" ${list} |sed -r  "s/.*([0-9]+\.[0-9]+\.[0-9]+).*/\1/g")


	if ! grep  -w ${launVer} ${list} 
	then
	  echo ${launVer} >>${list}
	fi

	if [ ! -d "${temp_dest}" ]; then
	  mkdir -p ${temp_dest}
	fi

	for i in $(cat ${list}|grep -Ev "^$|#"); do
	   docker pull --platform=${arc_name} ${i}
	done

	docker save $(cat ${list} | grep -Ev "^$|#"|tr '\n' ' ') | gzip -c > ${temp_dest}/guance-${arc_name}-${version}.tar.gz && \
	docker rmi -f   $(cat ${list} | grep -Ev "^$|#"|tr '\n' ' ')
}

push_packages_oss (){
	  tools/ossutil64 cp  /tmp/guance-images-release  oss://${GUANCE_LAUNCHER_OSS_BUCKET}/${GUANCE_LAUNCHER_OSS_PATH} -e ${GUANCE_LAUNCHER_OSS_ENDPOINT} -r -f -u --only-current-dir  -i ${GUANCE_LAUNCHER_OSS_AK_ID} -k ${GUANCE_LAUNCHER_OSS_AK_SECRET} && \
          rm -rf ${temp_dest} 

	  tools/ossutil64 cp   oss://${GUANCE_LAUNCHER_OSS_BUCKET}/${GUANCE_LAUNCHER_OSS_PATH}/guance-amd64-${version}.tar.gz oss://${GUANCE_LAUNCHER_OSS_BUCKET}/${GUANCE_LAUNCHER_OSS_PATH}/guance-amd64-latest.tar.gz -e ${GUANCE_LAUNCHER_OSS_ENDPOINT}  -f -u  -i ${GUANCE_LAUNCHER_OSS_AK_ID} -k ${GUANCE_LAUNCHER_OSS_AK_SECRET} 

	  tools/ossutil64 cp   oss://${GUANCE_LAUNCHER_OSS_BUCKET}/${GUANCE_LAUNCHER_OSS_PATH}/guance-arm64-${version}.tar.gz oss://${GUANCE_LAUNCHER_OSS_BUCKET}/${GUANCE_LAUNCHER_OSS_PATH}/guance-arm64-latest.tar.gz -e ${GUANCE_LAUNCHER_OSS_ENDPOINT}  -f -u  -i ${GUANCE_LAUNCHER_OSS_AK_ID} -k ${GUANCE_LAUNCHER_OSS_AK_SECRET}
}

while getopts ":tp" opt
do
    case $opt in
        t)
            echo "add a tag to deploy trigger"
            do_trigger_tag
            ;;
        p)
            echo "do packages"
            guance_package arm64
            #guance_package amd64
	    push_packages_oss 
            ;;
        ?)
            echo "-t: add a tag to deploy trigger"
            exit 1
            ;;
    esac
done

