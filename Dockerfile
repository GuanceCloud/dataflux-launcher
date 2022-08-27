FROM python:3.6.8
FROM registry.jiagouyun.com/basis/launcher-basis:v1.0

MAINTAINER "lhm@jiagouyun.com"

WORKDIR /config/cloudcare-forethought-setup
ADD . /config/cloudcare-forethought-setup/

# 危险脚本，移到项目目录之外
RUN mkdir /config/tools
RUN mv /config/cloudcare-forethought-setup/k8s-clear.sh /config/tools
