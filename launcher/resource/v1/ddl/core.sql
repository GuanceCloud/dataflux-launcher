# ************************************************************
# Sequel Pro SQL dump
# Version 5446
#
# https://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 172.16.2.203 (MySQL 5.7.33-log)
# Database: df_new
# Generation Time: 2023-06-20 06:46:00 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
SET NAMES utf8mb4;
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



# Dump of table biz_account_group
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_account_group`;

CREATE TABLE `biz_account_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 group-',
  `name` varchar(256) NOT NULL DEFAULT '' COMMENT '成员组名称',
  `workspaceUUID` varchar(64) NOT NULL DEFAULT '' COMMENT '工作空间 uuid',
  `status` int(11) NOT NULL DEFAULT '0',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_account_group_relation
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_account_group_relation`;

CREATE TABLE `biz_account_group_relation` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 rlag-',
  `groupUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '成员组 uuid',
  `accountUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '成员账户uuid',
  `status` int(11) NOT NULL DEFAULT '0',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_group_uuid` (`groupUUID`),
  KEY `k_acnt_uuid` (`accountUUID`)
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



# Dump of table biz_account_role
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_account_role`;

CREATE TABLE `biz_account_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID，带 refar- 前缀',
  `accountUUID` varchar(64) NOT NULL COMMENT '账号UUID',
  `roleUUID` varchar(64) NOT NULL COMMENT '角色UUID',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_account_uuid` (`accountUUID`),
  KEY `k_role_uuid` (`roleUUID`),
  KEY `k_ws_uuid` (`workspaceUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



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



# Dump of table biz_api_permission
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_api_permission`;

CREATE TABLE `biz_api_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `permission` varchar(256) NOT NULL DEFAULT '' COMMENT '权限标识',
  `code` varchar(256) NOT NULL DEFAULT '' COMMENT 'api接口标识',
  `name` varchar(256) NOT NULL DEFAULT '' COMMENT 'api接口名称',
  `url` varchar(256) NOT NULL DEFAULT '''''' COMMENT '路由标志',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_permission_code` (`permission`,`code`) COMMENT 'UUID 做成全局唯一',
  KEY `k_permission` (`permission`),
  KEY `k_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_attachment_relationship
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_attachment_relationship`;

CREATE TABLE `biz_attachment_relationship` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 att-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间 uuid',
  `sourceType` varchar(48) NOT NULL DEFAULT '' COMMENT '附件所属资源类型',
  `sourceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '附件所属资源UUID',
  `name` varchar(128) NOT NULL COMMENT '文件名',
  `config` json NOT NULL COMMENT '配置信息',
  `status` int(11) NOT NULL DEFAULT '0',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_sourceUUID` (`sourceUUID`),
  KEY `k_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_bind_menu
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_bind_menu`;

CREATE TABLE `biz_bind_menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 rlvm- 前缀',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `bindUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '查看器UUID',
  `bindType` enum('viewer','') CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '菜单栏类型',
  `menuType` enum('Events','Objectadmin','MetricQuery','LogIndi','Tracing','Rum','CloudDial','Security','GitLabCI','ExceptionsTracking') DEFAULT NULL,
  `extend` json NOT NULL COMMENT '额外拓展字段',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_v_uuid` (`bindUUID`),
  KEY `k_bind_type` (`bindType`),
  KEY `k_menu_type` (`menuType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_channel
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_channel`;

CREATE TABLE `biz_channel` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 chan-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间 uuid',
  `name` varchar(256) NOT NULL DEFAULT '' COMMENT '频道名称',
  `description` text NOT NULL COMMENT '备注',
  `notifyTarget` json DEFAULT NULL COMMENT '通知对象列表',
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



# Dump of table biz_channel_issue
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_channel_issue`;

