# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.32)
# Database: ft-new
# Generation Time: 2021-12-30 03:49:11 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table biz_account_device
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_account_device`;

CREATE TABLE `biz_account_device` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `accountId` varchar(64) NOT NULL DEFAULT '' COMMENT 'account id',
  `deviceId` varchar(256) NOT NULL DEFAULT '' COMMENT '登录设备ID',
  `deviceVersion` varchar(256) NOT NULL DEFAULT '' COMMENT '登录设备版本',
  `deviceOS` varchar(256) NOT NULL DEFAULT '' COMMENT '登录设备系统',
  `deviceOSVersion` varchar(256) NOT NULL DEFAULT '' COMMENT '登录设备系统系统版本',
  `registrationId` varchar(48) NOT NULL DEFAULT '' COMMENT '推送系统内的ID',
  `loginTime` int(11) NOT NULL DEFAULT '-1' COMMENT '登录时间',
  `heartBeat` int(11) NOT NULL DEFAULT '-1' COMMENT '最后心跳时间',
  `inUse` int(1) NOT NULL DEFAULT '0' COMMENT '使用状态',
  `createAt` int(11) NOT NULL DEFAULT '-1' COMMENT '创建时间',
  `updateAt` int(11) NOT NULL DEFAULT '-1' COMMENT '更新时间 ',
  `deleteAt` int(11) NOT NULL DEFAULT '-1' COMMENT '删除时间',
  PRIMARY KEY (`id`) COMMENT 'sk 可以存在相同的情况',
  KEY `uk_acnt` (`accountId`) USING BTREE COMMENT '全局唯一',
  KEY `uk_device` (`deviceId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_account_login_history
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_account_login_history`;

CREATE TABLE `biz_account_login_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT 'login-前缀',
  `accountUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '账号Uuid',
  `platform` varchar(48) NOT NULL DEFAULT '' COMMENT '登录平台',
  `loginTime` int(11) NOT NULL DEFAULT '-1' COMMENT '记录登录时间',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  KEY `accountUUID_fk` (`accountUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;



# Dump of table biz_alert_opt
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_alert_opt`;

CREATE TABLE `biz_alert_opt` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID altopt- 前缀',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `tags` json DEFAULT NULL COMMENT '目标的tags',
  `start` int(11) NOT NULL DEFAULT '-1',
  `end` int(11) NOT NULL DEFAULT '-1',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_chart
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_chart`;

CREATE TABLE `biz_chart` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 chrt- 前缀',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '命名',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `chartGroupUUID` varchar(65) NOT NULL DEFAULT '' COMMENT '图表分组UUID',
  `dashboardUUID` varchar(65) NOT NULL DEFAULT '' COMMENT '所属视图UUID',
  `type` varchar(48) NOT NULL COMMENT '图表线条类型',
  `queries` json DEFAULT NULL COMMENT '查询信息',
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



# Dump of table biz_chart_group
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_chart_group`;

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



# Dump of table biz_dashboard
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_dashboard`;

CREATE TABLE `biz_dashboard` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 dsbd-前缀',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `name` varchar(500) NOT NULL COMMENT '视图名字',
  `image` varchar(128) NOT NULL DEFAULT '' COMMENT '视图的缩略图-废弃',
  `iconSet` json NOT NULL COMMENT '视图缩略图信息',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `chartPos` json NOT NULL COMMENT 'charts 位置信息[{chartUUID:xxx,pos:xxx}]',
  `chartGroupPos` json NOT NULL COMMENT 'chartGroup 位置信息[chartGroupUUIDs]',
  `type` varchar(48) NOT NULL DEFAULT 'CUSTOM' COMMENT '视图类型：仪表板视图',
  `ownerType` enum('node','inner','object_class','workspace','account','viewer','') CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `extend` json DEFAULT NULL COMMENT '额外拓展字段',
  `mapping` json NOT NULL COMMENT '视图变量的mapping',
  `dashboardBindSet` json DEFAULT NULL COMMENT '绑定视图设置',
  `createdWay` varchar(48) NOT NULL DEFAULT 'manual',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_dashboard_bidding
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_dashboard_bidding`;

CREATE TABLE `biz_dashboard_bidding` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '绑定关系uuid',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `dashboardUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '仪表板UUID',
  `type` varchar(128) NOT NULL COMMENT '类别：inner/integration',
  `dashboardBidding` json DEFAULT NULL COMMENT '绑定关系json',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`),
  KEY `idx_wsuuid` (`workspaceUUID`),
  KEY `idx_dsuuid` (`dashboardUUID`),
  KEY `idx_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_data_blacklist_rule
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_data_blacklist_rule`;

CREATE TABLE `biz_data_blacklist_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID, bkrul-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `type` enum('logging') NOT NULL DEFAULT 'logging' COMMENT '数据源类型',
  `source` varchar(64) NOT NULL DEFAULT '' COMMENT '数据来源',
  `filters` json NOT NULL COMMENT '过滤条件列表',
  `conditions` text NOT NULL COMMENT 'dql格式的过滤条件',
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



