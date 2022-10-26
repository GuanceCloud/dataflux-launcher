# Launcher



## 快速安装

```shell
$ helm repo add launcher https://pubrepo.guance.com/chartrepo/launcher
$ helm install my-launcher launcher/launcher -n launcher --create-namespace  \
  --set ingress.hostName="launcher.my.com",storageClassName=nfs-client
```

## 介绍

此图表使用 [Helm](https://helm.sh) package manager 在[Kubernetes](http://kubernetes.io)集群上引导 [Launcher](https://guance.com/) 部署。


## 先决条件

- Kubernetes 1.12+
- Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## 安装图表

要安装版本名为`my release`的图表，请执行以下操作：:
```shell
$ helm repo add launcher https://pubrepo.guance.com/chartrepo/launcher
$ helm install my-launcher launcher/launcher -n launcher --create-namespace  \
  --set ingress.hostName="launcher.my.com",storageClassName=nfs-client
```

该命令以默认配置在Kubernetes集群上部署Launcher。[参数](#parameters)部分列出了安装期间可以配置的参数。

> **Tip**: 使用列出所有版本 `helm list -n launcher`

## 卸载图表

要卸载或删除 `my-launcher` 部署：

```console
$ helm delete my-launcher -n launcher
```

该命令将删除与图表关联的所有 Kubernetes 组件，并删除版本。

## 参数

下表列出了启动器图表的可配置参数及其默认值。

| Parameter             | Description                           | Default           |
| --------------------- | ------------------------------------- | ----------------- |
| `storageClassName `   | PVC Storage Class                     | `nfs-client`      |
| `persistence.size`    | PVC Storage Request                   | `8Gi`             |
| `image.repository`    | Launcher image name                   | `nil`             |
| `image.tag`           | Launcher image tag                    | `nil`             |
| `image.pullPolicy`    | Image pull policy                     | `IfNotPresent`    |
| `service.type`        | Kubernetes Service type               | `ClusterIP`       |
| `service.port`        | Service HTTP port                     | `5000`            |
| `ingress.enabled`     | Enable ingress controller resource    | `false`           |
| `ingress.hostName`    | Default host for the ingress resource | `launcher.my.com` |
| `ingress.annotations` | Ingress annotations                   | `{}`              |
| `ingress.tls`         | TLS Secret (certificates)             | `nil`             |



使用--set key=value[,key=value]参数指定每个参数以进行 Helm 安装。例如

```console
$ helm install my-launcher dataflux/launcher -n launcher --create-namespace  \
  --set ingress.hostName="launcher.my.com",storageClassName=nfs-client
```

或者，可以在安装图表时提供指定上述参数值的YAML文件。例如

```console
$ helm install my-release -f values.yaml <helm-repo>/Launcher
```

> **Tip**: 可以使用默认值[values.yaml](values.yaml)


