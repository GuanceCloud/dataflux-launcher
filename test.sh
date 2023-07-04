#!/bin/bash

function each_cluster(){
  lastReleaseTag=$(git tag --list | grep -E "^release_" | sort -V | tail -1)
  lastDeployTag=$(git tag --list | grep -E "^deploy_" | sort -V | tail -1)

  splitV=(${lastDeployTag//_/ })
  splitSite=${splitV[2]}

  RANCHER_CLUSTER_IDS="cn1:c-ccv6c cn2:c-m-8vswwwjn us1:c-m-4qftwlmj cn3:c-m-qfznmzwg cn4:c-m-srl9jzf2 cn5:c-m-48cjwlzr"

  for clusterID in $RANCHER_CLUSTER_IDS
  do
    if [[ -z "${split_v[2]}" || "${split_v[2]}" == "all" || "$clusterID" == "${split_v[2]}":* ]]; then

      splitClusterID=(${lastDeployTag//:/ })
      echo ${splitClusterID[1]} $lastReleaseTag
      deploy_cluster ${splitClusterID[1]} $lastReleaseTag
    fi
  done
}

function do_trigger_tag(){
  trigger_site=$1

  git fetch --tag
  lastReleaseTag=$(git tag --list | grep -E "^release_" | sort -V | tail -1)
  lastReleaseTagCommitID=$(git rev-list -n 1 ${lastReleaseTag})
  lastDeployTag=$(git tag --list | grep -E "^deploy_" | sort -V | tail -1)

  [[ ${#lastDeployTag} > 0 ]] && {
    v=(${lastDeployTag//_/ })
    v_main=${v[0]}

    # 当前版本的 tag 已经存在，后续版本数字递增1
    deployCount=$[10#${lastDeployTag:${#v_main} + 1:5} + 100001]
    deployCount=${deployCount:1:5}

    echo $deployCount

    if [[ -z "$trigger_site" || "$trigger_site" == "all" ]]; then
      newDeployTag=${v_main}_${deployCount}
    else 
      newDeployTag=${v_main}_${deployCount}_${trigger_site}
    fi

  } || {
    newDeployTag=deploy_00001
  }

  echo $newDeployTag

  # 在最新的 release tag 处打上 deploy tag，触发 CD 动作
  git tag -a $newDeployTag -m 'deploy trigger ${newDeployTag}' $lastReleaseTagCommitID
  git push --tags
}

while getopts ":t:d:" opt; do
    case $opt in
        t)
            echo "add a tag to deploy trigger"
            param_t="$OPTARG"

            do_trigger_tag $param_t
            ;;
        d)
            echo "do deploy"
            each_cluster
            ;;
        ?)
            echo "-t: add a tag to deploy trigger"
            exit 1
            ;;
    esac
done

