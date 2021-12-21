#!/bin/bash

workDir=$(pwd)
allProject="cloudcare-forethought-backend cloudcare-forethought-trigger cloudcare-forethought-webclient cloudcare-forethought-setup cloudcare-forethought-webmanage kodo ft-data-processor ft-data-processor-worker dataflux-func message-desk message-desk-worker screenhot-server ft-data-warehouse"

branch=$1

for project in $allProject
do
  cd $workDir
  cd ../$project

  echo "\n\033[33m${project}\033[00m \033[32m[${branch}]\033[00m:"
  [[ ${#branch} > 0 ]] && {
    git checkout $branch
  }

  branch=$(git rev-parse --abbrev-ref HEAD)
  git pull
  git fetch --tag
  git checkout dev
  echo "=================== Done =========================\n\n"
done

