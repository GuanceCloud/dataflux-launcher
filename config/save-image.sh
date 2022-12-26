#!/bin/bash

#set -eux

list="$(dirname $0)/docker-image.txt"

version=$(sed -n "1p" ${list} |sed -r  "s/.*([0-9]+\.[0-9]+\.[0-9]+).*/\1/g")

images_arc_amd64=guance-amd64-${version}.tar.gz 

images_arc_arm64=guance-arm64-${version}.tar.gz 


guance_amd64 (){

for i in $(cat ${list}|grep -Ev "^$|#"); do
   docker pull ${i}
done
docker save $(cat ${list} | grep -Ev "^$|#"|tr '\n' ' ') | gzip -c > $(dirname $0)/guance-images-history/${images_arc_amd64} && \
docker rmi  $(cat ${list} | grep -Ev "^$|#"|tr '\n' ' ')
}

guance_arm64 (){

for i in $(cat ${list}|grep -Ev "^$|#"); do
   docker pull --platform=arm64 ${i}
done

docker save $(cat ${list} | grep -Ev "^$|#"|tr '\n' ' ') | gzip -c > $(dirname $0)/guance-images-history/${images_arc_arm64} && \
docker rmi  $(cat ${list} | grep -Ev "^$|#"|tr '\n' ' ')

}

guance_amd64

guance_arm64
