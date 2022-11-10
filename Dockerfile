FROM registry.jiagouyun.com/basis/launcher-basis:v1.0

MAINTAINER "lhm@guance.com"

WORKDIR /config/cloudcare-forethought-setup
ADD . /config/cloudcare-forethought-setup/

# 危险脚本，移到项目目录之外
RUN mkdir /config/tools
RUN mv /config/cloudcare-forethought-setup/k8s-clear.sh /config/tools
RUN rm *.sh && rm -r .git*
