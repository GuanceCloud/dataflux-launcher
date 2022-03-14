# Launcher

[Launcher](https://guance.com/) 是安装可观测软件的安装器

## TL;DR;

```console
$ helm repo add dataflux https://pubrepo.jiagouyun.com/chartrepo/dataflux-chart
$ helm install my-launcher dataflux/launcher -n launcher --create-namespace  \
        --set-file configyaml="/Users/buleleaf/.kube/config" \
  --set ingress.hostname="launcher2.tke.com",storageClassName=nfs-client
```

## 介绍

此图表使用[Helm](https://helm.sh) package manager在[Kubernetes](http://kubernetes.io)集群上引导[Launcher](https://guance.com/)部署。


## 先决条件

- Kubernetes 1.12+
- Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## 安装图表

要安装版本名为`my release`的图表，请执行以下操作：:
```console
$ helm repo add dataflux https://pubrepo.jiagouyun.com/chartrepo/dataflux-chart
$ helm install my-launcher dataflux/launcher -n launcher --create-namespace  \
        --set-file configyaml="/Users/buleleaf/.kube/config" \
  --set ingress.hostname="launcher.my.com",storageClassName=nfs-client
```

该命令以默认配置在Kubernetes集群上部署Launcher。[参数](#parameters)部分列出了安装期间可以配置的参数。

> **Tip**: 使用列出所有版本 `helm list -n launcher`

## 卸载图表

To uninstall/delete the `my-launcher` deployment:

```console
$ helm delete my-launcher -n launcher
```

该命令将删除与图表关联的所有Kubernetes组件，并删除版本。

## 参数

下表列出了启动器图表的可配置参数及其默认值。

| Parameter                   | Description                            | Default             |
| --------------------------- | -------------------------------------- | ------------------- |
| `storageClassName `         | PVC Storage Class                      | nfs-client          |
| `persistence.size`          | PVC Storage Request                    | 8Gi                 |
| `image.repository`          | Launcher image name                    | `nil`               |
| `image.tag`                 | Launcher image tag                     | `nil`               |
| `image.pullPolicy`          | Image pull policy                      | `IfNotPresent`      |
| `service.type`              | Kubernetes Service type                | `ClusterIP`         |
| `service.port`              | Service HTTP port                      | `5000`              |
| `ingress.enabled`           | Enable ingress controller resource     | `false`             |
| `ingress.hostname`          | Default host for the ingress resource  | `launcher2.tke.com` |
| `ingress.annotations`       | Ingress annotations                    | `{}`                |
| `ingress.hosts[0].name`     | Hostname to your Launcher installation | `launcher2.tke.com` |
| `ingress.hosts[0].path`     | Path within the url structure          | `/`                 |
| `ingress.tls[0].hosts[0]`   | TLS hosts                              | `nil`               |
| `ingress.tls[0].secretName` | TLS Secret (certificates)              | `nil`               |



使用--set key=value[,key=value]参数指定每个参数以进行helm安装。例如

```console
$ helm install my-launcher dataflux/launcher -n launcher --create-namespace  \
        --set-file configyaml="/Users/buleleaf/.kube/config" \
  --set ingress.hostname="launcher.my.com",storageClassName=nfs-client
```

或者，可以在安装图表时提供指定上述参数值的YAML文件。例如

```console
$ helm install my-release -f values.yaml <helm-repo>/Launcher
```

> **Tip**: 可以使用默认值[values.yaml](values.yaml)


### 配置 config.yaml 
使用launcher Yaml content安装dataflux时必须更换
```console
$ helm pull dataflux/launcher --tar
$ cd launcher
$ cat ~/.kube/config > config.yaml
$ helm install my-launcher dataflux/launcher -n launcher --create-namespace
```

或者使用`--set-file` 命令指定路径

```
$ helm install my-launcher dataflux/launcher -n launcher --create-namespace  \
        --set-file configyaml="/Users/buleleaf/.kube/config" 
```