CREATE TABLE `biz_channel_issue` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 cissue-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间唯一UUID',
  `channelUUID` varchar(48) NOT NULL COMMENT '频道UUID',
  `issueUUID` varchar(48) NOT NULL COMMENT '订阅者UUID',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `workspaceUUID_fk` (`workspaceUUID`),
  KEY `channelUUID_fk` (`channelUUID`),
  KEY `issueUUID_fk` (`issueUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_chart
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_chart`;

CREATE TABLE `biz_chart` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 chrt- 前缀',
  `name` varchar(256) NOT NULL DEFAULT '' COMMENT '命名',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `chartGroupUUID` varchar(65) NOT NULL DEFAULT '' COMMENT '图表分组UUID',
  `dashboardUUID` varchar(65) NOT NULL DEFAULT '' COMMENT '所属视图UUID',
  `notesUUID` varchar(65) NOT NULL DEFAULT '' COMMENT '笔记的UUID',
  `type` varchar(48) NOT NULL COMMENT '图表线条类型',
  `queries` json DEFAULT NULL COMMENT '查询信息',
  `extend` json NOT NULL COMMENT '额外拓展字段',
  `isWorkspaceKeyIndicator` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为工作空间关键指标的查询',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_notes_uuid` (`notesUUID`),
  KEY `k_dashboard_uuid` (`dashboardUUID`),
  KEY `k_cgp_uuid` (`chartGroupUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_chart_group
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_chart_group`;

CREATE TABLE `biz_chart_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID chtg-',
  `name` varchar(256) NOT NULL DEFAULT '' COMMENT '图表组名',
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



# Dump of table biz_custom_rum_view
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_custom_rum_view`;

CREATE TABLE `biz_custom_rum_view` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 bcrv- 前缀',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `appId` varchar(48) NOT NULL COMMENT '新建自定义rum的UUID, appId',
  `dashboardUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '用户自定义UUID,用户视图',
  `integrationUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '系统视图UUID',
  `extend` json DEFAULT NULL COMMENT '额外信息',
  `isStickOn` tinyint(1) NOT NULL DEFAULT '0' COMMENT '关联的视图是否要固定, 1:钉住 0:取消钉住',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `app_id_fk` (`appId`),
  KEY `dashboard_uuid_fk` (`dashboardUUID`),
  KEY `integration_uuid_fk` (`integrationUUID`)
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
  `isPublic` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否公开展示,1代表公开,0代表仅自己可见',
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



# Dump of table biz_dashboard_carousel
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_dashboard_carousel`;

CREATE TABLE `biz_dashboard_carousel` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 csel-',
  `name` varchar(256) NOT NULL DEFAULT '' COMMENT '轮播名称',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `accountUUID` varchar(256) NOT NULL DEFAULT '' COMMENT '账户uuid',
  `dashboardUUIDs` json NOT NULL COMMENT '仪表板轮播列表',
  `intervalTime` varchar(48) NOT NULL COMMENT '轮播频率',
  `status` int(11) NOT NULL DEFAULT '0',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_acount_uuid` (`accountUUID`),
  KEY `k_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_data_blacklist_rule
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_data_blacklist_rule`;

CREATE TABLE `biz_data_blacklist_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID, bkrul-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `type` enum('object','custom_object','logging','keyevent','tracing','rum','network','security','profiling','metric') NOT NULL DEFAULT 'logging' COMMENT '数据源类型',
  `source` varchar(128) NOT NULL DEFAULT '' COMMENT '数据来源',
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
  `type` enum('http','tcp','dns','browser','icmp','websocket') NOT NULL DEFAULT 'http',
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
  `type` enum('almost','already','invitation','usageAlready','billHighWarn') NOT NULL DEFAULT 'almost',
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



# Dump of table biz_external_resource_access_config
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_external_resource_access_config`;

CREATE TABLE `biz_external_resource_access_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 erac-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间 uuid',
  `config` json DEFAULT NULL COMMENT '访问配置信息',
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



# Dump of table biz_field_management
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_field_management`;

CREATE TABLE `biz_field_management` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 field-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `name` varchar(256) NOT NULL DEFAULT '' COMMENT '字段名',
  `unit` varchar(256) NOT NULL DEFAULT '' COMMENT '单位',
  `fieldType` enum('text','number','time','percent','int','float','boolean','string','long','') NOT NULL DEFAULT '',
  `fieldSource` enum('logging','object','custom_object','keyevent','tracing','rum','security','network','') NOT NULL DEFAULT '',
  `desc` text NOT NULL COMMENT '描述信息',
  `descEn` text NOT NULL COMMENT '描述信息En',
  `sysField` int(1) NOT NULL DEFAULT '0' COMMENT '自定义字段或者 系统内置字段, 1代表系统内置字段, 0代表自定义字段',
  `status` int(11) NOT NULL DEFAULT '0',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_func_function
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_func_function`;

CREATE TABLE `biz_func_function` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 relfw-前缀',
  `funcServerId` varchar(48) NOT NULL DEFAULT '' COMMENT 'Func 服务唯一标识',
  `workspaceUUID` varchar(64) NOT NULL COMMENT '工作空间 uuid',
  `funcId` varchar(256) DEFAULT '' COMMENT 'func 函数ID',
  `name` varchar(256) DEFAULT '' COMMENT 'func 函数名',
  `category` varchar(256) DEFAULT '' COMMENT '函数分类',
  `config` json DEFAULT NULL COMMENT 'func 服务上报的其他信息',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_func_server_id` (`funcServerId`),
  KEY `k_func_id` (`funcId`),
  KEY `k_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_func_server
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_func_server`;

CREATE TABLE `biz_func_server` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID, f-',
  `funcServerId` varchar(48) NOT NULL DEFAULT '' COMMENT 'Func 服务唯一标识',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '服务名称',
  `config` json DEFAULT NULL COMMENT '配置信息',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_func_server_id` (`funcServerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_func_server_workspace
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_func_server_workspace`;

CREATE TABLE `biz_func_server_workspace` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 relfw-前缀',
  `funcServerId` varchar(48) NOT NULL DEFAULT '' COMMENT 'Func 服务唯一标识',
  `workspaceUUID` varchar(64) NOT NULL COMMENT '工作空间 uuid',
  `name` varchar(256) NOT NULL DEFAULT '' COMMENT 'func 服务名',
  `config` json DEFAULT NULL COMMENT 'func 服务上报的其他信息',
  `isActive` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'func 是否为活跃状态',
  `lastPingAt` int(11) NOT NULL DEFAULT '-1' COMMENT '本地 func 最后一次有效 ping 服务端的时间点',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_func_server_id` (`funcServerId`)
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



# Dump of table biz_high_comsume_warn
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_high_comsume_warn`;

CREATE TABLE `biz_high_comsume_warn` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 bhcw-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '对应工作空间UUID',
  `config` json DEFAULT NULL COMMENT '空间高消费阈值配置信息 key(项目)-value(金钱)',
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



# Dump of table biz_index_field_mapping
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_index_field_mapping`;

CREATE TABLE `biz_index_field_mapping` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 indfm-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间 uuid',
  `indexCfgUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '索引配置的 uuid',
  `field` varchar(256) NOT NULL DEFAULT '' COMMENT '字段名',
  `originalField` varchar(256) NOT NULL DEFAULT '' COMMENT '原始字段名',
  `sortNo` int(11) NOT NULL DEFAULT '-1' COMMENT '字段顺序',
  `status` int(11) NOT NULL DEFAULT '0',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_index_cfg_uuid` (`indexCfgUUID`),
  KEY `k_field` (`field`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_integration
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_integration`;

CREATE TABLE `biz_integration` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID, rul-',
  `type` varchar(48) NOT NULL DEFAULT '' COMMENT '类型',
  `path` varchar(512) DEFAULT NULL,
  `name` varchar(256) DEFAULT '' COMMENT '名称',
  `fileName` varchar(128) DEFAULT '' COMMENT '文件名 用于排序',
  `metaHash` varchar(256) DEFAULT NULL COMMENT 'meta hash值',
  `isHidden` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否隐藏，默认隐藏',
  `meta` json DEFAULT NULL COMMENT '数据集meta信息',
  `language` varchar(64) NOT NULL DEFAULT 'zh' COMMENT '语言类型',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_issue
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_issue`;

CREATE TABLE `biz_issue` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 issue-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间 uuid',
  `name` varchar(256) NOT NULL COMMENT '标题',
  `level` int(4) NOT NULL DEFAULT '0' COMMENT '级别',
  `statusType` int(4) NOT NULL DEFAULT '0' COMMENT '状态类型',
  `description` text NOT NULL COMMENT '描述信息',
  `resourceType` varchar(48) NOT NULL DEFAULT '' COMMENT '来源资源类型',
  `resourceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '来源资源UUID',
  `subIdentify` varchar(45) NOT NULL DEFAULT '' COMMENT '来源子标识',
  `resource` varchar(512) NOT NULL DEFAULT '' COMMENT '来源资源的标题或者名称',
  `extend` json DEFAULT NULL COMMENT '额外信息',
  `status` int(11) NOT NULL DEFAULT '0',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_resourceUUID` (`resourceUUID`),
  KEY `k_name` (`name`),
  KEY `k_resource` (`resource`),
  KEY `k_sub_identify` (`subIdentify`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_issue_message
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_issue_message`;

CREATE TABLE `biz_issue_message` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 issue-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间 uuid',
  `issueUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '所属Issue',
  `type` enum('change','reply') NOT NULL DEFAULT 'change' COMMENT '消息类型',
  `content` text NOT NULL COMMENT '消息内容',
  `extend` json DEFAULT NULL COMMENT '额外信息',
  `status` int(11) NOT NULL DEFAULT '0',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_issueUUID` (`issueUUID`),
  KEY `k_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_logging_backup_cfg
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_logging_backup_cfg`;

CREATE TABLE `biz_logging_backup_cfg` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID, lgbp-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `externalResourceAccessCfgUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '外部资源访问配置UUID',
  `name` varchar(256) NOT NULL DEFAULT '' COMMENT '备份规则名',
  `conditions` text NOT NULL COMMENT 'dql格式的过滤条件',
  `extend` json DEFAULT NULL COMMENT '额外配置数据',
  `storeType` enum('','es','sls','opensearch','beaver','s3','obs') NOT NULL DEFAULT '' COMMENT '存储类型',
  `syncExtensionField` tinyint(1) DEFAULT '0' COMMENT 'true 为同步, false为不同步',
  `taskStatusCode` int(11) NOT NULL DEFAULT '-1' COMMENT 'kodo侧规则任务执行状态',
  `taskErrorCode` varchar(45) NOT NULL DEFAULT '' COMMENT 'Kodo侧规则任务执行异常错误码',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_external_resource_access_cfg_uuid` (`externalResourceAccessCfgUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_logging_index_cfg
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_logging_index_cfg`;

CREATE TABLE `biz_logging_index_cfg` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID, lgim-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `name` varchar(256) NOT NULL DEFAULT '' COMMENT '索引名称',
  `conditions` text NOT NULL COMMENT 'dql格式的过滤条件',
  `duration` varchar(48) NOT NULL DEFAULT '' COMMENT '数据保留时长',
  `sortNo` int(11) NOT NULL DEFAULT '0' COMMENT '排序值, 值越大优先级越高',
  `setting` json DEFAULT NULL COMMENT '索引分片设置',
  `isBindCustomStore` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为绑定的自定义存储',
  `queryType` varchar(64) NOT NULL DEFAULT 'logging' COMMENT '外部store的查询类型',
  `exterStoreProject` varchar(256) NOT NULL DEFAULT '' COMMENT '外部Store的上层标识',
  `exterStoreName` varchar(256) NOT NULL DEFAULT '' COMMENT '与name互为映射的外部存储的名字',
  `extend` json DEFAULT NULL COMMENT '额外配置数据',
  `externalResourceAccessCfgUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '外部资源访问配置UUID',
  `storeType` enum('','es','sls','opensearch','beaver') NOT NULL DEFAULT '' COMMENT '存储类型, 空值表示与工作空间默认数据存储类型保持一致',
  `region` varchar(45) NOT NULL DEFAULT '' COMMENT '目标地域',
  `isPublicNetworkAccess` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否走公网访问',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_external_resource_access_cfg_uuid` (`externalResourceAccessCfgUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_logging_query_rule
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_logging_query_rule`;

CREATE TABLE `biz_logging_query_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 lqrl-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `indexes` json DEFAULT NULL COMMENT '限制的索引',
  `roleUUIDs` json DEFAULT NULL COMMENT '授权哪些角色的查询',
  `extend` json DEFAULT NULL COMMENT '自定义数据',
  `logic` varchar(48) NOT NULL DEFAULT '',
  `conditions` varchar(512) NOT NULL DEFAULT '' COMMENT '筛选搜索的conditions',
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



# Dump of table biz_metric_detail
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_metric_detail`;

CREATE TABLE `biz_metric_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID, metr_',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `unit` varchar(255) NOT NULL DEFAULT '' COMMENT '单位',
  `metric` varchar(512) NOT NULL DEFAULT '' COMMENT '指标集名',
  `metricField` varchar(512) NOT NULL DEFAULT '' COMMENT '指标名',
  `describe` text NOT NULL COMMENT '描述',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `idx_ws_uuid` (`workspaceUUID`),
  KEY `idx_metric` (`metric`),
  KEY `idx_metric_field` (`metricField`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_monitor
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_monitor`;

CREATE TABLE `biz_monitor` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID, monitor-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `type` varchar(48) NOT NULL DEFAULT 'custom',
  `name` varchar(256) NOT NULL DEFAULT '' COMMENT '规则分组名字',
  `config` json DEFAULT NULL COMMENT '其他设置',
  `alertOpt` json DEFAULT NULL COMMENT '触发操作设置',
  `score` int(11) NOT NULL DEFAULT '0' COMMENT '排序分数',
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
  `muteRanges` json DEFAULT NULL COMMENT '静默范围, []代表所有',
  `tags` json DEFAULT NULL COMMENT '目标的tags',
  `notifyTargets` json DEFAULT NULL COMMENT '通知对象列表',
  `notifyMessage` text NOT NULL COMMENT '通知内容',
  `notifyTime` int(11) NOT NULL DEFAULT '-1',
  `start` int(11) NOT NULL DEFAULT '-1',
  `end` int(11) NOT NULL DEFAULT '-1',
  `crontabDuration` int(11) NOT NULL DEFAULT '0' COMMENT '重复静默时, 调用func的crontabDuration参数, 单位为 s',
  `crontab` varchar(48) NOT NULL DEFAULT '' COMMENT '重复静默时, 调用func的crontab参数',
  `repeatExpire` int(11) NOT NULL DEFAULT '-1' COMMENT '过期时间, 0代表无过期时间,永久生效, -1为默认配置,非重复静默',
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
  `name` varchar(256) NOT NULL COMMENT '笔记名字',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `pos` json NOT NULL COMMENT 'charts 位置信息[]',
  `createdWay` enum('import','template','') NOT NULL DEFAULT '' COMMENT '笔记的创建方式',
  `isPublic` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否公开展示,1代表公开,0代表仅自己可见',
  `extend` json DEFAULT NULL COMMENT '额外拓展字段',
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
  `name` varchar(256) NOT NULL DEFAULT '' COMMENT '通知对象名称',
  `type` enum('dingTalkRobot','HTTPRequest','wechatRobot','mailGroup','feishuRobot','sms','selfBuildNotifyFunction') NOT NULL DEFAULT 'dingTalkRobot',
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
  `name` varchar(256) NOT NULL DEFAULT '' COMMENT '对象分类名',
  `alias` varchar(256) NOT NULL DEFAULT '' COMMENT '对象分类别名',
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



# Dump of table biz_object_label
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_object_label`;

CREATE TABLE `biz_object_label` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一ID,用于获取具体对象的标签',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `labels` json DEFAULT NULL COMMENT '标签信息',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `label_uuid` (`workspaceUUID`,`uuid`) COMMENT '由 workspaceUUID,uuid 唯一确定'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='基础对象标签信息';



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



# Dump of table biz_permission
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_permission`;

CREATE TABLE `biz_permission` (
  `key` varchar(256) NOT NULL DEFAULT '' COMMENT '权限标识',
  `name` varchar(256) NOT NULL DEFAULT '' COMMENT '权限名称',
  `desc` text COMMENT '权限描述',
  `nameEn` varchar(256) DEFAULT '''''' COMMENT '英文名称',
  `descEn` text COMMENT '英文描述',
  `isSupportOwner` tinyint(1) DEFAULT '0' COMMENT '支持 owner 角色使用',
  `isSupportWsAdmin` tinyint(1) DEFAULT '0' COMMENT '支持 wsAdmin 角色使用',
  `isSupportGeneral` tinyint(1) DEFAULT '0' COMMENT '支持 general 角色使用',
  `isSupportReadOnly` tinyint(1) DEFAULT '0' COMMENT '支持 readOnly 角色使用',
  `isSupportCustomRole` tinyint(1) DEFAULT '0' COMMENT '支持自定义角色使用',
  `seq` int(11) DEFAULT NULL COMMENT '序号',
  PRIMARY KEY (`key`),
  KEY `k_name` (`name`),
  KEY `k_name_en` (`nameEn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_pipeline
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_pipeline`;

CREATE TABLE `biz_pipeline` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID，带 pl- 前缀',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `category` varchar(256) NOT NULL DEFAULT '',
  `asDefault` tinyint(1) DEFAULT '0' COMMENT '是否该类型默认pipeline',
  `name` varchar(1024) NOT NULL DEFAULT '' COMMENT 'PL文件名',
  `content` text NOT NULL COMMENT '原始内容',
  `testData` text NOT NULL,
  `isSysTemplate` int(1) DEFAULT '0' COMMENT '是否为系统模版',
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



# Dump of table biz_pipeline_relation
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_pipeline_relation`;

CREATE TABLE `biz_pipeline_relation` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 rlag-',
  `name` varchar(256) NOT NULL DEFAULT '' COMMENT 'PL文件名',
  `source` varchar(256) NOT NULL DEFAULT '' COMMENT 'source来源',
  `category` varchar(48) NOT NULL DEFAULT '' COMMENT 'pipeline类型',
  `pipelineUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '成员账户uuid',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `status` int(11) NOT NULL DEFAULT '0',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_source` (`source`),
  KEY `k_pipeline_uuid` (`pipelineUUID`),
  KEY `k_wksp_uuid` (`workspaceUUID`)
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



# Dump of table biz_role
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_role`;

CREATE TABLE `biz_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 role- 前缀',
  `name` varchar(256) NOT NULL DEFAULT '' COMMENT '角色名',
  `desc` text COMMENT '描述信息',
  `isSystem` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为系统内置角色',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_role_permission
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_role_permission`;

CREATE TABLE `biz_role_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 refrp- 前缀',
  `roleUUID` varchar(64) NOT NULL COMMENT '角色UUID',
  `permission` varchar(128) NOT NULL COMMENT '权限组,即biz_permission表中的key',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_role_uuid` (`roleUUID`),
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_permission` (`permission`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_root_cause_analysis
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_root_cause_analysis`;

CREATE TABLE `biz_root_cause_analysis` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 rcal-',
  `extend` json DEFAULT NULL COMMENT '指标信息',
  `funcId` varchar(1024) NOT NULL DEFAULT '' COMMENT 'func对应脚本',
  `status` int(11) NOT NULL DEFAULT '0',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_rule
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_rule`;

CREATE TABLE `biz_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID, rul-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `type` enum('trigger','baseline','aggs','cloud_correlation_switch','logbackup','slo_detect','slo_compute','bot_obs','self_built_trigger') NOT NULL DEFAULT 'trigger',
  `refKey` varchar(48) NOT NULL DEFAULT '' COMMENT '关联key',
  `kapaUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '所属Kapa的UUID',
  `monitorUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '监视器UUID',
  `jsonScript` json DEFAULT NULL COMMENT 'script的JSON数据',
  `tickInfo` json DEFAULT NULL COMMENT '提交后Kapa 返回的Tasks数据',
  `crontabInfo` json DEFAULT NULL COMMENT 'crontab配置信息',
  `extend` json DEFAULT NULL COMMENT '额外配置数据',
  `createdWay` enum('import','template','manual','') NOT NULL DEFAULT 'manual',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_refkey` (`refKey`),
  KEY `k_monitor_uuid` (`monitorUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_rule_history
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_rule_history`;

CREATE TABLE `biz_rule_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 ruleh-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `ruleUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '监控器的uuid',
  `monitorUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '告警策略UUID',
  `type` enum('trigger','aggs','cloud_correlation_switch','logbackup','slo_detect','slo_compute','bot_obs','self_built_trigger') NOT NULL DEFAULT 'trigger',
  `refKey` varchar(48) NOT NULL DEFAULT '',
  `jsonScript` json DEFAULT NULL COMMENT 'script的JSON数据',
  `crontabInfo` json DEFAULT NULL COMMENT 'crontab配置信息',
  `extend` json DEFAULT NULL COMMENT '额外配置数据',
  `createdWay` enum('import','template','manual','') NOT NULL DEFAULT 'manual',
  `status` int(11) NOT NULL DEFAULT '0',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_rule_uuid` (`ruleUUID`),
  KEY `k_refkey_uuid` (`refKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_rum_cfg
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_rum_cfg`;

CREATE TABLE `biz_rum_cfg` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 rum- 前缀',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `appId` varchar(128) NOT NULL DEFAULT '',
  `jsonContent` json NOT NULL COMMENT '额外拓展字段',
  `customIdentity` varchar(48) NOT NULL DEFAULT '' COMMENT '用户自定义标识',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_appid` (`appId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_rum_sourcemap
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_rum_sourcemap`;

CREATE TABLE `biz_rum_sourcemap` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 brsm-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '对应工作空间UUID',
  `appType` varchar(48) DEFAULT '' COMMENT '对应sourcemap的应用类型',
  `fileName` varchar(128) DEFAULT '' COMMENT '上传sourcemap文件名称',
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



# Dump of table biz_saml_mapping
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_saml_mapping`;

CREATE TABLE `biz_saml_mapping` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 fdmp- 前缀',
  `sourceField` varchar(256) NOT NULL DEFAULT '' COMMENT '源字段名',
  `sourceValue` varchar(256) NOT NULL DEFAULT '' COMMENT '源字段值',
  `targetValue` varchar(256) NOT NULL DEFAULT '' COMMENT '目标字段值',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
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
  `rules` json DEFAULT NULL COMMENT '数据访问权限规则',
  `type` varchar(64) NOT NULL DEFAULT 'logging' COMMENT '快照类型',
  `content` json NOT NULL COMMENT '用户自定义配置数据',
  `isPublic` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否公开展示,1代表公开,0代表仅自己可见',
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
  `idpMd5` varchar(48) NOT NULL DEFAULT '' COMMENT 'idp-xml关键信息md5',
  `remark` varchar(512) NOT NULL DEFAULT '' COMMENT '备注',
  `uploadData` text NOT NULL COMMENT '上传数据',
  `workspaceUUID` varchar(64) NOT NULL COMMENT '工作空间 uuid',
  `role` enum('wsAdmin','general','readOnly','') NOT NULL DEFAULT '' COMMENT '用户默认角色',
  `tokenHoldTime` int(11) NOT NULL DEFAULT '1800' COMMENT 'token 保持时长',
  `tokenMaxValidDuration` int(11) NOT NULL DEFAULT '604800' COMMENT 'token 最长的有效期',
  `isOpenSAMLMapping` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否开启SAML 的 Mapping',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  PRIMARY KEY (`id`),
  KEY `idx_uuid` (`uuid`),
  KEY `idx_wpuuid` (`workspaceUUID`),
  KEY `idx_idpMd5` (`idpMd5`)
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



# Dump of table biz_subscribe
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_subscribe`;

CREATE TABLE `biz_subscribe` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 subsc-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间唯一UUID',
  `channelUUID` varchar(48) NOT NULL COMMENT '频道UUID',
  `type` enum('responsible','participate','attention','cancel') NOT NULL DEFAULT 'cancel' COMMENT '订阅类型',
  `targetUUID` varchar(48) NOT NULL COMMENT '订阅者UUID',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `workspaceUUID_fk` (`workspaceUUID`),
  KEY `channelUUID_fk` (`channelUUID`),
  KEY `type_fk` (`type`),
  KEY `targetUUID_fk` (`targetUUID`)
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
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table biz_tasks
# ------------------------------------------------------------

DROP TABLE IF EXISTS `biz_tasks`;

CREATE TABLE `biz_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID, task_',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `accountUUID` varchar(64) NOT NULL DEFAULT '',
  `action` enum('ApplyAdminPermissionApproval','ModifyRp','') NOT NULL DEFAULT '',
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
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_accnt_uuid` (`accountUUID`)
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
  `type` enum('QUERY','CUSTOM_LIST','ALIYUN_INSTANCE','TAG','FIELD','LOGGING','TRACING','RUM','SECURITY') NOT NULL COMMENT '类型',
  `datasource` varchar(48) NOT NULL COMMENT '数据源类型',
  `definition` json DEFAULT NULL COMMENT '解说，原content内容',
  `valueSort` varchar(8) DEFAULT '' COMMENT '视图变量的值排序',
  `content` json DEFAULT NULL COMMENT '变量配置数据',
  `hide` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否隐藏',
  `isHiddenAsterisk` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是隐藏星号',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_dashboard_uuid` (`dashboardUUID`)
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
  `timezone` varchar(48) NOT NULL DEFAULT '' COMMENT '时区',
  `mobile` varchar(128) NOT NULL DEFAULT '' COMMENT '手机号',
  `exterId` varchar(128) NOT NULL DEFAULT '' COMMENT '外部ID',
  `extend` json DEFAULT NULL COMMENT '额外信息',
  `statusPageSubs` tinyint(1) NOT NULL DEFAULT '0' COMMENT '当前站点的 status page 订阅状态, 1已订阅, 0未订阅',
  `nameSpace` varchar(48) NOT NULL DEFAULT '' COMMENT '账号的命名空间',
  `isUsed` tinyint(1) NOT NULL DEFAULT '0' COMMENT '标记账号是否登录过DF系统',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `enableMFA` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否开启MFA认证，默认为0，表示未开启',
  `mfaSecret` varchar(256) NOT NULL DEFAULT '' COMMENT 'MFA密钥，默认为空字符串',
  `language` varchar(48) NOT NULL DEFAULT '',
  `canaryPublic` tinyint(1) DEFAULT '0' COMMENT 'true 为有灰度标志, false为没有',
  `tokenHoldTime` int(11) NOT NULL DEFAULT '1800' COMMENT 'token 保持时长',
  `tokenMaxValidDuration` int(11) NOT NULL DEFAULT '604800' COMMENT 'token 最长的有效期',
  `attributes` json DEFAULT NULL COMMENT '账号属性',
  `createAt` int(11) NOT NULL DEFAULT '-1' COMMENT '创建时间',
  `updateAt` int(11) NOT NULL DEFAULT '-1' COMMENT '更新时间 ',
  `deleteAt` int(11) NOT NULL DEFAULT '-1' COMMENT '删除时间',
  PRIMARY KEY (`id`) COMMENT 'sk 可以存在相同的情况',
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT '全局唯一',
  KEY `uk_username` (`username`) COMMENT 'DF登录用户名加索引',
  KEY `uk_exterid` (`exterId`),
  KEY `uk_namespace` (`nameSpace`),
  KEY `ik_name` (`name`),
  KEY `ik_email` (`email`),
  KEY `ik_mobile` (`mobile`)
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
  `acntWsNickname` varchar(256) NOT NULL DEFAULT '' COMMENT '账号在空间的昵称',
  `workspaceNote` text NOT NULL COMMENT '自定义工作空间备注',
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
  `service` varchar(256) NOT NULL DEFAULT '' COMMENT '服务名',
  `serviceCatelog` text NOT NULL COMMENT '服务清单配置信息',
  `config` json NOT NULL COMMENT 'apm配置参数',
  `color` varchar(128) NOT NULL DEFAULT '' COMMENT '服务颜色配置',
  `status` int(11) NOT NULL DEFAULT '0',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `uk_service` (`service`)
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



# Dump of table main_custom_config
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_custom_config`;

CREATE TABLE `main_custom_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 ctcf-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间 uuid',
  `keyCode` varchar(64) DEFAULT '' COMMENT '标识code',
  `config` json NOT NULL COMMENT 'apm配置参数',
  `status` int(11) NOT NULL DEFAULT '0',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_key_code` (`keyCode`)
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
  `dbType` enum('es','sls','beaver') NOT NULL DEFAULT 'es' COMMENT '存储类型对应的type',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '存储类型的名称',
  `authorization` json NOT NULL COMMENT 'influx 登陆信息',
  `configJSON` json DEFAULT NULL,
  `isParticipateElection` int(1) NOT NULL DEFAULT '0' COMMENT '是否参与选举',
  `wsCount` int(11) NOT NULL DEFAULT '0' COMMENT '关联的工作空间数量',
  `provider` varchar(20) NOT NULL,
  `version` varchar(48) NOT NULL,
  `timeout` varchar(48) DEFAULT '60s' COMMENT '超时时间设置',
  `extend` json DEFAULT NULL,
  `versionType` enum('free','pay','unlimited') DEFAULT 'unlimited' COMMENT '集群类型，free免费用户使用，pay付费用户使用，unlimited没有限制',
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
  `dbType` enum('influxdb','tdengine','guancedb') DEFAULT 'influxdb',
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
  `dbType` enum('influxdb','tdengine','guancedb') NOT NULL DEFAULT 'influxdb' COMMENT '实例的引擎类型',
  `priority` int(11) NOT NULL DEFAULT '50' COMMENT '新建DB时选择实例的依据，默认选择优先级最高的实例创建DB',
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



# Dump of table main_login_mapping
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_login_mapping`;

CREATE TABLE `main_login_mapping` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 lgmp- 前缀',
  `sourceField` varchar(128) NOT NULL DEFAULT '' COMMENT '源字段名',
  `sourceValue` varchar(256) NOT NULL DEFAULT '' COMMENT '源字段值',
  `targetValues` json DEFAULT NULL COMMENT '目标字段值列表',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_source_field` (`sourceField`),
  KEY `k_source_value` (`sourceValue`)
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
  `resetPasswordAt` int(11) NOT NULL DEFAULT '-1' COMMENT '账户成员最新重置密码时间',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `createAt` int(11) NOT NULL DEFAULT '-1' COMMENT '创建时间',
  `updateAt` int(11) NOT NULL DEFAULT '-1' COMMENT '更新时间 ',
  `deleteAt` int(11) NOT NULL DEFAULT '-1' COMMENT '删除时间',
  PRIMARY KEY (`id`) COMMENT 'sk 可以存在相同的情况',
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT '全局唯一',
  KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table main_metric_rp
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_metric_rp`;

CREATE TABLE `main_metric_rp` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀metrp_',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间UUID',
  `dbUUID` varchar(48) NOT NULL COMMENT 'influx/TDengine 对应实例的DB名的uuid(来源不同的uuid, 其前缀不同)',
  `dbName` varchar(48) NOT NULL DEFAULT '' COMMENT 'DB 原始名称',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '指标集名称',
  `duration` varchar(48) NOT NULL DEFAULT '' COMMENT '指标集的数据保留时间，此处单位为小时(d), 例如1d,7d',
  `rpName` varchar(48) NOT NULL COMMENT '数据保留策略名称',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`)
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



# Dump of table main_tdengine_db
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_tdengine_db`;

CREATE TABLE `main_tdengine_db` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 tddb_',
  `db` varchar(48) NOT NULL DEFAULT '' COMMENT 'DB 名称',
  `tdInstanceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT 'instance的UUID',
  `rpName` varchar(48) NOT NULL DEFAULT '' COMMENT '数据保留策略名',
  `status` int(11) NOT NULL COMMENT '状态 0: ok/1: 故障/2: 停用/3: 删除',
  `createAt` int(11) NOT NULL,
  `deleteAt` int(11) DEFAULT NULL,
  `updateAt` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`,`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table main_tdengine_instance
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_tdengine_instance`;

CREATE TABLE `main_tdengine_instance` (
  `id` int(11) NOT NULL,
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 tden_',
  `host` json NOT NULL,
  `Authorization` json NOT NULL,
  `dbcount` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `createAt` int(11) NOT NULL,
  `deleteAt` int(11) NOT NULL,
  `updateAt` int(11) NOT NULL,
  PRIMARY KEY (`id`,`uuid`),
  UNIQUE KEY `uuid_UNIQUE` (`uuid`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table main_workspace
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_workspace`;

CREATE TABLE `main_workspace` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 wksp_',
  `name` varchar(256) DEFAULT NULL,
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
  `datastore` json DEFAULT NULL COMMENT '数据存储信息',
  `esIndexSettings` json DEFAULT NULL COMMENT '索引配置信息',
  `versionType` enum('free','pay','unlimited') NOT NULL DEFAULT 'free' COMMENT 'free表示体验版，pay表示付费版',
  `timezone` varchar(48) NOT NULL DEFAULT '' COMMENT '空间时区',
  `menuStyle` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间菜单风格',
  `billingState` enum('free','unlimited','normal','arrearage','expired') NOT NULL DEFAULT 'free' COMMENT '帐户费用状态',
  `esIndexMerged` tinyint(1) DEFAULT '0' COMMENT '空间ES索引是否合并，默认值是false，不合并',
  `loggingCutSize` int(11) NOT NULL DEFAULT '10240' COMMENT '超大日志切割基础单位,单位:字节byte, SLS 工作空间 默认为 2048byte， ES 工作空间默认为10240byte',
  `supportJsonMessage` tinyint(1) NOT NULL DEFAULT '0' COMMENT '空间是否支持JSON类型的message字段，默认是false，不使用JSON类型的message',
  `isLocked` tinyint(1) NOT NULL DEFAULT '0',
  `lockAt` int(11) NOT NULL DEFAULT '-1',
  `isOpenLogMultipleIndex` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否开启日志多索引配置',
  `makeResourceExceptionCode` varchar(256) NOT NULL DEFAULT '' COMMENT '工作空间开通资源时的异常信息Code',
  `language` varchar(48) NOT NULL DEFAULT 'zh',
  `noviceGuide` tinyint(1) DEFAULT '1' COMMENT 'true 已经有过新手引导, false没有引导过',
  `bossStation` enum('CN','SG','') NOT NULL DEFAULT '' COMMENT '工作空间对应的Boss站点',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `ik_name` (`name`),
  KEY `ik_token` (`token`),
  KEY `ik_clitoken` (`cliToken`),
  KEY `ik_dbuuid` (`dbUUID`),
  KEY `ik_esinstance_uuid` (`esInstanceUUID`),
  KEY `ik_version` (`versionType`),
  KEY `ik_exter_id` (`exterId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table main_workspace_accesskey
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_workspace_accesskey`;

CREATE TABLE `main_workspace_accesskey` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT 'ak 唯一标识 wsak-',
  `name` varchar(512) NOT NULL DEFAULT '' COMMENT 'AK 名称',
  `ak` varchar(128) DEFAULT NULL,
  `sk` varchar(128) NOT NULL DEFAULT '' COMMENT 'Secret Key',
  `workspaceUUID` varchar(64) NOT NULL DEFAULT '' COMMENT '工作空间 uuid',
  `businessType` varchar(64) NOT NULL DEFAULT '' COMMENT '对应ak业务类型信息',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: 正常/2: 禁用/3: 删除',
  `createAt` int(11) NOT NULL DEFAULT '-1' COMMENT '创建时间',
  `updateAt` int(11) NOT NULL DEFAULT '-1' COMMENT '更新时间 ',
  `deleteAt` int(11) NOT NULL DEFAULT '-1' COMMENT '删除时间',
  PRIMARY KEY (`id`) COMMENT 'sk 可以存在相同的情况',
  UNIQUE KEY `uuid_UNIQUE` (`uuid`),
  UNIQUE KEY `unique_ak` (`ak`),
  KEY `idx_ak` (`ak`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table main_workspace_config
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_workspace_config`;

CREATE TABLE `main_workspace_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一 ID 前缀 wkcfg-',
  `workspaceUUID` varchar(48) NOT NULL DEFAULT '' COMMENT '工作空间 uuid',
  `keyCode` enum('StoreSchemeCfg','UsageLimit','WsMenuCfg','WhileList','expensiveQuery','logMultipleIndexCount','BeaverStoreCfg') NOT NULL DEFAULT 'StoreSchemeCfg',
  `config` json NOT NULL COMMENT '配置信息',
  `status` int(11) NOT NULL DEFAULT '0',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `deleteAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `k_ws_uuid` (`workspaceUUID`),
  KEY `k_key_code` (`keyCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table main_workspace_grant
# ------------------------------------------------------------

DROP TABLE IF EXISTS `main_workspace_grant`;

CREATE TABLE `main_workspace_grant` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT 'grant-',
  `workspaceUUID` varchar(64) NOT NULL DEFAULT '' COMMENT '工作空间 uuid',
  `toWorkspaceUUID` varchar(64) NOT NULL DEFAULT '' COMMENT '被授予权限的工作空间 uuid',
  `regionCode` varchar(128) NOT NULL DEFAULT '' COMMENT '授权的的站点信息',
  `toRegionCode` varchar(128) NOT NULL DEFAULT '' COMMENT '被授权的的站点信息',
  `workspaceName` varchar(256) NOT NULL DEFAULT '' COMMENT '授权的空间名称',
  `toWorkspaceName` varchar(256) NOT NULL DEFAULT '' COMMENT '被授权的空间名称',
  `expireAt` int(11) NOT NULL DEFAULT '-1' COMMENT '过期时间',
  `creator` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者 account-id',
  `updator` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者 account-id',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态 0: 正常/2: 禁用/3: 删除',
  `createAt` int(11) NOT NULL DEFAULT '-1' COMMENT '创建时间',
  `updateAt` int(11) NOT NULL DEFAULT '-1' COMMENT '更新时间 ',
  `deleteAt` int(11) NOT NULL DEFAULT '-1' COMMENT '删除时间',
  PRIMARY KEY (`id`) COMMENT '主键',
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  KEY `idx_workspaceUUID` (`workspaceUUID`) COMMENT '授权的工作空间UUID',
  KEY `idx_toWorkspaceUUID` (`toWorkspaceUUID`) COMMENT '被授予权限的工作空间UUID'
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
