FROM python:3.6.8

MAINTAINER "lhm@jiagouyun.com"

# 设置系统时区
RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone

# 替换镜像源
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    sed -i 's/ports.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    apt-get update

# 安装 kubectl 工具
RUN apt-get install -y apt-transport-https
RUN curl http://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add - 
RUN echo "deb http://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update && apt-get install -y kubectl && apt-get install -y mysql-client && apt-get install -y telnet && apt-get install -y unzip

RUN \
    dpkgArch="$(dpkg --print-architecture)"; \
    awscliv2Url=""; \
    \
    case "$dpkgArch" in \
        arm64) \
            awscliv2Url="https://static.guance.com/launcher/awscli-exe-linux-aarch64.zip"; \
            ;; \
        amd64) \
            awscliv2Url="https://static.guance.com/launcher/awscli-exe-linux-x86_64.zip"; \
            ;; \
    esac; \
    \
    curl "$awscliv2Url" -o "awscliv2.zip"; \
    unzip awscliv2.zip; \
    ./aws/install; \
    \
    rm -rf ./aws; \
    rm awscliv2.zip;

WORKDIR /config/cloudcare-forethought-setup
ADD ./requirements.txt /config/cloudcare-forethought-setup/
RUN pip install -i https://mirrors.aliyun.com/pypi/simple/ --upgrade pip && \
    pip install -i https://mirrors.aliyun.com/pypi/simple/ -r /config/cloudcare-forethought-setup/requirements.txt

ADD . /config/cloudcare-forethought-setup/

# 危险脚本，移到项目目录之外
RUN mkdir /config/tools
RUN mv /config/cloudcare-forethought-setup/k8s-clear.sh /config/tools
