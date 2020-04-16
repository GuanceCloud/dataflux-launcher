-- -------------------------------------------------------------
-- TablePlus 3.1.2(296)
--
-- https://tableplus.com/
--
-- Database: ft_data_processor
-- Generation Time: 2020-03-23 17:54:14.3140
-- -------------------------------------------------------------


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


DROP TABLE IF EXISTS `biz_cache_df_workspace`;
CREATE TABLE `biz_cache_df_workspace` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `uuid` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'UUID',
  `wsName` varchar(256) DEFAULT NULL COMMENT '名称',
  `dataJSON` json NOT NULL COMMENT '数据JSON',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `BIZ` (`id`),
  UNIQUE KEY `UUID` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='DataFlux工作空间（缓存）';

DROP TABLE IF EXISTS `biz_main_auth_link`;
CREATE TABLE `biz_main_auth_link` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '兼任Token',
  `scriptSetId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '脚本集ID',
  `scriptId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '脚本ID',
  `funcId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '函数ID',
  `funcKwargsJSON` json NOT NULL COMMENT '函数参数JSON (kwargs)',
  `expireTime` datetime DEFAULT NULL COMMENT '过期时间（NULL表示永不过期）',
  `throttlingJSON` json DEFAULT NULL COMMENT '限流JSON（value="<From Parameter>"表示从参数获取）',
  `origin` varchar(64) NOT NULL DEFAULT 'api' COMMENT '来源 api|ui',
  `showInDoc` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否在文档中显示',
  `isDisabled` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否禁用',
  `note` text COMMENT '备注',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  KEY `ORIGIN` (`origin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='授权链接';

DROP TABLE IF EXISTS `biz_main_crontab_config`;
CREATE TABLE `biz_main_crontab_config` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `scriptSetId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '脚本集ID',
  `scriptId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '脚本ID',
  `funcId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '函数ID',
  `funcKwargsJSON` json NOT NULL COMMENT '函数参数JSON (kwargs)',
  `crontab` varchar(64) DEFAULT NULL COMMENT '执行频率（Crontab语法）',
  `tagsJSON` json DEFAULT NULL COMMENT '自动触发配置标签JSON',
  `saveResult` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否需要保存结果',
  `configHash` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '配置哈希',
  `origin` varchar(64) NOT NULL DEFAULT 'api' COMMENT '来源 api|ui',
  `isDisabled` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已禁用',
  `note` text COMMENT '备注',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  UNIQUE KEY `CONFIG_HASH` (`configHash`),
  KEY `ORIGIN` (`origin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='自动触发配置';

DROP TABLE IF EXISTS `biz_main_data_source`;
CREATE TABLE `biz_main_data_source` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `title` varchar(256) DEFAULT NULL COMMENT '标题',
  `description` text COMMENT '描述',
  `refName` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '引用名',
  `type` varchar(64) NOT NULL COMMENT '类型 influxdb|mysql|redis|..',
  `configJSON` json NOT NULL COMMENT '配置JSON',
  `isBuiltin` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为内建数据源',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  UNIQUE KEY `BIZ` (`refName`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='数据源';

