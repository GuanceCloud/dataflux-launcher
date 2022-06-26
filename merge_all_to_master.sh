#!/bin/bash

workDir=$(pwd)
allProject="cloudcare-forethought-backend cloudcare-forethought-webclient cloudcare-forethought-setup cloudcare-forethought-webmanage kodo dataflux-func dataflux-doc message-desk message-desk-worker screenhot-server"
# allProject="cloudcare-forethought-setup"

function merge_to_master(){
  project=$1
  cd $workDir
  cd ../$project

  echo "\n\033[33m${project}\033[00m pull:"

  git pull
  git fetch --tag
  lastReleaseTag=$(git tag --list | grep -E "^release_" | sort -V | tail -1)

  [[ ${#lastReleaseTag} > 0 ]] && {
    echo "\033[33m${project}\033[00m \033[32m[${lastReleaseTag}]\033[00m merge to \033[32m[master]\033[00m:"

    git checkout master
    git pull
    git merge $lastReleaseTag
    git push origin master

    git checkout dev

    echo "================== Done ==========================\n\n"
  }
}

for project in $allProject
do
  merge_to_master $project
done
