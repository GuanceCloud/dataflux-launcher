FROM registry.jiagouyun.com/basis/dataflux-root-ubuntu-20.04:v1.0

MAINTAINER "lhm@guance.com"

# 设置系统时区
RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone

# 替换镜像源
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    sed -i 's/ports.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    apt-get update

# 安装 kubectl 工具
RUN apt-get install -y apt-transport-https gnupg2
RUN curl http://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add - 
RUN echo "deb http://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update && apt-get install -y kubectl && apt-get install -y mysql-client

# 安装必要工具、Python 3.8
RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
            python3.8-dev python3-pip default-libmysqlclient-dev build-essential libpq-dev libaio1 && \
            update-alternatives --install /usr/bin/python python /usr/bin/python3.8 100

# RUN \
#     dpkgArch="$(dpkg --print-architecture)"; \
#     awscliv2Url=""; \
#     \
#     case "$dpkgArch" in \
#         arm64) \
#             awscliv2Url="https://static.guance.com/launcher/awscli-exe-linux-aarch64.zip"; \
#             ;; \
#         amd64) \
#             awscliv2Url="https://static.guance.com/launcher/awscli-exe-linux-x86_64.zip"; \
#             ;; \
#     esac; \
#     \
#     curl "$awscliv2Url" -o "awscliv2.zip"; \
#     unzip awscliv2.zip; \
#     ./aws/install; \
#     \
#     rm -rf ./aws; \
#     rm awscliv2.zip;

WORKDIR /config/cloudcare-forethought-setup
ADD ./requirements.txt /config/cloudcare-forethought-setup/

RUN pip install -i https://mirrors.aliyun.com/pypi/simple/ --upgrade pip && \
    pip install -i https://mirrors.aliyun.com/pypi/simple/ -r /config/cloudcare-forethought-setup/requirements.txt

