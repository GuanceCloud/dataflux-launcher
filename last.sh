#!/bin/bash

workDir=$(pwd)
allProject="cloudcare-forethought-backend cloudcare-forethought-trigger cloudcare-forethought-webclient cloudcare-forethought-setup cloudcare-forethought-webmanage kodo ft-data-processor ft-data-processor-worker message-desk message-desk-worker"

for project in $allProject
do
  cd $workDir
  cd ../$project

  branch=$(git rev-parse --abbrev-ref HEAD)
  echo "\033[33m${project}\033[00m \033[32m[${branch}]\033[00m:"
  git pull
  lastReleaseTag=$(git tag --list | grep -E '^release_' | sort -V | tail -1)
  echo "最新 Release：\033[32m[${lastReleaseTag}]\033[00m"
  git checkout dev
  echo "============================================\n"
done

