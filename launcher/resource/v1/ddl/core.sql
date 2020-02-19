CREATE TABLE `biz_chart` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 chrt- 前缀',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '命名',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `chartGroupUUID` varchar(65) NOT NULL DEFAULT '' COMMENT '图表分组UUID',
  `dashboardUUID` varchar(65) NOT NULL DEFAULT '' COMMENT '所属视图UUID',
  `type` varchar(48) NOT NULL COMMENT '图表线条类型',
  `extend` json NOT NULL COMMENT '额外拓展字段',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `biz_chart_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID chtg-',
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT '命名,用云备注',
  `dashboardUUID` varchar(65) NOT NULL DEFAULT '视图UUID',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `status` int(11) NOT NULL DEFAULT '0',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `cgroup_worspace_fk` (`workspaceUUID`),
  KEY `k_dashboardUUID` (`dashboardUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `biz_dashboard` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 dsbd-前缀',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `name` varchar(128) NOT NULL COMMENT '视图名字',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `chartPos` json NOT NULL COMMENT 'charts 位置信息[{chartUUID:xxx,pos:xxx}]',
  `chartGroupPos` json NOT NULL COMMENT 'chartGroup 位置信息[chartGroupUUIDs]',
  `type` varchar(48) NOT NULL DEFAULT 'CUSTOM' COMMENT '视图类型：仪表板视图',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `biz_integration` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID, rul-',
  `type` varchar(48) NOT NULL DEFAULT '' COMMENT '类型',
  `path` varchar(512) DEFAULT NULL,
  `name` varchar(128) DEFAULT '' COMMENT '名称',
  `metaHash` varchar(256) DEFAULT NULL COMMENT 'meta hash值',
  `meta` json DEFAULT NULL COMMENT '数据集meta信息',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `biz_node` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 node- 前缀',
  `name` varchar(128) NOT NULL COMMENT '命名',
  `measurementLimit` json DEFAULT NULL COMMENT '指标集限制',
  `filter` json DEFAULT NULL COMMENT '过滤条件',
  `subTagKeys` json NOT NULL COMMENT '子节点 tag 键值',
  `bindTagValues` json NOT NULL COMMENT '绑定虚拟节点值',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `sceneUUID` varchar(48) NOT NULL COMMENT '场景 uuid',
  `parentUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '父节点 uuid',
  `templateUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '系统模板 uuid',
  `dashboardUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '视图 uuid',
  `subTemplateUUID` varchar(48) NOT NULL DEFAULT '',
  `subDashboardUUID` varchar(48) NOT NULL DEFAULT '',
  `exclude` json NOT NULL COMMENT '排除项',
  `bindInfo` json NOT NULL COMMENT '节点绑定信息',
  `path` json NOT NULL COMMENT '路径列表',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `scene_node_fk` (`sceneUUID`),
  KEY `node_dashboard_fk` (`dashboardUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `biz_query` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID qry- 前缀',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '命名',
  `metric` varchar(256) NOT NULL DEFAULT '' COMMENT 'metric 名称',
  `query` json DEFAULT NULL COMMENT '查询条件, sql 或 json body',
  `qtype` enum('HTTP','TSQL','SQL') NOT NULL COMMENT '查询类型',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `color` varchar(32) NOT NULL DEFAULT '' COMMENT '折线颜色代码',
  `unit` varchar(32) NOT NULL DEFAULT '' COMMENT '数据单位',
  `datasource` varchar(48) DEFAULT NULL COMMENT '数据源类型',
  `chartUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '关联的图表UUID',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `extend` json DEFAULT NULL COMMENT '额外扩展字段',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_chart_uuid` (`chartUUID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `biz_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID, rul-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `type` enum('trigger','baseline') NOT NULL DEFAULT 'trigger',
  `kapaUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '所属Kapa的UUID',
  `jsonScript` json DEFAULT NULL COMMENT 'script的JSON数据',
  `tickInfo` json DEFAULT NULL COMMENT '提交后Kapa 返回的Tasks数据',
  `extend` json DEFAULT NULL COMMENT '额外配置数据',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `biz_scene` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 scene-',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '场景名称',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `describe` text NOT NULL COMMENT '场景的描述信息',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `biz_variable` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID,varl-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `dashboardUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '视图全局唯一 ID',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '变量显示名',
  `code` varchar(128) NOT NULL DEFAULT '' COMMENT '变量名',
  `type` enum('QUERY','CUSTOM_LIST','ALIYUN_INSTANCE') NOT NULL COMMENT '类型',
  `datasource` varchar(48) NOT NULL COMMENT '数据源类型',
  `definition` json DEFAULT NULL COMMENT '解说，原content内容',
  `content` json DEFAULT NULL COMMENT '变量配置数据',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `main_accesskey` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT 'ak 唯一标识',
  `ak` varchar(32) NOT NULL DEFAULT '' COMMENT 'Access Key',
  `sk` varchar(128) NOT NULL DEFAULT '' COMMENT 'Secret Key',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: 新建/1: 运行/2: 故障/3: 停用/4: 删除',
  `createAt` int(11) NOT NULL DEFAULT '-1' COMMENT '创建时间',
  `updateAt` int(11) NOT NULL DEFAULT '-1' COMMENT '更新时间 ',
  `deleteAt` int(11) NOT NULL DEFAULT '-1' COMMENT '删除时间',
  PRIMARY KEY (`id`) COMMENT 'sk 可以存在相同的情况',
  UNIQUE KEY `uk_ak` (`ak`) COMMENT 'AK 做成全局唯一',
  KEY `idx_ak` (`ak`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `main_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT 'account 唯一标识 acnt-前缀',
  `name` varchar(256) DEFAULT '',
  `username` varchar(256) DEFAULT '',
  `password` varchar(128) NOT NULL DEFAULT '' COMMENT '帐户密码',
  `email` varchar(256) DEFAULT '',
  `mobile` varchar(128) NOT NULL DEFAULT '' COMMENT '手机号',
  `exterId` varchar(128) NOT NULL DEFAULT '' COMMENT '外部ID',
  `extend` json DEFAULT NULL COMMENT '额外信息',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `createAt` int(11) NOT NULL DEFAULT '-1' COMMENT '创建时间',
  `updateAt` int(11) NOT NULL DEFAULT '-1' COMMENT '更新时间 ',
  `deleteAt` int(11) NOT NULL DEFAULT '-1' COMMENT '删除时间',
  PRIMARY KEY (`id`) COMMENT 'sk 可以存在相同的情况',
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT '全局唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `main_account_privilege` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 acpv- 前缀',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间唯一UUID',
  `accountUUID` varchar(48) NOT NULL COMMENT '账号Uuid',
  `entityType` varchar(48) NOT NULL COMMENT '实体类型',
  `entityUUID` varchar(48) NOT NULL COMMENT '实体Uuid',
  `privilegeJson` json NOT NULL COMMENT '权限配置',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `accountUUID_fk` (`accountUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `main_account_workspace` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 rlaw-前缀',
  `accountUUID` varchar(48) NOT NULL COMMENT '帐户唯一ID',
  `workspaceUUID` varchar(64) NOT NULL COMMENT '工作空间 uuid',
  `dashboardUUID` varchar(48) DEFAULT NULL COMMENT '视图UUID-与用户绑定',
  `isAdmin` int(1) NOT NULL DEFAULT '0' COMMENT '是否为管理员',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `accountUUID_fk` (`accountUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `main_agent` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT 'ftagent的uuid,唯一id 待 agnt-前缀',
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT 'agent 名称',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `version` varchar(32) NOT NULL DEFAULT '""' COMMENT '当前版本号',
  `host` varchar(64) NOT NULL DEFAULT '""' COMMENT '主机IP, 默认为出口 IP',
  `port` int(11) NOT NULL DEFAULT '0',
  `domainName` varchar(128) NOT NULL DEFAULT ' ' COMMENT 'agent域名',
  `workspaceUUID` varchar(65) NOT NULL DEFAULT '-1' COMMENT '关联的工作空间uuid',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `updator` varchar(64) NOT NULL DEFAULT '',
  `createAt` int(11) NOT NULL DEFAULT '-1' COMMENT '创建时间',
  `uploadAt` int(11) NOT NULL DEFAULT '-1' COMMENT '最后上传时间',
  `deleteAt` int(11) NOT NULL DEFAULT '-1' COMMENT '删除时间',
  `updateAt` int(11) NOT NULL DEFAULT '-1' COMMENT '最后更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk` (`uuid`),
  KEY `idx_ws_uuid` (`workspaceUUID`),
  KEY `idx_uuid` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `main_agent_license` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT 'ak 唯一标识 wsak-',
  `workspaceUUID` varchar(64) NOT NULL DEFAULT '' COMMENT '工作空间 uuid',
  `agentUUID` varchar(64) NOT NULL DEFAULT '' COMMENT 'agent 的 uuid',
  `license` varchar(128) NOT NULL DEFAULT '' COMMENT 'licenese 信息',
  `type` enum('FREE','PAID') NOT NULL DEFAULT 'FREE' COMMENT '付费类型',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: 正常/2: 禁用/3: 删除',
  `createAt` int(11) NOT NULL DEFAULT '-1' COMMENT '创建时间',
  `updateAt` int(11) NOT NULL DEFAULT '-1' COMMENT '更新时间 ',
  `deleteAt` int(11) NOT NULL DEFAULT '-1' COMMENT '删除时间',
  PRIMARY KEY (`id`) COMMENT 'sk 可以存在相同的情况',
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `main_influx_db` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 ifdb-',
  `db` varchar(48) NOT NULL DEFAULT '' COMMENT 'DB 名称',
  `influxInstanceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT 'instance的UUID',
  `influxRpUUID` varchar(48) NOT NULL DEFAULT '' COMMENT 'influx rp uuid',
  `influxRpName` varchar(48) NOT NULL DEFAULT '' COMMENT 'influx dbrp name',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `db_isuuid` (`influxInstanceUUID`),
  KEY `db_rpuuid` (`influxRpUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `main_influx_instance` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 iflx-',
  `host` varchar(128) NOT NULL COMMENT '源的配置信息',
  `authorization` json NOT NULL COMMENT 'influx 登陆信息',
  `dbcount` int(11) NOT NULL DEFAULT '0' COMMENT '当前实例的DB总数量',
  `user` varchar(64) NOT NULL DEFAULT '',
  `pwd` varchar(64) NOT NULL DEFAULT '',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `main_influx_rp` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀ifrp-',
  `name` varchar(48) NOT NULL DEFAULT '' COMMENT 'rp名称',
  `duration` varchar(48) NOT NULL DEFAULT '0' COMMENT 'InfluxDB保留数据的时间，此处单位为小时(h)',
  `shardGroupDuration` varchar(48) NOT NULL DEFAULT '0' COMMENT 'optional, 此处单位为小时(h)',
  `replication` int(11) NOT NULL DEFAULT '1' COMMENT '每个点的多少独立副本存储在集群中，其中n是数据节点的数量。该子句不能用于单节点实例',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `main_inner_app` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，关联用，带 inap- 前缀',
  `akUUID` varchar(64) NOT NULL COMMENT 'ak uuid',
  `version` varchar(64) NOT NULL COMMENT '版本号',
  `domain` varchar(64) NOT NULL COMMENT '域名',
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT '名称',
  `type` varchar(64) NOT NULL DEFAULT '' COMMENT '应用类型',
  `code` varchar(64) NOT NULL DEFAULT '' COMMENT '应用唯一code',
  `webhookCfg` json NOT NULL COMMENT '回调地址配置',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `main_kapa` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 kapa-',
  `host` varchar(128) NOT NULL COMMENT 'kapa 地址',
  `influxInstanceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT 'source实例uuid',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `main_manage_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT 'account 唯一标识 mact-',
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT '昵称',
  `username` varchar(128) NOT NULL DEFAULT '' COMMENT '账户名',
  `password` varchar(128) NOT NULL DEFAULT '' COMMENT '帐户密码',
  `email` varchar(64) NOT NULL DEFAULT '' COMMENT '邮箱',
  `mobile` varchar(128) NOT NULL DEFAULT '' COMMENT '手机号',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `createAt` int(11) NOT NULL DEFAULT '-1' COMMENT '创建时间',
  `updateAt` int(11) NOT NULL DEFAULT '-1' COMMENT '更新时间 ',
  `deleteAt` int(11) NOT NULL DEFAULT '-1' COMMENT '删除时间',
  PRIMARY KEY (`id`) COMMENT 'sk 可以存在相同的情况',
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT '全局唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `main_subscription` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 sbsp-',
  `dbUUID` varchar(48) NOT NULL DEFAULT '' COMMENT 'DB uuid',
  `rpName` varchar(48) NOT NULL,
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT '订阅名称',
  `kapaUUID` varchar(48) NOT NULL DEFAULT '' COMMENT 'kapa的UUID',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `db_isuuid` (`dbUUID`),
  KEY `kapa_uuid` (`kapaUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `main_workspace` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 wksp-',
  `name` varchar(128) NOT NULL COMMENT '命名',
  `token` varchar(64) DEFAULT '""' COMMENT '采集数据token',
  `dbUUID` varchar(48) NOT NULL COMMENT 'influx_db uuid对应influx实例的DB名',
  `dataRestriction` json DEFAULT NULL COMMENT '数据权限',
  `dashboardUUID` varchar(48) DEFAULT NULL COMMENT '工作空间概览-视图UUID',
  `exterId` varchar(128) NOT NULL DEFAULT '' COMMENT '外部ID',
  `desc` varchar(500) DEFAULT '""',
  `bindInfo` json NOT NULL COMMENT '绑定到当前工作空间的信息',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `enablePublicDataway` int(1) NOT NULL DEFAULT '1' COMMENT '允许公网Dataway上传数据',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `main_workspace_accesskey` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT 'ak 唯一标识 wsak-',
  `ak` varchar(32) NOT NULL DEFAULT '' COMMENT 'Access Key',
  `sk` varchar(128) NOT NULL DEFAULT '' COMMENT 'Secret Key',
  `workspaceUUID` varchar(64) NOT NULL DEFAULT '' COMMENT '工作空间 uuid',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: 正常/2: 禁用/3: 删除',
  `createAt` int(11) NOT NULL DEFAULT '-1' COMMENT '创建时间',
  `updateAt` int(11) NOT NULL DEFAULT '-1' COMMENT '更新时间 ',
  `deleteAt` int(11) NOT NULL DEFAULT '-1' COMMENT '删除时间',
  PRIMARY KEY (`id`) COMMENT 'sk 可以存在相同的情况',
  UNIQUE KEY `uk_ak` (`ak`) COMMENT 'AK 做成全局唯一',
  KEY `idx_ak` (`ak`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `biz_template` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID tpl-',
  `owner` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID/SYS',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '命名',
  `content` json NOT NULL COMMENT '模版内容',
  `extend` json DEFAULT NULL COMMENT '额外扩展字段',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `template_owner_fk` (`owner`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `biz_share_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 scene-',
  `shareCode` varchar(48) NOT NULL COMMENT '分享码',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `expirationAt` int(11) NOT NULL DEFAULT '0' COMMENT '发布的过期时间',
  `extractionCode` varchar(48) NOT NULL DEFAULT '' COMMENT '访问资源所需的提取码',
  `resourceType` varchar(32) NOT NULL DEFAULT '' COMMENT '资源类型',
  `resourceUUID` varchar(128) NOT NULL DEFAULT '' COMMENT '资源唯一标示UUID',
  `meta` json NOT NULL COMMENT '资源的元数据信息',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_share_code` (`shareCode`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_version` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `project` varchar(64) NOT NULL DEFAULT '' COMMENT '项目：core、kodo、func、messageDesk',
  `version` varchar(64) NOT NULL DEFAULT '' COMMENT '大版本号',
  `seqType` varchar(64) NOT NULL DEFAULT '' COMMENT 'config 、 database',
  `upgradeSeq` int(11) NOT NULL DEFAULT '0' COMMENT '配置或数据库当前的 seq 号',
  `createAt` int(11) DEFAULT '-1',
  `updateAt` int(11) DEFAULT '-1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
