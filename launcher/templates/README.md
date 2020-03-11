#### Launcher 使用说明

本安装程序是全新安装或升级 DataFlux 应用使用，看到此界面，说明已经配置好了 kubernetes 集群环境。

#### **在开始安装之前，请注意先完成以下几个事项：**

* 已根据部署手册中的资源清单开通了所需的资源，如 **_MySQL、Redis、InfluxDB_** 等基础设施服务
* 已创建 **_MySQL、InfluxDB_** 的管理员账号，必须是管理员账号，因为需要使用管理员账号去初始化数据库
* 将 RDS 的默认参数  **_innodb\_large\_prefix_** 修改为  **_ON_**
* InfluxDB 必须开通 **_VPC 双向访问功能_**

 
#### **!!! 必须注意的事项：**

* 安装完成后，必须将 Launcher 的 Pod 副本数调为0，即停止 Launcher 服务，防止被误访问后破坏集群环境，可执行以下命令：

    ```
    kubectl patch deployment launcher -p '{"spec": {"replicas": 0}}' -n launcher
    ```