DROP TABLE IF EXISTS `biz_main_env_variable`;
CREATE TABLE `biz_main_env_variable` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `title` varchar(256) DEFAULT NULL COMMENT '标题',
  `description` text COMMENT '描述',
  `refName` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '引用名',
  `valueTEXT` text NOT NULL COMMENT '值',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  UNIQUE KEY `BIZ` (`refName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='环境变量';

DROP TABLE IF EXISTS `biz_main_func`;
CREATE TABLE `biz_main_func` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `title` varchar(256) DEFAULT NULL COMMENT '标题',
  `description` text COMMENT '描述（函数文档）',
  `scriptSetId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '所属脚本集ID',
  `scriptId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '所属脚本ID',
  `refName` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '引用名（函数名）',
  `definition` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '定义（函数签名）',
  `argsJSON` json DEFAULT NULL COMMENT '位置参数JSON',
  `kwargsJSON` json DEFAULT NULL COMMENT '命名参数JSON',
  `extraConfigJSON` json DEFAULT NULL COMMENT '函数额外配置JSON',
  `category` varchar(64) NOT NULL DEFAULT 'general' COMMENT '类别 general|prediction|transformation|action|command|query|check',
  `tagsJSON` json DEFAULT NULL COMMENT '函数标签JSON',
  `defOrder` int(11) NOT NULL DEFAULT '0' COMMENT '定义顺序',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  UNIQUE KEY `BIZ` (`scriptId`,`refName`),
  KEY `REF_NAME` (`refName`),
  KEY `CATEGORY` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COMMENT='函数';

DROP TABLE IF EXISTS `biz_main_func_store`;
CREATE TABLE `biz_main_func_store` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `key` varchar(256) NOT NULL COMMENT '键名',
  `valueJSON` json NOT NULL COMMENT '值JSON',
  `scope` varchar(64) NOT NULL COMMENT '范围',
  `expireAt` int(11) DEFAULT NULL COMMENT '过期时间（秒级UNIX时间戳）',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  UNIQUE KEY `BIZ` (`scope`,`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='函数存储';

DROP TABLE IF EXISTS `biz_main_script`;
CREATE TABLE `biz_main_script` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `title` varchar(256) DEFAULT NULL COMMENT '标题',
  `description` text COMMENT '描述',
  `scriptSetId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '所属脚本集ID',
  `refName` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '引用名',
  `publishVersion` bigint(20) NOT NULL DEFAULT '0' COMMENT '发布版本',
  `code` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT '代码',
  `codeMD5` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '代码MD5',
  `codeDraft` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT '代码（编辑中草稿）',
  `codeDraftMD5` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '代码（编辑中草稿）MD5',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  UNIQUE KEY `BIZ` (`scriptSetId`,`refName`),
  FULLTEXT KEY `FT` (`refName`,`code`,`codeDraft`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='脚本';

DROP TABLE IF EXISTS `biz_main_script_failure`;
CREATE TABLE `biz_main_script_failure` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `scriptSetId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '脚本集ID',
  `scriptId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '脚本ID',
  `scriptPublishVersion` bigint(20) NOT NULL COMMENT '脚本发布版本',
  `funcId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '函数ID',
  `execMode` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '执行模式 sync|async|crontab',
  `einfoTEXT` text COMMENT '错误信息',
  `exception` varchar(64) DEFAULT NULL COMMENT '异常',
  `traceInfoJSON` json DEFAULT NULL COMMENT '跟踪信息JSON',
  `note` text COMMENT '备注',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  KEY `ENTRY` (`scriptId`,`scriptPublishVersion`,`funcId`),
  KEY `CREATE_TIME` (`createTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='脚本故障信息';

DROP TABLE IF EXISTS `biz_main_script_log`;
CREATE TABLE `biz_main_script_log` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `scriptSetId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '脚本集ID',
  `scriptId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '脚本ID',
  `scriptPublishVersion` bigint(20) NOT NULL COMMENT '脚本发布版本',
  `funcId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '函数ID',
  `execMode` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '执行模式 sync|async|crontab',
  `messageTEXT` text COMMENT '错误信息',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  KEY `ENTRY` (`scriptId`,`scriptPublishVersion`,`funcId`),
  KEY `CREATE_TIME` (`createTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='脚本日志信息';

DROP TABLE IF EXISTS `biz_main_script_publish_history`;
CREATE TABLE `biz_main_script_publish_history` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `scriptSetId` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '脚本集ID',
  `scriptId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '脚本ID',
  `scriptPublishVersion` bigint(20) NOT NULL COMMENT '脚本发布版本',
  `scriptCode_cache` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '脚本代码（缓存字段）',
  `note` text COMMENT '发布备注',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  UNIQUE KEY `BIZ` (`scriptId`,`scriptPublishVersion`),
  FULLTEXT KEY `FT` (`scriptCode_cache`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='脚本发布历史';

DROP TABLE IF EXISTS `biz_main_script_recover_point`;
CREATE TABLE `biz_main_script_recover_point` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `type` varchar(64) NOT NULL COMMENT '类型 publish|import|manual',
  `tableDumpJSON` json NOT NULL COMMENT '表备份数据JSON',
  `note` text COMMENT '备注',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='脚本还原点';

DROP TABLE IF EXISTS `biz_main_script_set`;
CREATE TABLE `biz_main_script_set` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `title` varchar(256) DEFAULT NULL COMMENT '标题',
  `description` text COMMENT '描述',
  `refName` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '引用名',
  `type` varchar(64) NOT NULL DEFAULT 'user' COMMENT '类型 user|official',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  UNIQUE KEY `BIZ` (`refName`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COMMENT='脚本集';

DROP TABLE IF EXISTS `biz_main_script_set_export_history`;
CREATE TABLE `biz_main_script_set_export_history` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `importToken` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '导入令牌',
  `exportType` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '导出类型 user|official',
  `operatorName` text COMMENT '操作人',
  `operationNote` text COMMENT '操作备注',
  `summaryJSON` json NOT NULL COMMENT '导出摘要JSON',
  `fileBLOB` blob NOT NULL COMMENT '文件BLOB',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='导出历史';

DROP TABLE IF EXISTS `biz_main_script_set_import_history`;
CREATE TABLE `biz_main_script_set_import_history` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `importType` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '导入类型 user|official',
  `operationNote` text COMMENT '操作备注',
  `summaryJSON` json NOT NULL COMMENT '导出摘要JSON',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='导出历史';

DROP TABLE IF EXISTS `biz_main_task_result_data_processor`;
CREATE TABLE `biz_main_task_result_data_processor` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `task` varchar(128) NOT NULL,
  `origin` varchar(128) DEFAULT NULL,
  `startTime` int(11) DEFAULT NULL COMMENT '任务开始时间(秒级UNIX时间戳)',
  `endTime` int(11) DEFAULT NULL COMMENT '任务结束时间(秒级UNIX时间戳)',
  `argsJSON` json DEFAULT NULL COMMENT '列表参数JSON',
  `kwargsJSON` json DEFAULT NULL COMMENT '字典参数JSON',
  `retvalJSON` json DEFAULT NULL COMMENT '执行结果JSON',
  `status` varchar(64) NOT NULL COMMENT '任务状态: SUCCESS|FAILURE',
  `einfoTEXT` text COMMENT '错误信息TEXT',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  KEY `TASK` (`task`),
  KEY `ORIGIN` (`origin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='FTDataProcessor 任务结果';

DROP TABLE IF EXISTS `biz_rel_func_df_workspace`;
CREATE TABLE `biz_rel_func_df_workspace` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `funcId` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '函数ID',
  `dfWorkspaceUUID` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'DataFlux 工作空间 UUID',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `BIZ` (`funcId`,`dfWorkspaceUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='函数-DataFlux工作空间关联';

DROP TABLE IF EXISTS `biz_rel_script_running_info`;
CREATE TABLE `biz_rel_script_running_info` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `scriptSetId` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '脚本集ID',
  `scriptId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '脚本ID',
  `funcId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '函数ID',
  `execMode` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '执行模式 sync|async|crontab',
  `succeedCount` int(11) NOT NULL DEFAULT '0' COMMENT '成功次数',
  `failCount` int(11) NOT NULL DEFAULT '0' COMMENT '失败次数',
  `minCost` int(11) DEFAULT NULL COMMENT '最小耗时（毫秒）',
  `maxCost` int(11) DEFAULT NULL COMMENT '最大耗时（毫秒）',
  `totalCost` bigint(11) DEFAULT NULL COMMENT '累积耗时（毫秒）',
  `latestCost` int(11) DEFAULT NULL COMMENT '最近消耗（毫秒）',
  `latestSucceedTime` timestamp NULL DEFAULT NULL COMMENT '最近成功时间',
  `latestFailTime` timestamp NULL DEFAULT NULL COMMENT '最近失败时间',
  `status` varchar(64) NOT NULL DEFAULT 'neverStarted' COMMENT '状态 neverStarted|succeed|fail|timeout',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `BIZ` (`scriptSetId`,`scriptId`,`funcId`,`execMode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='脚本执行信息';

DROP TABLE IF EXISTS `wat_main_access_key`;
CREATE TABLE `wat_main_access_key` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `organizationId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `userId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `name` varchar(256) NOT NULL,
  `secret` varchar(64) NOT NULL,
  `webhookURL` text,
  `webhookEvents` text,
  `allowWebhookEcho` tinyint(1) NOT NULL DEFAULT '0',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  KEY `ORGANIZATION_ID` (`organizationId`),
  KEY `USER_ID` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `wat_main_file`;
CREATE TABLE `wat_main_file` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `organizationId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `userId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `originalFileName` text,
  `md5Sum` char(32) DEFAULT NULL,
  `byteSize` int(11) DEFAULT NULL,
  `note` text,
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  KEY `ORGANIZATION_ID` (`organizationId`),
  KEY `USER_ID` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `wat_main_organization`;
CREATE TABLE `wat_main_organization` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `uniqueId` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `name` varchar(256) NOT NULL,
  `markers` text,
  `isDisabled` tinyint(1) NOT NULL DEFAULT '0',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  UNIQUE KEY `UNIQUE_ID` (`uniqueId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `wat_main_post`;
CREATE TABLE `wat_main_post` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `organizationId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `userId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `title` varchar(256) NOT NULL,
  `content` text,
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  KEY `ORGANIZATION_ID` (`organizationId`),
  KEY `USER_ID` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `wat_main_system_config`;
CREATE TABLE `wat_main_system_config` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '值',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `wat_main_task_result_example`;
CREATE TABLE `wat_main_task_result_example` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `task` varchar(128) NOT NULL,
  `origin` varchar(128) DEFAULT NULL,
  `startTime` int(11) DEFAULT NULL,
  `endTime` int(11) DEFAULT NULL,
  `argsJSON` text,
  `kwargsJSON` text,
  `retvalJSON` text,
  `status` varchar(64) NOT NULL,
  `einfoTEXT` text,
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  KEY `TASK` (`task`),
  KEY `ORIGIN` (`origin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `wat_main_user`;
CREATE TABLE `wat_main_user` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `organizationId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `username` varchar(64) NOT NULL,
  `passwordHash` text,
  `name` varchar(256) DEFAULT NULL,
  `mobile` varchar(32) DEFAULT NULL,
  `markers` text,
  `roles` text,
  `customPrivileges` text,
  `isDisabled` tinyint(1) NOT NULL DEFAULT '0',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  UNIQUE KEY `USERNAME` (`username`),
  KEY `ORGANIZATION_ID` (`organizationId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `wat_ref_tag`;
CREATE TABLE `wat_ref_tag` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `entityId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `entityName` varchar(64) NOT NULL,
  `tagK` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `tagV` text,
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `TAG` (`entityId`,`tagK`),
  KEY `ENTITY_ID` (`entityId`),
  KEY `TAG_K` (`tagK`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `biz_main_data_source` (`seq`, `id`, `title`, `description`, `refName`, `type`, `configJSON`, `isBuiltin`, `createTime`, `updateTime`) VALUES
('1', 'dsrc-demo_influxdb', '示例InfluxDB', '一个用于演示的InfluxDB', 'demo_influxdb', 'influxdb', '{\"host\": \"127.0.0.1\", \"port\": 8086, \"user\": null, \"charset\": null, \"database\": \"demo\", \"password\": null}', '0', '2019-12-09 15:30:11', '2020-02-26 00:57:15'),
('2', 'dsrc-demo_mysql', '示例MySQL', '一个用于演示的MySQL', 'demo_mysql', 'mysql', '{\"host\": \"127.0.0.1\", \"port\": 3306, \"user\": \"dev\", \"charset\": \"utf8mb4\", \"database\": \"demo\", \"password\": \"dev\"}', '0', '2019-12-09 15:33:02', '2020-02-26 00:57:18'),
('3', 'dsrc-demo_redis', '示例Redis', '一个用于演示的Redis', 'demo_redis', 'redis', '{\"host\": \"127.0.0.1\", \"port\": 6379, \"database\": \"15\", \"password\": null}', '0', '2019-12-09 15:33:57', '2020-02-26 00:57:22'),
('4', 'dsrc-demo_clickhouse', '示例ClickHouse', '一个用于演示的ClickHouse', 'demo_clickhouse', 'clickhouse', '{\"host\": \"127.0.0.1\", \"port\": 9000, \"user\": \"default\", \"database\": \"demo\", \"passwordCipher\": \"sfbR0odZIw5oYEudbhc6lw==\"}', '0', '2020-02-25 15:58:55', '2020-02-26 00:57:27');

INSERT INTO `biz_main_func` (`seq`, `id`, `title`, `description`, `scriptSetId`, `scriptId`, `refName`, `definition`, `argsJSON`, `kwargsJSON`, `extraConfigJSON`, `category`, `tagsJSON`, `defOrder`, `createTime`, `updateTime`) VALUES
('1', 'func-nWTzXJzPtpVJEY9QiPL4y3', 'Hello, world!', '一个最简单的示例，直接返回\"Hello, world!\"字符串', 'sset-demo', 'scpt-demo', 'hello_world', 'hello_world()', '[]', '{}', NULL, 'general', NULL, '0', '2020-03-05 12:25:36', '2020-03-05 12:25:36'),
('2', 'func-kBQ2ANTg79pehd6qCjHdEE', '问候', '一个简单的带参数示例，返回JSON', 'sset-demo', 'scpt-demo', 'greeting', 'greeting(your_name)', '[\"your_name\"]', '{\"your_name\": null}', NULL, 'general', NULL, '1', '2020-03-05 12:25:36', '2020-03-05 12:25:36'),
('3', 'func-res7t9X5WR3nLiMhk35RWC', 'InfluxDB操作演示', '本函数从数据源`demo_influxdb`中查询3条`demo`指标并返回', 'sset-demo', 'scpt-demo', 'influxdb_demo', 'influxdb_demo()', '[]', '{}', NULL, 'general', NULL, '2', '2020-03-05 12:25:36', '2020-03-05 12:25:36'),
('4', 'func-kiFSXSPnqdbTjkNMABzKe', 'MySQL操作演示', '本函数从数据源`demo_mysql`中查询`demo`表数据并返回', 'sset-demo', 'scpt-demo', 'mysql_demo', 'mysql_demo()', '[]', '{}', NULL, 'general', NULL, '3', '2020-03-05 12:25:36', '2020-03-05 12:25:36'),
('5', 'func-VFhYxCbCLo4xEBLrUGGV8g', 'Redis操作演示', '本函数对数据源`demo_redis`中的`demo`键进行加一计数\n并返回当前`demo`键的值', 'sset-demo', 'scpt-demo', 'redis_demo', 'redis_demo()', '[]', '{}', NULL, 'general', NULL, '4', '2020-03-05 12:25:36', '2020-03-05 12:25:36'),
('6', 'func-BtEZPB5xQGFpEvZAnpqeZY', 'ClickHouse操作演示', '本函数从数据源`demo_clickhouse`中查询`demo_table`表数据并返回', 'sset-demo', 'scpt-demo', 'clickhouse_demo', 'clickhouse_demo()', '[]', '{}', NULL, 'general', NULL, '5', '2020-03-05 12:25:36', '2020-03-05 12:25:36'),
('7', 'func-Q4gKsywduZBWgrkV7eQiJL', '内置DataFlux Dataway操作演示', '本函数对数据源`df_dataway`添加一个数据点，并返回是否成功', 'sset-demo', 'scpt-demo', 'df_dataway_demo', 'df_dataway_demo()', '[]', '{}', NULL, 'general', NULL, '6', '2020-03-05 12:25:36', '2020-03-05 12:25:36'),
('8', 'func-WmsMjxrBesLPNTFpMoLWUe', '平均值预测', '一个对时序数据进行平均值预测\n参数：\n    dps【必须】: [ , ... ]\n返回：\n    [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]', 'sset-ft_lib', 'scpt-ft_pred', 'avg_prediction', 'avg_prediction(dps)', '[\"dps\"]', '{\"dps\": null}', NULL, 'prediction', NULL, '0', '2020-03-05 12:25:43', '2020-03-05 12:25:43'),
('9', 'func-kNQM6frnawiKyvRxxTwLLc', '移动均值预测', '一个对时序数据进行平均值预测\n参数：\n    dps【必须】: [ , ... ]\n返回：\n    [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]', 'sset-ft_lib', 'scpt-ft_pred', 'moving_prediction', 'moving_prediction(dps)', '[\"dps\"]', '{\"dps\": null}', NULL, 'prediction', NULL, '1', '2020-03-05 12:25:43', '2020-03-05 12:25:43'),
('10', 'func-tdsfTorGHBHGqX2DypkbJn', 'Holt函数预测', '一个对时序数据进行平均值预测\n参数：\n    dps【必须】: [ , ... ]\n返回：\n    [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]', 'sset-ft_lib', 'scpt-ft_pred', 'holt_prediction', 'holt_prediction(dps)', '[\"dps\"]', '{\"dps\": null}', NULL, 'prediction', NULL, '2', '2020-03-05 12:25:43', '2020-03-05 12:25:43'),
('11', 'func-gggLctbayAhMhB72XJEXG6', 'MA函数预测', NULL, 'sset-ft_lib', 'scpt-ft_pred', 'ma_prediction', 'ma_prediction(dps)', '[\"dps\"]', '{\"dps\": null}', NULL, 'prediction', NULL, '3', '2020-03-05 12:25:43', '2020-03-05 12:25:43'),
('12', 'func-W4avvcyk5PzKQoyPn2dJAR', 'AR函数预测', NULL, 'sset-ft_lib', 'scpt-ft_pred', 'ar_prediction', 'ar_prediction(dps)', '[\"dps\"]', '{\"dps\": null}', NULL, 'prediction', NULL, '4', '2020-03-05 12:25:43', '2020-03-05 12:25:43'),
('13', 'func-SJ4T2jPvowQGDdayDNbMyP', 'ARIMA函数预测', NULL, 'sset-ft_lib', 'scpt-ft_pred', 'arima_prediction', 'arima_prediction(dps)', '[\"dps\"]', '{\"dps\": null}', NULL, 'prediction', NULL, '5', '2020-03-05 12:25:43', '2020-03-05 12:25:43'),
('14', 'func-yeJoDBaWFqUN4cXRiRJHhL', 'ABS绝对值转换', '返回数字的绝对值。\n参数：\n    dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]', 'sset-ft_lib', 'scpt-ft_tran', 'abs_transformation', 'abs_transformation(dps)', '[\"dps\"]', '{\"dps\": null}', NULL, 'transformation', NULL, '0', '2020-03-05 12:25:51', '2020-03-05 12:25:51'),
('15', 'func-PnKuMRJCezk2wPn9a39Xt9', 'AVG平均值转换', '返回数字的平均值。\n参数：\n    dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]', 'sset-ft_lib', 'scpt-ft_tran', 'avg_transformation', 'avg_transformation(dps)', '[\"dps\"]', '{\"dps\": null}', NULL, 'transformation', NULL, '1', '2020-03-05 12:25:51', '2020-03-05 12:25:51'),
('16', 'func-SqugQfs7eAZrb3Y7HFr7A8', 'MAX最大值转换', '返回数字的最大值。\n参数：\n    dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]', 'sset-ft_lib', 'scpt-ft_tran', 'max_transformation', 'max_transformation(dps)', '[\"dps\"]', '{\"dps\": null}', NULL, 'transformation', NULL, '2', '2020-03-05 12:25:51', '2020-03-05 12:25:51'),
('17', 'func-BQbZ5hymZyngZQz2bVrgJP', 'MIN最小值转换', '返回数字的最小值。\n参数：\n    dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]', 'sset-ft_lib', 'scpt-ft_tran', 'min_transformation', 'min_transformation(dps)', '[\"dps\"]', '{\"dps\": null}', NULL, 'transformation', NULL, '3', '2020-03-05 12:25:51', '2020-03-05 12:25:51'),
('18', 'func-mF3Tpm5k2dpSJMJMPH4kQn', 'Even向上取偶数转换', '将数字向上舍入为最接近的偶数。\n参数：\n    dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]', 'sset-ft_lib', 'scpt-ft_tran', 'even_transformation', 'even_transformation(dps)', '[\"dps\"]', '{\"dps\": null}', NULL, 'transformation', NULL, '4', '2020-03-05 12:25:51', '2020-03-05 12:25:51'),
('19', 'func-xFhi3RpAVn8ADmRigdC3b4', 'Odd向上取奇数转换', '将数字向上舍入为最接近的奇数。\n参数：\n    dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]', 'sset-ft_lib', 'scpt-ft_tran', 'odd_transformation', 'odd_transformation(dps)', '[\"dps\"]', '{\"dps\": null}', NULL, 'transformation', NULL, '5', '2020-03-05 12:25:51', '2020-03-05 12:25:51'),
('20', 'func-guZeCRgvaGrKCMe3bAavBT', 'Fact取整阶乘转换', '返回数字的阶乘。\n参数：\n    dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]', 'sset-ft_lib', 'scpt-ft_tran', 'fact_transformation', 'fact_transformation(dps)', '[\"dps\"]', '{\"dps\": null}', NULL, 'transformation', NULL, '6', '2020-03-05 12:25:51', '2020-03-05 12:25:51'),
('21', 'func-6RcmqQ6LWBzJALR5mN43JX', 'SumSQ平方和转换', '返回数字的平方和。\n参数：\n    dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]', 'sset-ft_lib', 'scpt-ft_tran', 'sumsq_transformation', 'sumsq_transformation(dps)', '[\"dps\"]', '{\"dps\": null}', NULL, 'transformation', NULL, '7', '2020-03-05 12:25:51', '2020-03-05 12:25:51'),
('22', 'func-3KfGMDXCiLqtYikoYMqtQT', 'RoundUp绝对值增大取整转换', '向绝对值增大的方向舍入数字。\n参数：\n   dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]', 'sset-ft_lib', 'scpt-ft_tran', 'roundup_transformation', 'roundup_transformation(dps)', '[\"dps\"]', '{\"dps\": null}', NULL, 'transformation', NULL, '8', '2020-03-05 12:25:51', '2020-03-05 12:25:51'),
('23', 'func-DJ4Z77G3z6Ghjz6tCRMk4d', 'RoundDown绝对值减小取整转换', '向绝对值减小的方向舍入数字。\n参数：\n  dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]', 'sset-ft_lib', 'scpt-ft_tran', 'rounddown_transformation', 'rounddown_transformation(dps)', '[\"dps\"]', '{\"dps\": null}', NULL, 'transformation', NULL, '9', '2020-03-05 12:25:51', '2020-03-05 12:25:51'),
('24', 'func-3W2y4ADKnQMAxyhUmjxcpn', 'Power指数幂转换', '返回给定次幂的结果。\n参数：\n dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n significance:指定指数', 'sset-ft_lib', 'scpt-ft_tran', 'power_transformation', 'power_transformation(dps, significance)', '[\"dps\", \"significance\"]', '{\"dps\": null, \"significance\": null}', NULL, 'transformation', NULL, '10', '2020-03-05 12:25:51', '2020-03-05 12:25:51'),
('25', 'func-8UcWPvd4AC35bybJKCdTAH', 'Ceiling取整转换', '将数字四舍五入为最接近的整数或最接近的指定基数的倍数。\n参数：\n    dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    significance:指定基数的倍数', 'sset-ft_lib', 'scpt-ft_tran', 'ceiling_transformation', 'ceiling_transformation(dps, significance)', '[\"dps\", \"significance\"]', '{\"dps\": null, \"significance\": null}', NULL, 'transformation', NULL, '11', '2020-03-05 12:25:51', '2020-03-05 12:25:51'),
('26', 'func-mSakGXLnC58wm82y7mDeBB', 'AccumuAll累加转换', '将前n个元素累加求和。\n参数：\n    dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]', 'sset-ft_lib', 'scpt-ft_tran', 'accumuall_transformation', 'accumuall_transformation(dps)', '[\"dps\"]', '{\"dps\": null}', NULL, 'transformation', NULL, '12', '2020-03-05 12:25:51', '2020-03-05 12:25:51'),
('27', 'func-ppeJAW8CAQFQBJtvRuxTJG', 'Accumu2求和转换', '将每相邻2个元素累加求和。\n参数：\n    dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]', 'sset-ft_lib', 'scpt-ft_tran', 'accumu2_transformation', 'accumu2_transformation(dps)', '[\"dps\"]', '{\"dps\": null}', NULL, 'transformation', NULL, '13', '2020-03-05 12:25:51', '2020-03-05 12:25:51'),
('28', 'func-o7YnpcRJCcTN2tEiBkMZ8F', 'ACOSH反双曲余弦转换', '返回数字的反双曲余弦值。\n参数：\n    dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]', 'sset-ft_lib', 'scpt-ft_tran', 'acosh_transformation', 'acosh_transformation(dps)', '[\"dps\"]', '{\"dps\": null}', NULL, 'transformation', NULL, '14', '2020-03-05 12:25:51', '2020-03-05 12:25:51'),
('29', 'func-SWvP6bzYLCvu2YoCsbvA5U', 'Clean删除不可打印字符', '从文本中删除不可打印的字符，去掉了前31个特殊的ASCII字符。\n参数：\n    dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]', 'sset-ft_lib', 'scpt-ft_tran_str', 'clean_transformation', 'clean_transformation(dps)', '[\"dps\"]', '{\"dps\": null}', NULL, 'transformation', NULL, '0', '2020-03-05 12:25:58', '2020-03-05 12:25:58'),
('30', 'func-CARHseV33FfsjSY8oXZkP4', 'Fixed数字格式化', '将数字格式设置为具有固定小数位数。\n参数：\n    dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    decimals:进行四舍五入后小数点后面需要保留的位数,如果是负数，则在小数点左侧进行四舍五入。若此参数                         decimals省略，则默认此参数为2。\n    no_commas:如果是 true，返回的结果不包含逗号千分位。如果是false或省略不写，返回的结果包含逗号千分位。', 'sset-ft_lib', 'scpt-ft_tran_str', 'fixed_transformation', 'fixed_transformation(dps, no_commas=\'True\', decimals=2)', '[\"dps\", \"no_commas\", \"decimals\"]', '{\"dps\": null, \"decimals\": null, \"no_commas\": null}', NULL, 'transformation', NULL, '1', '2020-03-05 12:25:58', '2020-03-05 12:25:58'),
('31', 'func-V7UtvTq2hMpqD4q5m8iCjH', 'Left截取左边字符', '返回文本值中最左边的字符。\n参数：\n    dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    num_chars:需要截取字符的个数。默认截取1个', 'sset-ft_lib', 'scpt-ft_tran_str', 'left_transformation', 'left_transformation(dps, num_chars=1)', '[\"dps\", \"num_chars\"]', '{\"dps\": null, \"num_chars\": null}', NULL, 'transformation', NULL, '2', '2020-03-05 12:25:58', '2020-03-05 12:25:58'),
('32', 'func-eaYrA9wLeJLZPuvjaB5Tjd', 'Right截取右边字符', '返回文本值中最右边的字符。\n参数：\n    dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    num_chars:需要截取字符的个数。默认截取1个', 'sset-ft_lib', 'scpt-ft_tran_str', 'right_transformation', 'right_transformation(dps, num_chars=None)', '[\"dps\", \"num_chars\"]', '{\"dps\": null, \"num_chars\": null}', NULL, 'transformation', NULL, '3', '2020-03-05 12:25:58', '2020-03-05 12:25:58'),
('33', 'func-svkUj2CTi7mPMQogfGvTBB', 'LEN字符串长度', '返回文本字符串中的字符数。\n参数：\n    dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]', 'sset-ft_lib', 'scpt-ft_tran_str', 'len_transformation', 'len_transformation(dps)', '[\"dps\"]', '{\"dps\": null}', NULL, 'transformation', NULL, '4', '2020-03-05 12:25:58', '2020-03-05 12:25:58'),
('34', 'func-XtQ7cZsvRqEtKj34JHHDTc', 'Lower字符小写转换', '将文本转换为小写。\n参数：\n    dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]', 'sset-ft_lib', 'scpt-ft_tran_str', 'lower_transformation', 'lower_transformation(dps)', '[\"dps\"]', '{\"dps\": null}', NULL, 'transformation', NULL, '5', '2020-03-05 12:25:58', '2020-03-05 12:25:58'),
('35', 'func-PSq9c97zudhPzkHhkXdpRi', 'MID截取字符', '在文本字符串中,从您所指定的位置开始返回特定数量的字符。\n参数：\n   dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n   start_num:从左侧第几位开始截取。\n   num_chars:需要截取字符的个数。默认截取1个。', 'sset-ft_lib', 'scpt-ft_tran_str', 'mid_transformation', 'mid_transformation(dps, start_num=1, num_chars=1)', '[\"dps\", \"start_num\", \"num_chars\"]', '{\"dps\": null, \"num_chars\": null, \"start_num\": null}', NULL, 'transformation', NULL, '6', '2020-03-05 12:25:58', '2020-03-05 12:25:58'),
('36', 'func-G6x4PKF2HUKpBHXR2iCUN6', 'PROPER首字母转大写', '将字符串的首字母转为大写，其余变为小写规范化输出\n参数：\n    dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    sep【默认是空格】：要转换的文本的切分符', 'sset-ft_lib', 'scpt-ft_tran_str', 'proper_transformation', 'proper_transformation(dps, sep=None)', '[\"dps\", \"sep\"]', '{\"dps\": null, \"sep\": null}', NULL, 'transformation', NULL, '7', '2020-03-05 12:25:58', '2020-03-05 12:25:58'),
('37', 'func-tuyhhfeRrvjPPdtWyeVxjg', 'REPLACE替换目标字符', '替换字符串中的目标字符\n参数：\n    dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    target：被替换的字符\n    replace:要替换的字符', 'sset-ft_lib', 'scpt-ft_tran_str', 'replace_transformation', 'replace_transformation(dps, target, replace)', '[\"dps\", \"target\", \"replace\"]', '{\"dps\": null, \"target\": null, \"replace\": null}', NULL, 'transformation', NULL, '8', '2020-03-05 12:25:58', '2020-03-05 12:25:58'),
('38', 'func-NQD39Hb9HNgTojP6orwwg5', 'REPT复制目标文本', '复制目标文本追加到文本末尾\n参数：\n    dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    target：要复制的字符\n    num:复制次数', 'sset-ft_lib', 'scpt-ft_tran_str', 'rept_transformation', 'rept_transformation(dps, target, num)', '[\"dps\", \"target\", \"num\"]', '{\"dps\": null, \"num\": null, \"target\": null}', NULL, 'transformation', NULL, '9', '2020-03-05 12:25:58', '2020-03-05 12:25:58'),
('39', 'func-qytKQtGsTHT5TYqQKcv5YS', 'SUBSTITUTE替换文本', '在文本字符串中用新文本替换旧文本\n参数：\n    dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    replace：进行替换的字符', 'sset-ft_lib', 'scpt-ft_tran_str', 'substitute_transformation', 'substitute_transformation(dps, replace)', '[\"dps\", \"replace\"]', '{\"dps\": null, \"replace\": null}', NULL, 'transformation', NULL, '10', '2020-03-05 12:25:58', '2020-03-05 12:25:58'),
('40', 'func-wG5mztbsDTgn5eTSke5cGa', 'TRIM去除文本空格', '去除文本中空格\n参数：\n    dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]', 'sset-ft_lib', 'scpt-ft_tran_str', 'trim_transformation', 'trim_transformation(dps)', '[\"dps\"]', '{\"dps\": null}', NULL, 'transformation', NULL, '11', '2020-03-05 12:25:58', '2020-03-05 12:25:58'),
('41', 'func-zcoiFwWcUHsYvA4WYK4BM9', 'UPPER将文本转为大写', '将文本转为大写\n参数：\n    dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]', 'sset-ft_lib', 'scpt-ft_tran_str', 'upper_transformation', 'upper_transformation(dps)', '[\"dps\"]', '{\"dps\": null}', NULL, 'transformation', NULL, '12', '2020-03-05 12:25:58', '2020-03-05 12:25:58');

INSERT INTO `biz_main_script` (`seq`, `id`, `title`, `description`, `scriptSetId`, `refName`, `publishVersion`, `code`, `codeMD5`, `codeDraft`, `codeDraftMD5`, `createTime`, `updateTime`) VALUES
('1', 'scpt-demo', '示例代码', '主要包含了一些用于展示DataFlux.f(x) 功能的代码，可以删除', 'sset-demo', 'demo', '1', '@DFF.API(\'Hello, world!\')\ndef hello_world():\n    \'\'\'\n    一个最简单的示例，直接返回\"Hello, world!\"字符串\n    \'\'\'\n    return \'Hello, world!\'\n\n@DFF.API(\'问候\')\ndef greeting(your_name):\n    \'\'\'\n    一个简单的带参数示例，返回JSON\n    \'\'\'\n    ret = {\n        \'message\': \'Hello! {}\'.format(your_name)\n    }\n    return ret\n\n@DFF.API(\'InfluxDB操作演示\')\ndef influxdb_demo():\n    \'\'\'\n    本函数从数据源`demo_influxdb`中查询3条`demo`指标并返回\n    \'\'\'\n    db = DFF.SRC(\'demo_influxdb\')\n    return db.query(\'SELECT * FROM demo LIMIT 3\')\n\n@DFF.API(\'MySQL操作演示\')\ndef mysql_demo():\n    \'\'\'\n    本函数从数据源`demo_mysql`中查询`demo`表数据并返回\n    \'\'\'\n    helper = DFF.SRC(\'demo_mysql\')\n    return helper.query(\'SELECT * FROM demo\')\n\n@DFF.API(\'Redis操作演示\')\ndef redis_demo():\n    \'\'\'\n    本函数对数据源`demo_redis`中的`demo`键进行加一计数\n    并返回当前`demo`键的值\n    \'\'\'\n    helper = DFF.SRC(\'demo_redis\')\n    helper.run(\'incr\', \'demo\')\n    return helper.run(\'get\', \'demo\')\n\n@DFF.API(\'ClickHouse操作演示\')\ndef clickhouse_demo():\n    \'\'\'\n    本函数从数据源`demo_clickhouse`中查询`demo_table`表数据并返回\n    \'\'\'\n    helper = DFF.SRC(\'demo_clickhouse\')\n    return helper.query(\'SELECT * FROM demo_table\')\n\n@DFF.API(\'内置DataFlux Dataway操作演示\')\ndef df_dataway_demo():\n    \'\'\'\n    本函数对数据源`df_dataway`添加一个数据点，并返回是否成功\n    \'\'\'\n    helper = DFF.SRC(\'df_dataway\')\n    return helper.write_point(\n        measurement=\'some_measurement\',\n        tags={\'name\': \'Tom\'},\n        fields={\'value\': 10},\n        timestamp=None)', '1b5290381423d2f66456a3e2536e5bae', '@DFF.API(\'Hello, world!\')\ndef hello_world():\n    \'\'\'\n    一个最简单的示例，直接返回\"Hello, world!\"字符串\n    \'\'\'\n    return \'Hello, world!\'\n\n@DFF.API(\'问候\')\ndef greeting(your_name):\n    \'\'\'\n    一个简单的带参数示例，返回JSON\n    \'\'\'\n    ret = {\n        \'message\': \'Hello! {}\'.format(your_name)\n    }\n    return ret\n\n@DFF.API(\'InfluxDB操作演示\')\ndef influxdb_demo():\n    \'\'\'\n    本函数从数据源`demo_influxdb`中查询3条`demo`指标并返回\n    \'\'\'\n    db = DFF.SRC(\'demo_influxdb\')\n    return db.query(\'SELECT * FROM demo LIMIT 3\')\n\n@DFF.API(\'MySQL操作演示\')\ndef mysql_demo():\n    \'\'\'\n    本函数从数据源`demo_mysql`中查询`demo`表数据并返回\n    \'\'\'\n    helper = DFF.SRC(\'demo_mysql\')\n    return helper.query(\'SELECT * FROM demo\')\n\n@DFF.API(\'Redis操作演示\')\ndef redis_demo():\n    \'\'\'\n    本函数对数据源`demo_redis`中的`demo`键进行加一计数\n    并返回当前`demo`键的值\n    \'\'\'\n    helper = DFF.SRC(\'demo_redis\')\n    helper.run(\'incr\', \'demo\')\n    return helper.run(\'get\', \'demo\')\n\n@DFF.API(\'ClickHouse操作演示\')\ndef clickhouse_demo():\n    \'\'\'\n    本函数从数据源`demo_clickhouse`中查询`demo_table`表数据并返回\n    \'\'\'\n    helper = DFF.SRC(\'demo_clickhouse\')\n    return helper.query(\'SELECT * FROM demo_table\')\n\n@DFF.API(\'内置DataFlux Dataway操作演示\')\ndef df_dataway_demo():\n    \'\'\'\n    本函数对数据源`df_dataway`添加一个数据点，并返回是否成功\n    \'\'\'\n    helper = DFF.SRC(\'df_dataway\')\n    return helper.write_point(\n        measurement=\'some_measurement\',\n        tags={\'name\': \'Tom\'},\n        fields={\'value\': 10},\n        timestamp=None)', '1b5290381423d2f66456a3e2536e5bae', '2019-12-09 15:25:22', '2020-03-05 12:26:14'),
('2', 'scpt-ft_pred', 'FT预测函数', '预测函数脚本集', 'sset-ft_lib', 'ft_pred', '1', 'import numpy as np\nimport random\nimport requests\nimport pandas as pd\nfrom math import sqrt\nfrom statsmodels.tsa.api import ExponentialSmoothing\nfrom statsmodels.tsa.arima_model import ARIMA\nfrom statsmodels.tsa.arima_model import ARMA\nfrom statsmodels.tsa.ar_model import AR\nfrom statsmodels.tsa.holtwinters import ExponentialSmoothing\n\n@DFF.API(\'平均值预测\', category=\'prediction\')\ndef avg_prediction(dps):\n    \'\'\'\n    一个对时序数据进行平均值预测\n    参数：\n        dps【必须】: [ , ... ]\n    返回：\n        [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    train = pd.DataFrame(dps)\n    train.index = pd.to_datetime(train[0],unit=\'ms\',origin=pd.Timestamp(\'1970-01-01 08:00:00\'))\n    train[1] = train[1].astype(\"float64\")\n    train[\'avg_forecast\'] = train[1].mean()\n    time_point = train[0][len(train[0])-1]\n    time_diff = train[0][len(train[0])-1] - train[0][len(train[0])-2]\n    mean = train[\'avg_forecast\'][0]\n\n    ret = []\n    for i in range(50):\n        time_point += time_diff\n        value = round(mean,2)\n        if np.isnan(value):\n            value = None\n        ret.append([\n            int(time_point),\n            value\n        ])\n    return ret\n\n@DFF.API(\'移动均值预测\', category=\'prediction\')\ndef moving_prediction(dps):\n    \'\'\'\n    一个对时序数据进行平均值预测\n    参数：\n        dps【必须】: [ , ... ]\n    返回：\n        [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    train = pd.DataFrame(dps)\n    train.index = pd.to_datetime(train[0],unit=\'ms\',origin=pd.Timestamp(\'1970-01-01 08:00:00\'))\n    train[1] = train[1].astype(\"float64\")\n    train[\'moving_avg_forecast\'] = train[1].rolling(60).mean().iloc[-1]\n    time_point = train[0][len(train[0])-1]\n    time_diff = train[0][len(train[0])-1] - train[0][len(train[0])-2]\n    mean = train[\'moving_avg_forecast\'][0]\n    ret = []\n    for i in range(50):\n        time_point += time_diff\n        value = round(mean,2)\n        if np.isnan(value):\n            value = None\n        ret.append([\n            int(time_point),\n            value\n        ])\n    return ret\n\n@DFF.API(\'Holt函数预测\', category=\'prediction\')\ndef holt_prediction(dps):\n    \"\"\"\n    一个对时序数据进行平均值预测\n    参数：\n        dps【必须】: [ , ... ]\n    返回：\n        [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \"\"\"\n    train = pd.DataFrame(dps)\n    train.index = pd.to_datetime(train[0],unit=\'ms\',origin=pd.Timestamp(\'1970-01-01 08:00:00\'))\n    train[1] = train[1].astype(\"float64\")\n    fit1 = ExponentialSmoothing(np.asarray(train[1]),seasonal_periods=7,trend=\'add\',seasonal=\'add\').fit()\n    y_hat_avg = fit1.forecast(50)\n    time_point = train[0][len(train[0])-1]\n    time_diff = train[0][len(train[0])-1] - train[0][len(train[0])-2]\n    ret = []\n    for i in y_hat_avg:\n        time_point += time_diff\n        value = round(i,2)\n        if np.isnan(value):\n            value = None\n        ret.append([\n            int(time_point),\n            value\n        ])\n    return ret\n@DFF.API(\'MA函数预测\', category=\'prediction\')\ndef ma_prediction(dps):\n    train = pd.DataFrame(dps)\n    train.index = pd.to_datetime(train[0],unit=\'ms\',origin=pd.Timestamp(\'1970-01-01 08:00:00\'))\n    train[1] = train[1].astype(\"float64\")\n    train[0] = train[0].astype(\"int64\")\n    time_point = train[0][len(train[0])-1]\n    time_diff = train[0][len(train[0])-1] - train[0][len(train[0])-2]\n    data = train[1].tolist()\n    model = ARMA(data, order=(0,7))\n    model_fit = model.fit(disp=False)\n    # make prediction\n    yhat = model_fit.predict(len(data), len(data)+20)\n    print(yhat)\n    print(time_diff)\n    ret = []\n    for i in yhat:\n        time_point += time_diff\n        value = round(i,2)\n        if np.isnan(value):\n            value = None\n        ret.append([\n            int(time_point),\n            value\n        ])\n    return ret\n\n@DFF.API(\'AR函数预测\', category=\'prediction\')\ndef ar_prediction(dps):\n    train = pd.DataFrame(dps)\n    train.index = pd.to_datetime(train[0],unit=\'ms\',origin=pd.Timestamp(\'1970-01-01 08:00:00\'))\n    train[1] = train[1].astype(\"float64\")\n    train[0] = train[0].astype(\"int64\")\n    time_point = train[0][len(train[0])-1]\n    time_diff = train[0][len(train[0])-1] - train[0][len(train[0])-2]\n    data = train[1].tolist()\n    model = AR(data)\n    model_fit = model.fit()\n    # make prediction\n    yhat = model_fit.predict(len(data), len(data)+30)\n\n    ret = []\n    for i in yhat:\n        time_point += time_diff\n        value = round(i,2)\n        if np.isnan(value):\n            value = None\n        ret.append([\n            int(time_point),\n            value\n        ])\n    return ret\n\n@DFF.API(\'ARIMA函数预测\', category=\'prediction\')\ndef arima_prediction(dps):\n    train = pd.DataFrame(dps)\n    train.index = pd.to_datetime(train[0],unit=\'ms\',origin=pd.Timestamp(\'1970-01-01 08:00:00\'))\n    train[1] = train[1].astype(\"float64\")\n    train[0] = train[0].astype(\"int64\")\n    time_point = train[0][len(train[0])-1]\n    time_diff = train[0][len(train[0])-1] - train[0][len(train[0])-2]\n    data = train[1].tolist()\n    model = AR(data)\n    model_fit = model.fit()\n    # make prediction\n    yhat = model_fit.predict(len(data), len(data)+20)\n\n    ret = []\n    for i in yhat:\n        time_point += time_diff\n        value = round(i,2)\n        if np.isnan(value):\n            value = None\n        ret.append([\n            int(time_point),\n            value\n        ])\n    return ret\n\ndef test_prediction():\n    dps =[[1581777800000, -33.55444223812124],[1581777810000, -50.83663612870732],[1581777820000, -39.55672134160139],[1581777830000, -38.39518359982622],[1581777840000, -36.22997922350511],[1581777850000, -36.78477147596941],\n[1581777860000, -20.12616034401329],\n[1581777870000, -36.54856240481572],\n[1581777880000, -30.31006152436570],\n[1581777890000, -42.53321660981094],\n[1581777900000, -13.20427195011425],\n[1581777910000, -14.53546668748857],\n[1581777920000, -15.55725246006902],\n[1581777930000, -26.76065716597191],\n[1581777940000, -35.55599811602032]]\n    train = pd.DataFrame(dps)\n    train.index = pd.to_datetime(train[0],unit=\'ms\',origin=pd.Timestamp(\'1970-01-01 08:00:00\'))\n    train[1] = train[1].astype(\"float64\")\n    train[0] = train[0].astype(\"int64\")\n    time_point = train[0][len(train[0])-1]\n    time_diff = train[0][len(train[0])-1] - train[0][len(train[0])-2]\n    data = train[1].tolist()\n    model = ExponentialSmoothing(data)\n    model_fit = model.fit()\n    # make prediction\n    yhat = model_fit.predict(len(data), len(data)+20)\n    print(yhat)\n    print(time_diff)\n    ret = []\n    for i in yhat:\n        time_point += time_diff\n        value = round(i,2)\n        if np.isnan(value):\n            value = None\n        ret.append([\n            int(time_point),\n            value\n        ])\n    return ret\n\n', '8bb88a6c1c66af816e187f161f2bdae4', 'import numpy as np\nimport random\nimport requests\nimport pandas as pd\nfrom math import sqrt\nfrom statsmodels.tsa.api import ExponentialSmoothing\nfrom statsmodels.tsa.arima_model import ARIMA\nfrom statsmodels.tsa.arima_model import ARMA\nfrom statsmodels.tsa.ar_model import AR\nfrom statsmodels.tsa.holtwinters import ExponentialSmoothing\n\n@DFF.API(\'平均值预测\', category=\'prediction\')\ndef avg_prediction(dps):\n    \'\'\'\n    一个对时序数据进行平均值预测\n    参数：\n        dps【必须】: [ , ... ]\n    返回：\n        [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    train = pd.DataFrame(dps)\n    train.index = pd.to_datetime(train[0],unit=\'ms\',origin=pd.Timestamp(\'1970-01-01 08:00:00\'))\n    train[1] = train[1].astype(\"float64\")\n    train[\'avg_forecast\'] = train[1].mean()\n    time_point = train[0][len(train[0])-1]\n    time_diff = train[0][len(train[0])-1] - train[0][len(train[0])-2]\n    mean = train[\'avg_forecast\'][0]\n\n    ret = []\n    for i in range(50):\n        time_point += time_diff\n        value = round(mean,2)\n        if np.isnan(value):\n            value = None\n        ret.append([\n            int(time_point),\n            value\n        ])\n    return ret\n\n@DFF.API(\'移动均值预测\', category=\'prediction\')\ndef moving_prediction(dps):\n    \'\'\'\n    一个对时序数据进行平均值预测\n    参数：\n        dps【必须】: [ , ... ]\n    返回：\n        [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    train = pd.DataFrame(dps)\n    train.index = pd.to_datetime(train[0],unit=\'ms\',origin=pd.Timestamp(\'1970-01-01 08:00:00\'))\n    train[1] = train[1].astype(\"float64\")\n    train[\'moving_avg_forecast\'] = train[1].rolling(60).mean().iloc[-1]\n    time_point = train[0][len(train[0])-1]\n    time_diff = train[0][len(train[0])-1] - train[0][len(train[0])-2]\n    mean = train[\'moving_avg_forecast\'][0]\n    ret = []\n    for i in range(50):\n        time_point += time_diff\n        value = round(mean,2)\n        if np.isnan(value):\n            value = None\n        ret.append([\n            int(time_point),\n            value\n        ])\n    return ret\n\n@DFF.API(\'Holt函数预测\', category=\'prediction\')\ndef holt_prediction(dps):\n    \"\"\"\n    一个对时序数据进行平均值预测\n    参数：\n        dps【必须】: [ , ... ]\n    返回：\n        [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \"\"\"\n    train = pd.DataFrame(dps)\n    train.index = pd.to_datetime(train[0],unit=\'ms\',origin=pd.Timestamp(\'1970-01-01 08:00:00\'))\n    train[1] = train[1].astype(\"float64\")\n    fit1 = ExponentialSmoothing(np.asarray(train[1]),seasonal_periods=7,trend=\'add\',seasonal=\'add\').fit()\n    y_hat_avg = fit1.forecast(50)\n    time_point = train[0][len(train[0])-1]\n    time_diff = train[0][len(train[0])-1] - train[0][len(train[0])-2]\n    ret = []\n    for i in y_hat_avg:\n        time_point += time_diff\n        value = round(i,2)\n        if np.isnan(value):\n            value = None\n        ret.append([\n            int(time_point),\n            value\n        ])\n    return ret\n@DFF.API(\'MA函数预测\', category=\'prediction\')\ndef ma_prediction(dps):\n    train = pd.DataFrame(dps)\n    train.index = pd.to_datetime(train[0],unit=\'ms\',origin=pd.Timestamp(\'1970-01-01 08:00:00\'))\n    train[1] = train[1].astype(\"float64\")\n    train[0] = train[0].astype(\"int64\")\n    time_point = train[0][len(train[0])-1]\n    time_diff = train[0][len(train[0])-1] - train[0][len(train[0])-2]\n    data = train[1].tolist()\n    model = ARMA(data, order=(0,7))\n    model_fit = model.fit(disp=False)\n    # make prediction\n    yhat = model_fit.predict(len(data), len(data)+20)\n    print(yhat)\n    print(time_diff)\n    ret = []\n    for i in yhat:\n        time_point += time_diff\n        value = round(i,2)\n        if np.isnan(value):\n            value = None\n        ret.append([\n            int(time_point),\n            value\n        ])\n    return ret\n\n@DFF.API(\'AR函数预测\', category=\'prediction\')\ndef ar_prediction(dps):\n    train = pd.DataFrame(dps)\n    train.index = pd.to_datetime(train[0],unit=\'ms\',origin=pd.Timestamp(\'1970-01-01 08:00:00\'))\n    train[1] = train[1].astype(\"float64\")\n    train[0] = train[0].astype(\"int64\")\n    time_point = train[0][len(train[0])-1]\n    time_diff = train[0][len(train[0])-1] - train[0][len(train[0])-2]\n    data = train[1].tolist()\n    model = AR(data)\n    model_fit = model.fit()\n    # make prediction\n    yhat = model_fit.predict(len(data), len(data)+30)\n\n    ret = []\n    for i in yhat:\n        time_point += time_diff\n        value = round(i,2)\n        if np.isnan(value):\n            value = None\n        ret.append([\n            int(time_point),\n            value\n        ])\n    return ret\n\n@DFF.API(\'ARIMA函数预测\', category=\'prediction\')\ndef arima_prediction(dps):\n    train = pd.DataFrame(dps)\n    train.index = pd.to_datetime(train[0],unit=\'ms\',origin=pd.Timestamp(\'1970-01-01 08:00:00\'))\n    train[1] = train[1].astype(\"float64\")\n    train[0] = train[0].astype(\"int64\")\n    time_point = train[0][len(train[0])-1]\n    time_diff = train[0][len(train[0])-1] - train[0][len(train[0])-2]\n    data = train[1].tolist()\n    model = AR(data)\n    model_fit = model.fit()\n    # make prediction\n    yhat = model_fit.predict(len(data), len(data)+20)\n\n    ret = []\n    for i in yhat:\n        time_point += time_diff\n        value = round(i,2)\n        if np.isnan(value):\n            value = None\n        ret.append([\n            int(time_point),\n            value\n        ])\n    return ret\n\ndef test_prediction():\n    dps =[[1581777800000, -33.55444223812124],[1581777810000, -50.83663612870732],[1581777820000, -39.55672134160139],[1581777830000, -38.39518359982622],[1581777840000, -36.22997922350511],[1581777850000, -36.78477147596941],\n[1581777860000, -20.12616034401329],\n[1581777870000, -36.54856240481572],\n[1581777880000, -30.31006152436570],\n[1581777890000, -42.53321660981094],\n[1581777900000, -13.20427195011425],\n[1581777910000, -14.53546668748857],\n[1581777920000, -15.55725246006902],\n[1581777930000, -26.76065716597191],\n[1581777940000, -35.55599811602032]]\n    train = pd.DataFrame(dps)\n    train.index = pd.to_datetime(train[0],unit=\'ms\',origin=pd.Timestamp(\'1970-01-01 08:00:00\'))\n    train[1] = train[1].astype(\"float64\")\n    train[0] = train[0].astype(\"int64\")\n    time_point = train[0][len(train[0])-1]\n    time_diff = train[0][len(train[0])-1] - train[0][len(train[0])-2]\n    data = train[1].tolist()\n    model = ExponentialSmoothing(data)\n    model_fit = model.fit()\n    # make prediction\n    yhat = model_fit.predict(len(data), len(data)+20)\n    print(yhat)\n    print(time_diff)\n    ret = []\n    for i in yhat:\n        time_point += time_diff\n        value = round(i,2)\n        if np.isnan(value):\n            value = None\n        ret.append([\n            int(time_point),\n            value\n        ])\n    return ret\n\n', '8bb88a6c1c66af816e187f161f2bdae4', '2020-02-28 07:10:54', '2020-03-05 12:26:14'),
('3', 'scpt-ft_tran', 'FT转换函数', '转换函数脚本集', 'sset-ft_lib', 'ft_tran', '1', 'import pandas as pd\nimport numpy as np\nimport math\n# from functools import reduce\n# import traceback\n\n@DFF.API(\'ABS绝对值转换\', category=\'transformation\')\ndef abs_transformation(dps):\n    \'\'\'\n    返回数字的绝对值。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    tran = pd.DataFrame(dps)\n    tran[1] = tran[1].astype(\"float64\").abs()\n    return tran.values.tolist()\n\n@DFF.API(\'AVG平均值转换\', category=\'transformation\')\ndef avg_transformation(dps):\n    \'\'\'\n    返回数字的平均值。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    tran = pd.DataFrame(dps)\n    tran[1] = tran[1].astype(\"float64\").mean()\n    return tran.values.tolist()\n\n@DFF.API(\'MAX最大值转换\', category=\'transformation\')\ndef max_transformation(dps):\n    \'\'\'\n    返回数字的最大值。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    tran = pd.DataFrame(dps)\n    tran[1] = tran[1].astype(\"float64\").max()\n    return tran.values.tolist()\n\n@DFF.API(\'MIN最小值转换\', category=\'transformation\')\ndef min_transformation(dps):\n    \'\'\'\n    返回数字的最小值。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    tran = pd.DataFrame(dps)\n    tran[1] = tran[1].astype(\"float64\").min()\n    return tran.values.tolist()\n\n@DFF.API(\'Even向上取偶数转换\',category=\'transformation\')\ndef even_transformation(dps):\n    \'\'\'\n    将数字向上舍入为最接近的偶数。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    df=pd.DataFrame(dps)\n    for i in range(0,len(df[1])):\n        if math.ceil(df[1][i])%2==0:\n            df[1][i]=math.ceil(df[1][i])\n        else:\n            df[1][i]=math.ceil(df[1][i])+1\n    return df.values.tolist()\n\n@DFF.API(\'Odd向上取奇数转换\',category=\'transformation\')\ndef odd_transformation(dps):\n    \'\'\'\n    将数字向上舍入为最接近的奇数。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    df=pd.DataFrame(dps)\n    for i in range(0,len(df[1])):\n        if math.ceil(df[1][i])%2!=0:\n            df[1][i]=math.ceil(df[1][i])\n        else:\n            df[1][i]=math.ceil(df[1][i])+1\n    return df.values.tolist()\n\n@DFF.API(\'Fact取整阶乘转换\',category=\'transformation\')\ndef fact_transformation(dps):\n    \'\'\'\n    返回数字的阶乘。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    df=pd.DataFrame(dps)\n    for i in range(0,len(df[1])):\n        product = 1\n        for j in range(math.ceil(df[1][i])):\n            product=product*(j+1)\n        df[1][i]=product\n        # df[1][i]=math.factorial(math.ceil(df[1][i]))\n    return df.values.tolist()\n\n@DFF.API(\'SumSQ平方和转换\',category=\'transformation\')\ndef sumsq_transformation(dps):\n    \'\'\'\n    返回数字的平方和。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    df=pd.DataFrame(dps)\n    df[1]=list(map(lambda x:x**2*2,df[1]))\n    return df.values.tolist()\n\n\n@DFF.API(\'RoundUp绝对值增大取整转换\',category=\'transformation\')\ndef roundup_transformation(dps):\n    \'\'\'\n     向绝对值增大的方向舍入数字。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    df=pd.DataFrame(dps)\n    for i in range(0,len(df[1])):\n        if df[1][i]<0:\n            df[1][i]=math.floor(df[1][i])\n        else:\n            df[1][i]=math.ceil(df[1][i])\n    return df.values.tolist()\n\n@DFF.API(\'RoundDown绝对值减小取整转换\',category=\'transformation\')\ndef rounddown_transformation(dps):\n    \'\'\'\n      向绝对值减小的方向舍入数字。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    df=pd.DataFrame(dps)\n    for i in range(0,len(df[1])):\n        if df[1][i]>0:\n            df[1][i]=math.floor(df[1][i])\n        else:\n            df[1][i]=math.ceil(df[1][i])\n    return df.values.tolist()\n\n@DFF.API(\'Power指数幂转换\',category=\'transformation\')\ndef power_transformation(dps,significance):\n    \'\'\'\n       返回给定次幂的结果。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n        significance:指定指数\n    \'\'\'\n    try:\n        significance=float(significance)\n        df=pd.DataFrame(dps)\n        for i in range(0,len(df[1])):\n            df[1][i]=df[1][i]**significance\n        return df.values.tolist()\n    except:\n        # info=traceback.format_exc()\n        info=significance+\' is not a number. \'\n        return info\n\n@DFF.API(\'Ceiling取整转换\',category=\'transformation\')\ndef ceiling_transformation(dps,significance):\n    \'\'\'\n    将数字四舍五入为最接近的整数或最接近的指定基数的倍数。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n        significance:指定基数的倍数\n    \'\'\'\n    try:\n        significance=float(significance)\n        df=pd.DataFrame(dps)\n        for i in range(0,len(df[1])):\n            if (df[1][i]/significance)>=1:\n                df[1][i]=round(df[1][i]/significance)*significance\n            else:df[1][i]=(round(df[1][i]/significance)+1)*significance\n        return df.values.tolist()\n    except:\n        # info=traceback.format_exc()\n        info=significance+\' is not a number. \'\n        print(info)\n        return info\n\n@DFF.API(\'AccumuAll累加转换\',category=\'transformation\')\ndef accumuall_transformation(dps):\n    \'\'\'\n    将前n个元素累加求和。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    total=0\n    df=pd.DataFrame(dps)\n    for i in range(0,len(df[1])):\n        total+=df[1][i]\n        df[1][i]=total\n    return df.values.tolist()\n\n@DFF.API(\'Accumu2求和转换\',category=\'transformation\')\ndef accumu2_transformation(dps):\n    \'\'\'\n    将每相邻2个元素累加求和。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    df=pd.DataFrame(dps)\n    m=df[1].copy()\n    for i in range(0,len(df[1])):\n        if i>0:\n            df[1][i]=m[i-1]+df[1][i]\n    return df.values.tolist()\n\n@DFF.API(\'ACOSH反双曲余弦转换\',category=\'transformation\')\ndef acosh_transformation(dps):\n    \'\'\'\n    返回数字的反双曲余弦值。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    df=pd.DataFrame(dps)\n    #acosh(number),number必须大于/等于1\n    df[1]=df[1].abs()\n    for i in range(0,len(df[1])):\n        if df[1][i]<1:\n            df[1][i]=math.acosh(df[1][i]+1)\n        else:\n             df[1][i]=math.acosh(df[1][i])\n    return df.values.tolist()\n\n\n\ndef test_acosh():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return acosh_transformation(dps)\n\ndef test_accumu2():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return accumu2_transformation(dps)\n\n\ndef test_abs():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return abs_transformation(dps)\n\ndef test_avg():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return avg_transformation(dps)\n\ndef test_max():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return max_transformation(dps)\n\ndef test_min():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return min_transformation(dps)\n\ndef test_even():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return even_transformation(dps)\n\ndef test_odd():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return odd_transformation(dps)\n\ndef test_fact():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return fact_transformation(dps)\n\ndef test_sumsq():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return sumsq_transformation(dps)\n\ndef test_roundup():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return roundup_transformation(dps)\n\ndef test_rounddown():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return rounddown_transformation(dps)\ndef test_power():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    a=\"2\"\n    return power_transformation(dps,a)\n\ndef test_ceiling():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return ceiling_transformation(dps,2)\n\ndef test_accumall():\n    dps = [[1576765000100, 20.3], [1576765000200, 50], [1576765000300, 25.8]]\n    return accumuall_transformation(dps)\n\n\n\n\n', '4ed62b83d3fdc8987b03322679caebe4', 'import pandas as pd\nimport numpy as np\nimport math\n# from functools import reduce\n# import traceback\n\n@DFF.API(\'ABS绝对值转换\', category=\'transformation\')\ndef abs_transformation(dps):\n    \'\'\'\n    返回数字的绝对值。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    tran = pd.DataFrame(dps)\n    tran[1] = tran[1].astype(\"float64\").abs()\n    return tran.values.tolist()\n\n@DFF.API(\'AVG平均值转换\', category=\'transformation\')\ndef avg_transformation(dps):\n    \'\'\'\n    返回数字的平均值。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    tran = pd.DataFrame(dps)\n    tran[1] = tran[1].astype(\"float64\").mean()\n    return tran.values.tolist()\n\n@DFF.API(\'MAX最大值转换\', category=\'transformation\')\ndef max_transformation(dps):\n    \'\'\'\n    返回数字的最大值。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    tran = pd.DataFrame(dps)\n    tran[1] = tran[1].astype(\"float64\").max()\n    return tran.values.tolist()\n\n@DFF.API(\'MIN最小值转换\', category=\'transformation\')\ndef min_transformation(dps):\n    \'\'\'\n    返回数字的最小值。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    tran = pd.DataFrame(dps)\n    tran[1] = tran[1].astype(\"float64\").min()\n    return tran.values.tolist()\n\n@DFF.API(\'Even向上取偶数转换\',category=\'transformation\')\ndef even_transformation(dps):\n    \'\'\'\n    将数字向上舍入为最接近的偶数。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    df=pd.DataFrame(dps)\n    for i in range(0,len(df[1])):\n        if math.ceil(df[1][i])%2==0:\n            df[1][i]=math.ceil(df[1][i])\n        else:\n            df[1][i]=math.ceil(df[1][i])+1\n    return df.values.tolist()\n\n@DFF.API(\'Odd向上取奇数转换\',category=\'transformation\')\ndef odd_transformation(dps):\n    \'\'\'\n    将数字向上舍入为最接近的奇数。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    df=pd.DataFrame(dps)\n    for i in range(0,len(df[1])):\n        if math.ceil(df[1][i])%2!=0:\n            df[1][i]=math.ceil(df[1][i])\n        else:\n            df[1][i]=math.ceil(df[1][i])+1\n    return df.values.tolist()\n\n@DFF.API(\'Fact取整阶乘转换\',category=\'transformation\')\ndef fact_transformation(dps):\n    \'\'\'\n    返回数字的阶乘。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    df=pd.DataFrame(dps)\n    for i in range(0,len(df[1])):\n        product = 1\n        for j in range(math.ceil(df[1][i])):\n            product=product*(j+1)\n        df[1][i]=product\n        # df[1][i]=math.factorial(math.ceil(df[1][i]))\n    return df.values.tolist()\n\n@DFF.API(\'SumSQ平方和转换\',category=\'transformation\')\ndef sumsq_transformation(dps):\n    \'\'\'\n    返回数字的平方和。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    df=pd.DataFrame(dps)\n    df[1]=list(map(lambda x:x**2*2,df[1]))\n    return df.values.tolist()\n\n\n@DFF.API(\'RoundUp绝对值增大取整转换\',category=\'transformation\')\ndef roundup_transformation(dps):\n    \'\'\'\n     向绝对值增大的方向舍入数字。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    df=pd.DataFrame(dps)\n    for i in range(0,len(df[1])):\n        if df[1][i]<0:\n            df[1][i]=math.floor(df[1][i])\n        else:\n            df[1][i]=math.ceil(df[1][i])\n    return df.values.tolist()\n\n@DFF.API(\'RoundDown绝对值减小取整转换\',category=\'transformation\')\ndef rounddown_transformation(dps):\n    \'\'\'\n      向绝对值减小的方向舍入数字。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    df=pd.DataFrame(dps)\n    for i in range(0,len(df[1])):\n        if df[1][i]>0:\n            df[1][i]=math.floor(df[1][i])\n        else:\n            df[1][i]=math.ceil(df[1][i])\n    return df.values.tolist()\n\n@DFF.API(\'Power指数幂转换\',category=\'transformation\')\ndef power_transformation(dps,significance):\n    \'\'\'\n       返回给定次幂的结果。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n        significance:指定指数\n    \'\'\'\n    try:\n        significance=float(significance)\n        df=pd.DataFrame(dps)\n        for i in range(0,len(df[1])):\n            df[1][i]=df[1][i]**significance\n        return df.values.tolist()\n    except:\n        # info=traceback.format_exc()\n        info=significance+\' is not a number. \'\n        return info\n\n@DFF.API(\'Ceiling取整转换\',category=\'transformation\')\ndef ceiling_transformation(dps,significance):\n    \'\'\'\n    将数字四舍五入为最接近的整数或最接近的指定基数的倍数。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n        significance:指定基数的倍数\n    \'\'\'\n    try:\n        significance=float(significance)\n        df=pd.DataFrame(dps)\n        for i in range(0,len(df[1])):\n            if (df[1][i]/significance)>=1:\n                df[1][i]=round(df[1][i]/significance)*significance\n            else:df[1][i]=(round(df[1][i]/significance)+1)*significance\n        return df.values.tolist()\n    except:\n        # info=traceback.format_exc()\n        info=significance+\' is not a number. \'\n        print(info)\n        return info\n\n@DFF.API(\'AccumuAll累加转换\',category=\'transformation\')\ndef accumuall_transformation(dps):\n    \'\'\'\n    将前n个元素累加求和。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    total=0\n    df=pd.DataFrame(dps)\n    for i in range(0,len(df[1])):\n        total+=df[1][i]\n        df[1][i]=total\n    return df.values.tolist()\n\n@DFF.API(\'Accumu2求和转换\',category=\'transformation\')\ndef accumu2_transformation(dps):\n    \'\'\'\n    将每相邻2个元素累加求和。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    df=pd.DataFrame(dps)\n    m=df[1].copy()\n    for i in range(0,len(df[1])):\n        if i>0:\n            df[1][i]=m[i-1]+df[1][i]\n    return df.values.tolist()\n\n@DFF.API(\'ACOSH反双曲余弦转换\',category=\'transformation\')\ndef acosh_transformation(dps):\n    \'\'\'\n    返回数字的反双曲余弦值。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    df=pd.DataFrame(dps)\n    #acosh(number),number必须大于/等于1\n    df[1]=df[1].abs()\n    for i in range(0,len(df[1])):\n        if df[1][i]<1:\n            df[1][i]=math.acosh(df[1][i]+1)\n        else:\n             df[1][i]=math.acosh(df[1][i])\n    return df.values.tolist()\n\n\n\ndef test_acosh():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return acosh_transformation(dps)\n\ndef test_accumu2():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return accumu2_transformation(dps)\n\n\ndef test_abs():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return abs_transformation(dps)\n\ndef test_avg():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return avg_transformation(dps)\n\ndef test_max():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return max_transformation(dps)\n\ndef test_min():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return min_transformation(dps)\n\ndef test_even():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return even_transformation(dps)\n\ndef test_odd():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return odd_transformation(dps)\n\ndef test_fact():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return fact_transformation(dps)\n\ndef test_sumsq():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return sumsq_transformation(dps)\n\ndef test_roundup():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return roundup_transformation(dps)\n\ndef test_rounddown():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return rounddown_transformation(dps)\ndef test_power():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    a=\"2\"\n    return power_transformation(dps,a)\n\ndef test_ceiling():\n    dps = [[1576765000100, 20.3], [1576765000200, -20.5], [1576765000300, 25.8]]\n    return ceiling_transformation(dps,2)\n\ndef test_accumall():\n    dps = [[1576765000100, 20.3], [1576765000200, 50], [1576765000300, 25.8]]\n    return accumuall_transformation(dps)\n\n\n\n\n', '4ed62b83d3fdc8987b03322679caebe4', '2020-02-28 07:10:54', '2020-03-05 12:26:14'),
('4', 'scpt-ft_tran_str', 'FT转换函数-文本转换', '文本转换用于字符串处理', 'sset-ft_lib', 'ft_tran_str', '1', 'import pandas as pd\n\n@DFF.API(\'Clean删除不可打印字符\',category=\'transformation\')\ndef clean_transformation(dps):\n    \'\'\'\n    从文本中删除不可打印的字符，去掉了前31个特殊的ASCII字符。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    df=pd.DataFrame(dps)\n    for i in range(0,len(df[1])):\n        word = \'\'\n        for j in df[1][i]:\n            if ord(j)>31:\n                word +=j\n        print(df[1][i])\n        df[1][i]=word\n        print(df[1][i])\n    return df.values.tolist()\n\n@DFF.API(\'Fixed数字格式化\',category=\'transformation\')\ndef fixed_transformation(dps,no_commas=\'True\',decimals=2):\n    \'\'\'\n    将数字格式设置为具有固定小数位数。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n        decimals:进行四舍五入后小数点后面需要保留的位数,如果是负数，则在小数点左侧进行四舍五入。若此参数                         decimals省略，则默认此参数为2。\n        no_commas:如果是 true，返回的结果不包含逗号千分位。如果是false或省略不写，返回的结果包含逗号千分位。\n    \'\'\'\n    try:\n        df=pd.DataFrame(dps)\n        decimals=int(decimals)\n        for i in range(0,len(df[1])):\n            df[1][i]=round(df[1][i],decimals)\n            if no_commas.title()==\'False\':\n                df[1][i]=\'{:,}\'.format(df[1][i])\n        return df.values.tolist()\n    except Exception:\n        print(\'参数错误\')\n\n@DFF.API(\'Left截取左边字符\',category=\'transformation\')\ndef left_transformation(dps,num_chars=1):\n    \'\'\'\n    返回文本值中最左边的字符。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n        num_chars:需要截取字符的个数。默认截取1个\n    \'\'\'\n    try:\n        df=pd.DataFrame(dps)\n        num_chars=int(num_chars)\n        for i in range(0,len(df[1])):\n            df[1][i]=df[1][i][0:num_chars]\n        return df.values.tolist()\n    except Exception:\n        print(\'参数错误\')\n\n@DFF.API(\'Right截取右边字符\',category=\'transformation\')\ndef right_transformation(dps,num_chars=None):\n    \'\'\'\n    返回文本值中最右边的字符。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n        num_chars:需要截取字符的个数。默认截取1个\n    \'\'\'\n    try:\n        if num_chars is None:\n            num_chars = 1\n        df=pd.DataFrame(dps)\n        num_chars=int(num_chars)\n        for i in range(0,len(df[1])):\n            df[1][i]=df[1][i][-num_chars:]\n        return df.values.tolist()\n    except Exception:\n        print(\'参数错误\')\n\n@DFF.API(\'LEN字符串长度\',category=\'transformation\')\ndef len_transformation(dps):\n    \'\'\'\n    返回文本字符串中的字符数。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    df=pd.DataFrame(dps)\n    for i in range(0,len(df[1])):\n        df[1][i]=len(df[1][i])\n    return df.values.tolist()\n\n@DFF.API(\'Lower字符小写转换\',category=\'transformation\')\ndef lower_transformation(dps):\n    \'\'\'\n    将文本转换为小写。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    df=pd.DataFrame(dps)\n    for i in range(0,len(df[1])):\n        df[1][i]=df[1][i].lower()\n    return df.values.tolist()\n\n@DFF.API(\'MID截取字符\',category=\'transformation\')\ndef mid_transformation(dps,start_num=1,num_chars=1,):\n    \'\'\'\n     在文本字符串中,从您所指定的位置开始返回特定数量的字符。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n        start_num:从左侧第几位开始截取。\n        num_chars:需要截取字符的个数。默认截取1个。\n    \'\'\'\n    try:\n        df=pd.DataFrame(dps)\n        num_chars=int(num_chars)\n        start_num=int(start_num)\n        for i in range(0,len(df[1])):\n            df[1][i]=df[1][i][start_num-1:start_num-1+num_chars]\n        return df.values.tolist()\n    except Exception:\n        print(\'参数错误\')\n\n@DFF.API(\'PROPER首字母转大写\',category=\'transformation\')\ndef proper_transformation(dps,sep=None):\n    \'\'\'\n    将字符串的首字母转为大写，其余变为小写规范化输出\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n        sep【默认是空格】：要转换的文本的切分符\n    \'\'\'\n    try:\n        if sep is None:\n            sep = \' \'\n        df = pd.DataFrame(dps)\n        for i in range(0,len(df[1])):\n            arr = df[1][i].split(sep)\n            df[1][i]=\' \'.join(list(map(normallize,arr)))\n        return df.values.tolist()\n    except Exception:\n        print(\"参数错误\")\n\n@DFF.API(\'REPLACE替换目标字符\',category=\'transformation\')\ndef replace_transformation(dps,target,replace):\n    \'\'\'\n    替换字符串中的目标字符\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n        target：被替换的字符\n        replace:要替换的字符\n    \'\'\'\n    try:\n        df = pd.DataFrame(dps)\n        for i in range(0,len(df[1])):\n            df[1][i]= df[1][i].replace(target,replace)\n        return df.values.tolist()\n    except Exception:\n        print(\"参数错误\")\n\n@DFF.API(\'REPT复制目标文本\',category=\'transformation\')\ndef rept_transformation(dps,target,num):\n    \'\'\'\n    复制目标文本追加到文本末尾\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n        target：要复制的字符\n        num:复制次数\n    \'\'\'\n    try:\n        df = pd.DataFrame(dps)\n        for i in range(0,len(df[1])):\n            df[1][i]= df[1][i] + target*int(num)\n        return df.values.tolist()\n    except Exception:\n        print(\"参数错误\")\n\n@DFF.API(\'SUBSTITUTE替换文本\',category=\'transformation\')\ndef substitute_transformation(dps,replace):\n    \'\'\'\n    在文本字符串中用新文本替换旧文本\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n        replace：进行替换的字符\n    \'\'\'\n    try:\n        df = pd.DataFrame(dps)\n        for i in range(0,len(df[1])):\n            df[1][i]= replace\n        return df.values.tolist()\n    except Exception:\n        print(\"参数错误\")\n\n@DFF.API(\'TRIM去除文本空格\',category=\'transformation\')\ndef trim_transformation(dps):\n    \'\'\'\n    去除文本中空格\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    try:\n        df = pd.DataFrame(dps)\n        for i in range(0,len(df[1])):\n            df[1][i]= df[1][i].replace(\' \',\'\')\n        return df.values.tolist()\n    except Exception:\n        print(\"参数错误\")\n\n@DFF.API(\'UPPER将文本转为大写\',category=\'transformation\')\ndef upper_transformation(dps):\n    \'\'\'\n    将文本转为大写\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    try:\n        df = pd.DataFrame(dps)\n        for i in range(0,len(df[1])):\n            df[1][i]= df[1][i].upper()\n        return df.values.tolist()\n    except Exception:\n        print(\"参数错误\")\n\ndef normallize(name):\n    return name.capitalize()\n\n\ndef test_proper():\n    dps = [[1576765000000, \"sfoaj fajfioaj\"], [1576765001000, \"qeAja afq\"], [1576765002000, \"afakjfa fafa\"], [1576765003000, \"aot ha\"],[1576765004000, \"faq fa\"], [1576765005000, \"bafla ajw\"], [1576765006000, \"afkaj qop\"], [1576765007000, \"fajqq jlj\"],[1576765008000, \"dga afw\"], [1576765009000, \"dfa awo\"], [1576765010000, \"qwk weqb\"], [1576765011000, \"fakljqv bse\"]]\n    # return proper_transformation(dps)\n    # return replace_transformation(dps,\'fa\',\'AA\')\n    # return right_transformation(dps, \'3\')\n    # return rept_transformation(dps,\"AA\",\"2\")\n    # return substitute_transformation(dps,\"aaaa\")\n    # return trim_transformation(dps)\n    return upper_transformation(dps)\n\ndef test_mid():\n    dps = [[1576765000100, \"111DTTTTTSd\\ndd\"], [1576765000200, \'aqs\\tss\'], [1576765000300, \'ss等等\']]\n    return mid_transformation(dps,1,3)\n\ndef test_lower():\n    dps = [[1576765000100, \"111DTTTTTSd\\ndd\"], [1576765000200, \'aqs\\tss\'], [1576765000300, \'ss等等\']]\n    return lower_transformation(dps)\n\ndef test_len():\n    dps = [[1576765000100, \"111Dd\\ndd\"], [1576765000200, \'aqs\\tss\'], [1576765000300, \'ss等等\']]\n    return len_transformation(dps)\n\ndef test_left():\n    dps = [[1576765000100, \"111dd\\ndd\"], [1576765000200, \'aqs\\tss\'], [1576765000300, \'ss\\t等等\']]\n    return left_transformation(dps,\'3\')\ndef test_clean():\n    dps = [[1576765000100, \"111dd\\ndd\"], [1576765000200, \'aqs\\tss\'], [1576765000300, \'ss\\t等等\']]\n    return clean_transformation(dps)\n\ndef test_fixed():\n    dps = [[1576765000100, 438272.7651], [1576765000200, 43318272.7651], [1576765000300, 43823472.51]]\n    return fixed_transformation(dps,\"false\",\"1\")\n\n\n\n\n\n\n', '961549ae168cd3d5933063c87881b918', 'import pandas as pd\n\n@DFF.API(\'Clean删除不可打印字符\',category=\'transformation\')\ndef clean_transformation(dps):\n    \'\'\'\n    从文本中删除不可打印的字符，去掉了前31个特殊的ASCII字符。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    df=pd.DataFrame(dps)\n    for i in range(0,len(df[1])):\n        word = \'\'\n        for j in df[1][i]:\n            if ord(j)>31:\n                word +=j\n        print(df[1][i])\n        df[1][i]=word\n        print(df[1][i])\n    return df.values.tolist()\n\n@DFF.API(\'Fixed数字格式化\',category=\'transformation\')\ndef fixed_transformation(dps,no_commas=\'True\',decimals=2):\n    \'\'\'\n    将数字格式设置为具有固定小数位数。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n        decimals:进行四舍五入后小数点后面需要保留的位数,如果是负数，则在小数点左侧进行四舍五入。若此参数                         decimals省略，则默认此参数为2。\n        no_commas:如果是 true，返回的结果不包含逗号千分位。如果是false或省略不写，返回的结果包含逗号千分位。\n    \'\'\'\n    try:\n        df=pd.DataFrame(dps)\n        decimals=int(decimals)\n        for i in range(0,len(df[1])):\n            df[1][i]=round(df[1][i],decimals)\n            if no_commas.title()==\'False\':\n                df[1][i]=\'{:,}\'.format(df[1][i])\n        return df.values.tolist()\n    except Exception:\n        print(\'参数错误\')\n\n@DFF.API(\'Left截取左边字符\',category=\'transformation\')\ndef left_transformation(dps,num_chars=1):\n    \'\'\'\n    返回文本值中最左边的字符。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n        num_chars:需要截取字符的个数。默认截取1个\n    \'\'\'\n    try:\n        df=pd.DataFrame(dps)\n        num_chars=int(num_chars)\n        for i in range(0,len(df[1])):\n            df[1][i]=df[1][i][0:num_chars]\n        return df.values.tolist()\n    except Exception:\n        print(\'参数错误\')\n\n@DFF.API(\'Right截取右边字符\',category=\'transformation\')\ndef right_transformation(dps,num_chars=None):\n    \'\'\'\n    返回文本值中最右边的字符。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n        num_chars:需要截取字符的个数。默认截取1个\n    \'\'\'\n    try:\n        if num_chars is None:\n            num_chars = 1\n        df=pd.DataFrame(dps)\n        num_chars=int(num_chars)\n        for i in range(0,len(df[1])):\n            df[1][i]=df[1][i][-num_chars:]\n        return df.values.tolist()\n    except Exception:\n        print(\'参数错误\')\n\n@DFF.API(\'LEN字符串长度\',category=\'transformation\')\ndef len_transformation(dps):\n    \'\'\'\n    返回文本字符串中的字符数。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    df=pd.DataFrame(dps)\n    for i in range(0,len(df[1])):\n        df[1][i]=len(df[1][i])\n    return df.values.tolist()\n\n@DFF.API(\'Lower字符小写转换\',category=\'transformation\')\ndef lower_transformation(dps):\n    \'\'\'\n    将文本转换为小写。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    df=pd.DataFrame(dps)\n    for i in range(0,len(df[1])):\n        df[1][i]=df[1][i].lower()\n    return df.values.tolist()\n\n@DFF.API(\'MID截取字符\',category=\'transformation\')\ndef mid_transformation(dps,start_num=1,num_chars=1,):\n    \'\'\'\n     在文本字符串中,从您所指定的位置开始返回特定数量的字符。\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n        start_num:从左侧第几位开始截取。\n        num_chars:需要截取字符的个数。默认截取1个。\n    \'\'\'\n    try:\n        df=pd.DataFrame(dps)\n        num_chars=int(num_chars)\n        start_num=int(start_num)\n        for i in range(0,len(df[1])):\n            df[1][i]=df[1][i][start_num-1:start_num-1+num_chars]\n        return df.values.tolist()\n    except Exception:\n        print(\'参数错误\')\n\n@DFF.API(\'PROPER首字母转大写\',category=\'transformation\')\ndef proper_transformation(dps,sep=None):\n    \'\'\'\n    将字符串的首字母转为大写，其余变为小写规范化输出\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n        sep【默认是空格】：要转换的文本的切分符\n    \'\'\'\n    try:\n        if sep is None:\n            sep = \' \'\n        df = pd.DataFrame(dps)\n        for i in range(0,len(df[1])):\n            arr = df[1][i].split(sep)\n            df[1][i]=\' \'.join(list(map(normallize,arr)))\n        return df.values.tolist()\n    except Exception:\n        print(\"参数错误\")\n\n@DFF.API(\'REPLACE替换目标字符\',category=\'transformation\')\ndef replace_transformation(dps,target,replace):\n    \'\'\'\n    替换字符串中的目标字符\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n        target：被替换的字符\n        replace:要替换的字符\n    \'\'\'\n    try:\n        df = pd.DataFrame(dps)\n        for i in range(0,len(df[1])):\n            df[1][i]= df[1][i].replace(target,replace)\n        return df.values.tolist()\n    except Exception:\n        print(\"参数错误\")\n\n@DFF.API(\'REPT复制目标文本\',category=\'transformation\')\ndef rept_transformation(dps,target,num):\n    \'\'\'\n    复制目标文本追加到文本末尾\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n        target：要复制的字符\n        num:复制次数\n    \'\'\'\n    try:\n        df = pd.DataFrame(dps)\n        for i in range(0,len(df[1])):\n            df[1][i]= df[1][i] + target*int(num)\n        return df.values.tolist()\n    except Exception:\n        print(\"参数错误\")\n\n@DFF.API(\'SUBSTITUTE替换文本\',category=\'transformation\')\ndef substitute_transformation(dps,replace):\n    \'\'\'\n    在文本字符串中用新文本替换旧文本\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n        replace：进行替换的字符\n    \'\'\'\n    try:\n        df = pd.DataFrame(dps)\n        for i in range(0,len(df[1])):\n            df[1][i]= replace\n        return df.values.tolist()\n    except Exception:\n        print(\"参数错误\")\n\n@DFF.API(\'TRIM去除文本空格\',category=\'transformation\')\ndef trim_transformation(dps):\n    \'\'\'\n    去除文本中空格\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    try:\n        df = pd.DataFrame(dps)\n        for i in range(0,len(df[1])):\n            df[1][i]= df[1][i].replace(\' \',\'\')\n        return df.values.tolist()\n    except Exception:\n        print(\"参数错误\")\n\n@DFF.API(\'UPPER将文本转为大写\',category=\'transformation\')\ndef upper_transformation(dps):\n    \'\'\'\n    将文本转为大写\n    参数：\n        dps【必须】: [ [<UNIX时间戳（毫秒）>, <数值>], [<UNIX时间戳（毫秒）>, <数值>], ... ]\n    \'\'\'\n    try:\n        df = pd.DataFrame(dps)\n        for i in range(0,len(df[1])):\n            df[1][i]= df[1][i].upper()\n        return df.values.tolist()\n    except Exception:\n        print(\"参数错误\")\n\ndef normallize(name):\n    return name.capitalize()\n\n\ndef test_proper():\n    dps = [[1576765000000, \"sfoaj fajfioaj\"], [1576765001000, \"qeAja afq\"], [1576765002000, \"afakjfa fafa\"], [1576765003000, \"aot ha\"],[1576765004000, \"faq fa\"], [1576765005000, \"bafla ajw\"], [1576765006000, \"afkaj qop\"], [1576765007000, \"fajqq jlj\"],[1576765008000, \"dga afw\"], [1576765009000, \"dfa awo\"], [1576765010000, \"qwk weqb\"], [1576765011000, \"fakljqv bse\"]]\n    # return proper_transformation(dps)\n    # return replace_transformation(dps,\'fa\',\'AA\')\n    # return right_transformation(dps, \'3\')\n    # return rept_transformation(dps,\"AA\",\"2\")\n    # return substitute_transformation(dps,\"aaaa\")\n    # return trim_transformation(dps)\n    return upper_transformation(dps)\n\ndef test_mid():\n    dps = [[1576765000100, \"111DTTTTTSd\\ndd\"], [1576765000200, \'aqs\\tss\'], [1576765000300, \'ss等等\']]\n    return mid_transformation(dps,1,3)\n\ndef test_lower():\n    dps = [[1576765000100, \"111DTTTTTSd\\ndd\"], [1576765000200, \'aqs\\tss\'], [1576765000300, \'ss等等\']]\n    return lower_transformation(dps)\n\ndef test_len():\n    dps = [[1576765000100, \"111Dd\\ndd\"], [1576765000200, \'aqs\\tss\'], [1576765000300, \'ss等等\']]\n    return len_transformation(dps)\n\ndef test_left():\n    dps = [[1576765000100, \"111dd\\ndd\"], [1576765000200, \'aqs\\tss\'], [1576765000300, \'ss\\t等等\']]\n    return left_transformation(dps,\'3\')\ndef test_clean():\n    dps = [[1576765000100, \"111dd\\ndd\"], [1576765000200, \'aqs\\tss\'], [1576765000300, \'ss\\t等等\']]\n    return clean_transformation(dps)\n\ndef test_fixed():\n    dps = [[1576765000100, 438272.7651], [1576765000200, 43318272.7651], [1576765000300, 43823472.51]]\n    return fixed_transformation(dps,\"false\",\"1\")\n\n\n\n\n\n\n', '961549ae168cd3d5933063c87881b918', '2020-02-28 07:10:54', '2020-03-05 12:26:14');

INSERT INTO `biz_main_script_set` (`seq`, `id`, `title`, `description`, `refName`, `type`, `createTime`, `updateTime`) VALUES
('1', 'sset-demo', '示例脚本集', '主要包含了一些用于展示DataFlux.f(x) 功能的脚本，可以删除', 'demo', 'user', '2019-12-09 15:15:05', '2020-02-26 00:59:55'),
('2', 'sset-ft_lib', '场景支持', '场景支持脚本集', 'ft_lib', 'official', '2020-02-28 07:10:54', '2020-03-05 12:26:46');

INSERT INTO `wat_main_organization` (`seq`, `id`, `uniqueId`, `name`, `markers`, `isDisabled`, `createTime`, `updateTime`) VALUES
('1', 'o-sys', 'system', 'System Organization', NULL, '0', '2017-07-28 18:08:03', '2018-05-24 00:47:06');

INSERT INTO `wat_main_user` (`seq`, `id`, `organizationId`, `username`, `passwordHash`, `name`, `mobile`, `markers`, `roles`, `customPrivileges`, `isDisabled`, `createTime`, `updateTime`) VALUES
('1', 'u-admin', 'o-sys', 'admin', '03449cf93ebd8f67f652f9a82b2148380b2597eedd777963245472be3311e75f3ae516244b6d7648b9b044e2523c2840bdf86a852037db7e58e9b216539b2d21', '系统管理员', NULL, NULL, 'sa', '*', '0', '2017-07-28 18:08:03', '2019-02-25 03:19:24');




/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;