# Dump of table biz_decorate_node
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_decorate_node`;

CREATE TABLE `biz_decorate_node` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 node- 前缀',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `sceneUUID` varchar(48) NOT NULL COMMENT '场景 uuid',
  `parentUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '父节点 uuid',
  `name` varchar(128) NOT NULL COMMENT '子节点名称',
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
  KEY `node_parent_uuid_fk` (`parentUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_dialing_tasks
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_dialing_tasks`;

CREATE TABLE `biz_dialing_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID, dial-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `type` enum('http','tcp','dns','browser') NOT NULL DEFAULT 'http',
  `regions` json NOT NULL,
  `task` json NOT NULL COMMENT '任务数据',
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



# Dump of table biz_email
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_email`;

CREATE TABLE `biz_email` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID, 前缀是email_',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `type` enum('almost','already','invitation') NOT NULL DEFAULT 'almost' COMMENT '邮件类型',
  `temName` varchar(64) NOT NULL DEFAULT '' COMMENT '邮件模版名',
  `info` json NOT NULL COMMENT '邮件参数',
  `content` text NOT NULL COMMENT '邮件内容',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `e_ws_uuid` (`workspaceUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_entity_relationship
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_entity_relationship`;

CREATE TABLE `biz_entity_relationship` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `sourceType` varchar(48) NOT NULL DEFAULT '' COMMENT '源类型',
  `sourceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '源标记ID',
  `targetType` varchar(48) NOT NULL DEFAULT '' COMMENT '目标类型',
  `targetUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `extend` json NOT NULL COMMENT '额外数据',
  PRIMARY KEY (`id`),
  KEY `k_wksp_uuid` (`workspaceUUID`) USING BTREE,
  KEY `k_source_uuid` (`sourceUUID`) USING BTREE,
  KEY `k_target_uuid` (`targetUUID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_geo
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_geo`;

CREATE TABLE `biz_geo` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `country` varchar(128) NOT NULL DEFAULT '' COMMENT '国家',
  `province` varchar(128) NOT NULL DEFAULT '' COMMENT '省份',
  `city` varchar(128) NOT NULL DEFAULT '' COMMENT '城市',
  PRIMARY KEY (`id`),
  KEY `k_country` (`country`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_integration
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_integration`;

CREATE TABLE `biz_integration` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID, rul-',
  `type` varchar(48) NOT NULL DEFAULT '' COMMENT '类型',
  `path` varchar(512) DEFAULT NULL,
  `name` varchar(128) DEFAULT '' COMMENT '名称',
  `fileName` varchar(128) DEFAULT '' COMMENT '文件名 用于排序',
  `metaHash` varchar(256) DEFAULT NULL COMMENT 'meta hash值',
  `isHidden` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否隐藏，默认隐藏',
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



# Dump of table biz_monitor
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_monitor`;

CREATE TABLE `biz_monitor` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID, monitor-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `type` varchar(48) NOT NULL DEFAULT 'custom',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '规则分组名字',
  `config` json DEFAULT NULL COMMENT '其他设置',
  `alertOpt` json DEFAULT NULL COMMENT '触发操作设置',
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



# Dump of table biz_mute
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_mute`;

CREATE TABLE `biz_mute` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID mute- 前缀',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `type` enum('host','checker','monitor') NOT NULL DEFAULT 'host' COMMENT '静默对象的资源类型',
  `tags` json DEFAULT NULL COMMENT '目标的tags',
  `notifyTargets` json DEFAULT NULL COMMENT '通知对象列表',
  `notifyMessage` text NOT NULL COMMENT '通知内容',
  `notifyTime` int(11) NOT NULL DEFAULT '-1',
  `start` int(11) NOT NULL DEFAULT '-1',
  `end` int(11) NOT NULL DEFAULT '-1',
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



# Dump of table biz_node
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_node`;

CREATE TABLE `biz_node` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 node- 前缀',
  `name` varchar(128) NOT NULL COMMENT '命名',
  `iconSet` json DEFAULT NULL COMMENT '图标设置',
  `measurementLimit` json DEFAULT NULL COMMENT '指标集限制',
  `filter` json DEFAULT NULL COMMENT '过滤条件',
  `isInheritance` tinyint(1) DEFAULT '1' COMMENT '是否继承',
  `subTagKeyMeasurements` json DEFAULT NULL COMMENT '衍生节点标签指标集',
  `subTagKeys` json DEFAULT NULL COMMENT '子节点 tag 键值',
  `bindTagValues` json DEFAULT NULL COMMENT '绑定虚拟节点值',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `sceneUUID` varchar(48) NOT NULL COMMENT '场景 uuid',
  `parentUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '父节点 uuid',
  `templateUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '系统模板 uuid',
  `dashboardUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '视图 uuid',
  `subTemplateUUID` varchar(48) NOT NULL DEFAULT '',
  `subDashboardUUID` varchar(48) NOT NULL DEFAULT '',
  `exclude` json NOT NULL COMMENT '排除项',
  `subIconSet` json DEFAULT NULL COMMENT '子节点的图标信息',
  `subIsInheritance` tinyint(1) DEFAULT '1' COMMENT '子节点是否继承父节点过滤条件',
  `bindInfo` json DEFAULT NULL COMMENT '节点绑定信息',
  `path` json NOT NULL COMMENT '路径列表',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `isLoading` tinyint(1) DEFAULT NULL,
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



# Dump of table biz_notes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_notes`;

CREATE TABLE `biz_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 notes-前缀',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `name` varchar(128) NOT NULL COMMENT '笔记名字',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `pos` json NOT NULL COMMENT 'charts 位置信息[]',
  `createdWay` enum('import','template','') NOT NULL DEFAULT '' COMMENT '笔记的创建方式',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_notify_object
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_notify_object`;

CREATE TABLE `biz_notify_object` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID, monitor-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '通知对象名称',
  `type` enum('dingTalkRobot','HTTPRequest','wechatRobot','mailGroup','feishuRobot','sms') NOT NULL DEFAULT 'dingTalkRobot',
  `optSet` json DEFAULT NULL COMMENT '操作设置',
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



# Dump of table biz_object_class_cfg
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_object_class_cfg`;

CREATE TABLE `biz_object_class_cfg` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 objc-前缀',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `sourceType` enum('object','custom_object') NOT NULL DEFAULT 'custom_object' COMMENT '数据源来源类型',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '对象分类名',
  `alias` varchar(128) NOT NULL DEFAULT '' COMMENT '对象分类别名',
  `dashboardBindSet` json DEFAULT NULL COMMENT '视图绑定设置列表',
  `fields` json DEFAULT NULL COMMENT '属性配置列表',
  `extend` json DEFAULT NULL COMMENT '额外拓展字段',
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



# Dump of table biz_object_relation_graph
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_object_relation_graph`;

CREATE TABLE `biz_object_relation_graph` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 objrg-前缀',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `jsonContent` json NOT NULL COMMENT '关系数据JSON内容',
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



# Dump of table biz_often_browse_record
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_often_browse_record`;

CREATE TABLE `biz_often_browse_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间唯一UUID',
  `accountUUID` varchar(48) NOT NULL COMMENT '源UUID',
  `type` varchar(48) NOT NULL COMMENT '关系类型',
  `resourceUUID` varchar(48) NOT NULL COMMENT '目标UUID',
  `dateNum` int(11) NOT NULL DEFAULT '0' COMMENT '日期',
  `visitTimes` int(11) NOT NULL DEFAULT '0' COMMENT '访问次数',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  KEY `workspaceUUID_fk` (`workspaceUUID`),
  KEY `accountUUID_fk` (`accountUUID`),
  KEY `type_fk` (`type`),
  KEY `resourceUUID_fk` (`resourceUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_post_cc_history
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_post_cc_history`;

CREATE TABLE `biz_post_cc_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `date` varchar(256) NOT NULL DEFAULT '' COMMENT '上传日期',
  `detail` json DEFAULT NULL COMMENT '上传详情',
  `status` varchar(48) NOT NULL DEFAULT 'success' COMMENT '上传状态',
  `createAt` int(11) NOT NULL DEFAULT '-1' COMMENT '创建时间',
  PRIMARY KEY (`id`) COMMENT '主键'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_query
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_query`;

CREATE TABLE `biz_query` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID qry- 前缀',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '命名',
  `metric` varchar(256) NOT NULL DEFAULT '' COMMENT 'metric 名称',
  `query` json DEFAULT NULL COMMENT '查询条件, sql 或 json body',
  `qtype` enum('HTTP','TSQL','SQL','CUSTOM_FUNC') NOT NULL COMMENT '查询类型',
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



# Dump of table biz_resource_relationship
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_resource_relationship`;

CREATE TABLE `biz_resource_relationship` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间唯一UUID',
  `sourceUUID` varchar(48) NOT NULL COMMENT '源UUID',
  `type` varchar(48) NOT NULL COMMENT '关系类型',
  `targetUUID` varchar(48) NOT NULL COMMENT '目标UUID',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  KEY `workspaceUUID_fk` (`workspaceUUID`),
  KEY `sourceUUID_fk` (`sourceUUID`),
  KEY `type_fk` (`type`),
  KEY `targetUUID_fk` (`targetUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_rule
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_rule`;

CREATE TABLE `biz_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID, rul-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `type` enum('trigger','baseline','aggs','cloud_correlation_switch','logbackup','slo_detect','slo_compute') NOT NULL DEFAULT 'trigger',
  `kapaUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '所属Kapa的UUID',
  `monitorUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '监视器UUID',
  `jsonScript` json DEFAULT NULL COMMENT 'script的JSON数据',
  `tickInfo` json DEFAULT NULL COMMENT '提交后Kapa 返回的Tasks数据',
  `crontabInfo` json DEFAULT NULL COMMENT 'crontab配置信息',
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



# Dump of table biz_rum_cfg
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_rum_cfg`;

CREATE TABLE `biz_rum_cfg` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 rum- 前缀',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `jsonContent` json NOT NULL COMMENT '额外拓展字段',
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



# Dump of table biz_rum_trace
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_rum_trace`;

CREATE TABLE `biz_rum_trace` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID, rtrace-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT '追踪名称',
  `tags` json NOT NULL COMMENT '标签',
  `appId` varchar(64) NOT NULL,
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



# Dump of table biz_scene
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_scene`;

CREATE TABLE `biz_scene` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 scene-',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '场景名称',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `iconSet` json DEFAULT NULL COMMENT '图标设置',
  `describe` text NOT NULL COMMENT '场景的描述信息',
  `measurementLimit` json DEFAULT NULL COMMENT '指标集限制',
  `filter` json DEFAULT NULL COMMENT '过滤条件',
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



# Dump of table biz_share_config
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_share_config`;

CREATE TABLE `biz_share_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 scene-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `expirationAt` int(11) NOT NULL DEFAULT '0' COMMENT '发布的过期时间',
  `extractionCode` varchar(48) NOT NULL DEFAULT '' COMMENT '访问资源所需的提取码',
  `resourceType` varchar(32) NOT NULL DEFAULT '' COMMENT '资源类型',
  `resourceUUID` varchar(128) NOT NULL DEFAULT '' COMMENT '资源唯一标示UUID',
  `meta` json NOT NULL COMMENT '资源的元数据信息',
  `content` json NOT NULL COMMENT '分享对象的快照内容',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  `shortUrl` varchar(128) DEFAULT NULL COMMENT '短链接',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_snapshots
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_snapshots`;

CREATE TABLE `biz_snapshots` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，前缀snapshot',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间唯一UUID',
  `accountUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '账号Uuid',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '快照名称',
  `type` enum('logging','keyevent','tracing','object','dialing_task','security','rum','measurement','other','scene_dashboard','dashboard') NOT NULL DEFAULT 'logging' COMMENT '快照类型',
  `content` json NOT NULL COMMENT '用户自定义配置数据',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `acnt_wksp_fk` (`workspaceUUID`,`accountUUID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_sso_setting
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_sso_setting`;

CREATE TABLE `biz_sso_setting` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '身份提供商唯一id',
  `type` varchar(48) NOT NULL DEFAULT '' COMMENT '类别:saml2/oauth2',
  `idpName` varchar(256) NOT NULL DEFAULT '' COMMENT '身份提供商',
  `remark` varchar(512) NOT NULL DEFAULT '' COMMENT '备注',
  `uploadData` text NOT NULL COMMENT '上传数据',
  `workspaceUUID` varchar(64) NOT NULL COMMENT '工作空间 uuid',
  `role` enum('wsAdmin','general','readOnly','') NOT NULL DEFAULT '' COMMENT '用户默认角色',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  PRIMARY KEY (`id`),
  KEY `idx_uuid` (`uuid`),
  KEY `idx_wpuuid` (`workspaceUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_sso_white_list
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_sso_white_list`;

CREATE TABLE `biz_sso_white_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '唯一id',
  `email` varchar(256) NOT NULL DEFAULT '' COMMENT '邮箱',
  `ssoUUID` varchar(48) NOT NULL DEFAULT '' COMMENT 'sso配置唯一id',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '空间id',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  PRIMARY KEY (`id`),
  KEY `idx_email` (`email`),
  KEY `idx_wpuuid` (`workspaceUUID`),
  KEY `idx_ssouuid` (`ssoUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_sys_template
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_sys_template`;

CREATE TABLE `biz_sys_template` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID systpl-',
  `owner` varchar(48) NOT NULL DEFAULT '' COMMENT '所属目标类型',
  `code` varchar(48) NOT NULL DEFAULT '' COMMENT '命名',
  `note` text NOT NULL COMMENT '备注说明',
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



# Dump of table biz_tag
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_tag`;

CREATE TABLE `biz_tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 tag-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间唯一UUID',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '场景名称',
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



# Dump of table biz_tasks
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_tasks`;

CREATE TABLE `biz_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID, task_',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `action` enum('ApplyAdminPermissionApproval','') NOT NULL DEFAULT '',
  `jsonScript` json DEFAULT NULL COMMENT 'script的JSON数据',
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



# Dump of table biz_variable
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_variable`;

CREATE TABLE `biz_variable` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID,varl-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `dashboardUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '视图全局唯一 ID',
  `seq` int(4) NOT NULL DEFAULT '0' COMMENT '变量排序',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '变量显示名',
  `code` varchar(128) NOT NULL DEFAULT '' COMMENT '变量名',
  `type` enum('QUERY','CUSTOM_LIST','ALIYUN_INSTANCE','TAG','FIELD') NOT NULL COMMENT '类型',
  `datasource` varchar(48) NOT NULL COMMENT '数据源类型',
  `definition` json DEFAULT NULL COMMENT '解说，原content内容',
  `valueSort` varchar(8) DEFAULT '' COMMENT '视图变量的值排序',
  `content` json DEFAULT NULL COMMENT '变量配置数据',
  `hide` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否隐藏',
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



# Dump of table biz_viewer_configuration
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_viewer_configuration`;

CREATE TABLE `biz_viewer_configuration` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 viewconfig-前缀',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `type` varchar(48) NOT NULL DEFAULT 'custom_object' COMMENT '查看器类型',
  `config` json DEFAULT NULL COMMENT '分组标签',
  `extend` json DEFAULT NULL COMMENT '额外拓展字段',
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



# Dump of table main_accesskey
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_accesskey`;

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



# Dump of table main_account
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_account`;

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
  `nameSpace` varchar(48) NOT NULL DEFAULT '' COMMENT '账号的命名空间',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `createAt` int(11) NOT NULL DEFAULT '-1' COMMENT '创建时间',
  `updateAt` int(11) NOT NULL DEFAULT '-1' COMMENT '更新时间 ',
  `deleteAt` int(11) NOT NULL DEFAULT '-1' COMMENT '删除时间',
  PRIMARY KEY (`id`) COMMENT 'sk 可以存在相同的情况',
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT '全局唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table main_account_privilege
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_account_privilege`;

CREATE TABLE `main_account_privilege` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 acpv',
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



# Dump of table main_account_workspace
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_account_workspace`;

CREATE TABLE `main_account_workspace` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 rlaw-前缀',
  `accountUUID` varchar(48) NOT NULL COMMENT '帐户唯一ID',
  `workspaceUUID` varchar(64) NOT NULL COMMENT '工作空间 uuid',
  `dashboardUUID` varchar(48) DEFAULT NULL COMMENT '视图UUID-与用户绑定',
  `role` enum('owner','wsAdmin','general','readOnly','') NOT NULL DEFAULT '' COMMENT '用户在当前工作空间的角色',
  `allSceneVisible` int(1) NOT NULL DEFAULT '0' COMMENT '可见所有场景',
  `isAdmin` int(1) NOT NULL DEFAULT '0' COMMENT '是否为管理员',
  `waitAudit` int(1) NOT NULL DEFAULT '0' COMMENT '是否等待审核',
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



# Dump of table main_agent
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_agent`;

CREATE TABLE `main_agent` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT 'ftagent的uuid,唯一id 待 agnt-前缀',
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT 'agent 名称',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `version` varchar(32) NOT NULL DEFAULT '""' COMMENT '当前版本号',
  `url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '完整地址',
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
  KEY `idx_uuid` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table main_agent_license
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_agent_license`;

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



# Dump of table main_apm_config
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_apm_config`;

CREATE TABLE `main_apm_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 apmc-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间 uuid',
  `service` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '服务名',
  `config` json NOT NULL COMMENT 'apm配置参数',
  `status` int(11) NOT NULL DEFAULT '0',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table main_ck_datasync
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_ck_datasync`;

CREATE TABLE `main_ck_datasync` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 ckds-',
  `dbUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '原始 Measurement 所在 DB uuid',
  `measurement` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '指标名',
  `tableName` varchar(128) NOT NULL DEFAULT '' COMMENT 'ck table name',
  `startTime` int(11) NOT NULL COMMENT '单位: 秒',
  `status` int(11) NOT NULL DEFAULT '0',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table main_config
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_config`;

CREATE TABLE `main_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `keyCode` varchar(48) NOT NULL COMMENT '配置项唯一Code',
  `description` text NOT NULL COMMENT '描述信息',
  `value` json NOT NULL COMMENT '配置数据',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`keyCode`) COMMENT 'UUID 做成全局唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table main_datakit_online
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_datakit_online`;

CREATE TABLE `main_datakit_online` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 dkol-',
  `name` varchar(128) DEFAULT '' COMMENT 'datakit name',
  `hostName` varchar(128) DEFAULT NULL COMMENT 'host name',
  `ip` varchar(24) DEFAULT NULL COMMENT 'ip 地址',
  `token` varchar(64) NOT NULL COMMENT '采集数据token',
  `dkUUID` varchar(48) NOT NULL COMMENT 'datakit uuid',
  `version` varchar(48) DEFAULT '' COMMENT 'datakit version',
  `os` varchar(48) DEFAULT '' COMMENT 'os',
  `arch` varchar(48) DEFAULT '' COMMENT 'arch',
  `inputInfo` json DEFAULT NULL COMMENT 'input 相关信息',
  `lastOnline` int(11) DEFAULT NULL COMMENT '最后一次online时间',
  `lastHeartbeat` int(11) DEFAULT NULL COMMENT '最后一次心跳时间',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  KEY `k_dkuuid` (`dkUUID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table main_es_instance
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_es_instance`;

CREATE TABLE `main_es_instance` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 es_',
  `host` varchar(128) NOT NULL COMMENT '源的配置信息',
  `authorization` json NOT NULL COMMENT 'influx 登陆信息',
  `isParticipateElection` int(1) NOT NULL DEFAULT '0' COMMENT '是否参与选举',
  `wsCount` int(11) NOT NULL DEFAULT '0' COMMENT '关联的工作空间数量',
  `provider` varchar(20) NOT NULL,
  `version` varchar(48) NOT NULL,
  `timeout` varchar(48) DEFAULT '60s' COMMENT '超时时间设置',
  `extend` json DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table main_influx_cq
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_influx_cq`;

CREATE TABLE `main_influx_cq` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 ifcq-',
  `dbUUID` varchar(48) NOT NULL DEFAULT '',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `sampleEvery` varchar(48) NOT NULL DEFAULT '30m' COMMENT 'RESAMPLE every XXX',
  `sampleFor` varchar(48) NOT NULL DEFAULT '1h' COMMENT 'RESAMPLE for XXX',
  `measurement` varchar(256) NOT NULL DEFAULT '' COMMENT '指标名',
  `rp` varchar(48) NOT NULL DEFAULT '' COMMENT '不填则只用 @db 的默认 RP',
  `cqrp` varchar(48) NOT NULL DEFAULT '' COMMENT '不填则用 CQ 默认的 RP, 比如 rpcq',
  `aggrFunc` varchar(48) NOT NULL DEFAULT 'mean',
  `groupByTime` varchar(48) NOT NULL DEFAULT '30m',
  `groupByOffset` varchar(48) NOT NULL DEFAULT '15m',
  `status` int(11) NOT NULL DEFAULT '0',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table main_influx_db
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_influx_db`;

CREATE TABLE `main_influx_db` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 ifdb_',
  `db` varchar(48) NOT NULL DEFAULT '' COMMENT 'DB 名称',
  `influxInstanceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT 'instance的UUID',
  `influxRpUUID` varchar(48) NOT NULL DEFAULT '' COMMENT 'influx rp uuid',
  `influxRpName` varchar(48) NOT NULL DEFAULT '' COMMENT 'influx dbrp name',
  `cqrp` varchar(48) NOT NULL,
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



# Dump of table main_influx_instance
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_influx_instance`;

CREATE TABLE `main_influx_instance` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 iflx_',
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



# Dump of table main_influx_rp
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_influx_rp`;

CREATE TABLE `main_influx_rp` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀ifrp_',
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



# Dump of table main_inner_app
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_inner_app`;

CREATE TABLE `main_inner_app` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，关联用，带 inap_ 前缀',
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



# Dump of table main_kapa
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_kapa`;

CREATE TABLE `main_kapa` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 kapa_',
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



# Dump of table main_key_config
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_key_config`;

CREATE TABLE `main_key_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID,带keycf-',
  `workspaceUUID` varchar(48) NOT NULL COMMENT '工作空间uuid',
  `keyCode` varchar(48) NOT NULL COMMENT '配置项唯一Code',
  `description` text NOT NULL COMMENT '描述信息',
  `value` text NOT NULL COMMENT '配置数据',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 禁用/2: 失效/3: 删除',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table main_log_extract_rule
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_log_extract_rule`;

CREATE TABLE `main_log_extract_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 taly-',
  `batchesID` varchar(48) NOT NULL COMMENT 'func批处理id',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间 uuid',
  `source` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '来源',
  `funcId` varchar(48) NOT NULL DEFAULT '' COMMENT '解析方法',
  `url` varchar(128) NOT NULL DEFAULT '' COMMENT 'url',
  `funcKwargsJSON` json NOT NULL COMMENT 'func函数所需参数',
  `status` int(11) NOT NULL DEFAULT '0',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_batchesID` (`batchesID`) COMMENT 'batchesID  做成全局唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table main_manage_account
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_manage_account`;

CREATE TABLE `main_manage_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT 'account 唯一标识 mact-',
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT '昵称',
  `role` varchar(10) NOT NULL COMMENT '角色  admin: 管理员/ dev: 开发者',
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



# Dump of table main_subscription
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_subscription`;

CREATE TABLE `main_subscription` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 sbsp_',
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



# Dump of table main_workspace
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_workspace`;

CREATE TABLE `main_workspace` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 wksp_',
  `name` varchar(128) NOT NULL COMMENT '命名',
  `token` varchar(64) DEFAULT '""' COMMENT '采集数据token',
  `cliToken` varchar(64) NOT NULL DEFAULT '' COMMENT '命令行Token验证',
  `dbUUID` varchar(48) NOT NULL COMMENT 'influx_db uuid对应influx实例的DB名',
  `esInstanceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '所属ES实例的UUID',
  `isOpenWarehouse` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否开启数据仓库',
  `dataRestriction` json DEFAULT NULL COMMENT '数据权限',
  `maxTsCount` int(11) NOT NULL DEFAULT '100' COMMENT '最大时间线',
  `dashboardUUID` varchar(48) DEFAULT NULL COMMENT '工作空间概览-视图UUID',
  `exterId` varchar(128) NOT NULL DEFAULT '' COMMENT '外部ID',
  `desc` text,
  `versionInfo` json DEFAULT NULL COMMENT '版本信息',
  `bindInfo` json DEFAULT NULL COMMENT '绑定到当前工作空间的信息',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `rpName` varchar(48) NOT NULL DEFAULT '' COMMENT 'db rp',
  `alarmHistoryPeriod` varchar(48) NOT NULL DEFAULT '' COMMENT '告警历史保留时长',
  `autoAggregation` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否自动聚合',
  `esRP` json DEFAULT NULL COMMENT 'es 生命周期管理',
  `enablePublicDataway` int(1) NOT NULL DEFAULT '1' COMMENT '允许公网Dataway上传数据',
  `durationSet` json DEFAULT NULL COMMENT '数据保留时长设置',
  `versionType` enum('free','pay','unlimited') NOT NULL DEFAULT 'free' COMMENT 'free表示免费版，pay表示付费版',
  `billingState` enum('free','unlimited','normal','arrearage','expired') NOT NULL DEFAULT 'free' COMMENT '帐户费用状态',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table main_workspace_accesskey
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_workspace_accesskey`;

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



# Dump of table main_workspace_license
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_workspace_license`;

CREATE TABLE `main_workspace_license` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT 'license lcn-',
  `workspaceUUID` varchar(64) NOT NULL DEFAULT '' COMMENT '工作空间 uuid',
  `instanceId` varchar(64) NOT NULL DEFAULT '' COMMENT 'LicenseId',
  `expire` int(11) NOT NULL COMMENT 'license 过期时间',
  `disableTime` int(11) DEFAULT '0' COMMENT '数据失效时间',
  `version` varchar(48) NOT NULL COMMENT 'license 版本',
  `extend` json NOT NULL COMMENT '额外拓展字段',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: 正常/2: 禁用/3: 删除',
  `createAt` int(11) NOT NULL DEFAULT '-1' COMMENT '创建时间',
  `updateAt` int(11) NOT NULL DEFAULT '-1' COMMENT '更新时间 ',
  `deleteAt` int(11) NOT NULL DEFAULT '-1' COMMENT '删除时间',
  PRIMARY KEY (`id`) COMMENT '主键',
  UNIQUE KEY `uk_instanceId` (`instanceId`) COMMENT 'license id 做成全局唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table main_workspace_token
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_workspace_token`;

CREATE TABLE `main_workspace_token` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '采集数据token 唯一标识 tokn-',
  `expirationAt` int(11) NOT NULL DEFAULT '-1' COMMENT '过期时间',
  `workspaceUUID` varchar(64) NOT NULL DEFAULT '' COMMENT '工作空间 uuid',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: 正常/2: 禁用/3: 删除',
  `createAt` int(11) NOT NULL DEFAULT '-1' COMMENT '创建时间',
  `updateAt` int(11) NOT NULL DEFAULT '-1' COMMENT '更新时间 ',
  `deleteAt` int(11) NOT NULL DEFAULT '-1' COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `uk_wksp` (`workspaceUUID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table post_cc_history
# ------------------------------------------------------------

DROP TABLE IF EXISTS `post_cc_history`;

CREATE TABLE `post_cc_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `date` varchar(256) NOT NULL DEFAULT '' COMMENT '上传日期',
  `detail` json DEFAULT NULL COMMENT '上传详情',
  `status` varchar(48) NOT NULL DEFAULT 'success' COMMENT '上传状态',
  `createAt` int(11) NOT NULL DEFAULT '-1' COMMENT '创建时间',
  PRIMARY KEY (`id`) COMMENT '主键'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table sys_version
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sys_version`;

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




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
