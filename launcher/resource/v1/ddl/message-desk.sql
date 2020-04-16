-- -------------------------------------------------------------
-- TablePlus 3.3.0(300)
--
-- https://tableplus.com/
--
-- Database: message_desk
-- Generation Time: 2020-04-01 22:49:59.4910
-- -------------------------------------------------------------


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


DROP TABLE IF EXISTS `biz_main_task_result_alidayu_double_call`;
CREATE TABLE `biz_main_task_result_alidayu_double_call` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `task` varchar(128) NOT NULL DEFAULT '',
  `origin` varchar(128) DEFAULT NULL,
  `toAccountId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '登录账号(接受人)ID',
  `byAccountId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '登录账号(发起人)ID',
  `toTeamId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '发起账号团队ID',
  `byTeamId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '发起账号团队ID',
  `to` text COMMENT '主叫手机',
  `by` text COMMENT '被叫手机',
  `startTime` int(11) DEFAULT NULL COMMENT '任务开始时间(秒级UNIX时间戳)',
  `endTime` int(11) DEFAULT NULL COMMENT '任务结束时间(秒级UNIX时间戳)',
  `argsJSON` text COMMENT '列表参数JSON',
  `kwargsJSON` text COMMENT '字典参数JSON',
  `retvalJSON` text COMMENT '执行结果JSON',
  `status` varchar(64) DEFAULT '' COMMENT '任务状态: SUCCESS|FAILURE',
  `einfoTEXT` text COMMENT '错误信息TEXT',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  KEY `task` (`task`),
  KEY `origin` (`origin`),
  KEY `accountId` (`toAccountId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='阿里大于多方通话任务结果';

DROP TABLE IF EXISTS `biz_main_task_result_alidayu_sms`;
CREATE TABLE `biz_main_task_result_alidayu_sms` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `task` varchar(128) NOT NULL DEFAULT '',
  `origin` varchar(128) DEFAULT NULL,
  `accountId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '帐号Id',
  `teamId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '团队ID',
  `to` text COMMENT '手机',
  `templateCode` text COMMENT '模板',
  `templateParamsJSON` text COMMENT '模板参数',
  `signName` text COMMENT '签名',
  `startTime` int(11) DEFAULT NULL COMMENT '任务开始时间(秒级UNIX时间戳)',
  `endTime` int(11) DEFAULT NULL COMMENT '任务结束时间(秒级UNIX时间戳)',
  `argsJSON` text COMMENT '列表参数JSON',
  `kwargsJSON` text COMMENT '字典参数JSON',
  `retvalJSON` text COMMENT '执行结果JSON',
  `status` varchar(64) DEFAULT '' COMMENT '任务状态: SUCCESS|FAILURE',
  `einfoTEXT` text COMMENT '错误信息TEXT',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  KEY `task` (`task`),
  KEY `origin` (`origin`),
  KEY `accountId` (`accountId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='阿里大于短信任务结果';

DROP TABLE IF EXISTS `biz_main_task_result_alidayu_tts_call`;
CREATE TABLE `biz_main_task_result_alidayu_tts_call` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `task` varchar(128) NOT NULL DEFAULT '',
  `origin` varchar(128) DEFAULT NULL,
  `accountId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '帐号Id',
  `teamId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '团队ID',
  `to` text COMMENT '电话',
  `templateCode` text COMMENT '模板',
  `templateParamsJSON` text COMMENT '模板参数',
  `startTime` int(11) DEFAULT NULL COMMENT '任务开始时间(秒级UNIX时间戳)',
  `endTime` int(11) DEFAULT NULL COMMENT '任务结束时间(秒级UNIX时间戳)',
  `argsJSON` text COMMENT '列表参数JSON',
  `kwargsJSON` text COMMENT '字典参数JSON',
  `retvalJSON` text COMMENT '执行结果JSON',
  `status` varchar(64) DEFAULT '' COMMENT '任务状态: SUCCESS|FAILURE',
  `einfoTEXT` text COMMENT '错误信息TEXT',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  KEY `task` (`task`),
  KEY `origin` (`origin`),
  KEY `accountId` (`accountId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='阿里大于TTS语音任务结果';

DROP TABLE IF EXISTS `biz_main_task_result_aliyun_click_to_dial`;
CREATE TABLE `biz_main_task_result_aliyun_click_to_dial` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `task` varchar(128) NOT NULL DEFAULT '',
  `origin` varchar(128) DEFAULT NULL,
  `toAccountId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '登录账号(接受人)ID',
  `byAccountId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '登录账号(发起人)ID',
  `toTeamId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '接受账号团队ID',
  `byTeamId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '发起账号团队ID',
  `to` text COMMENT '主叫手机',
  `by` text COMMENT '被叫手机',
  `startTime` int(11) DEFAULT NULL COMMENT '任务开始时间(秒级UNIX时间戳)',
  `endTime` int(11) DEFAULT NULL COMMENT '任务结束时间(秒级UNIX时间戳)',
  `argsJSON` text COMMENT '列表参数JSON',
  `kwargsJSON` text COMMENT '字典参数JSON',
  `retvalJSON` text COMMENT '执行结果JSON',
  `callRecordJSON` text COMMENT '通话记录JSON',
  `mnsRecvMsg` text COMMENT '返回消息记录信息',
  `ossPath` text COMMENT 'oss上传路径',
  `status` varchar(64) DEFAULT '' COMMENT '任务状态: SUCCESS|FAILURE',
  `einfoTEXT` text COMMENT '错误信息TEXT',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  KEY `task` (`task`),
  KEY `origin` (`origin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='阿里云点击拨号任务结果';

DROP TABLE IF EXISTS `biz_main_task_result_aliyun_sms`;
CREATE TABLE `biz_main_task_result_aliyun_sms` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `task` varchar(128) NOT NULL DEFAULT '',
  `origin` varchar(128) DEFAULT NULL,
  `accountId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '帐号id',
  `teamId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '团队ID',
  `to` text COMMENT '手机',
  `templateCode` text COMMENT '模板',
  `templateParamsJSON` text COMMENT '模板参数',
  `signName` text COMMENT '签名',
  `startTime` int(11) DEFAULT NULL COMMENT '任务开始时间(秒级UNIX时间戳)',
  `endTime` int(11) DEFAULT NULL COMMENT '任务结束时间(秒级UNIX时间戳)',
  `argsJSON` text COMMENT '列表参数JSON',
  `kwargsJSON` text COMMENT '字典参数JSON',
  `retvalJSON` text COMMENT '执行结果JSON',
  `status` varchar(64) DEFAULT '' COMMENT '任务状态: SUCCESS|FAILURE',
  `einfoTEXT` text COMMENT '错误信息TEXT',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  KEY `task` (`task`),
  KEY `origin` (`origin`),
  KEY `accountId` (`accountId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='阿里云通讯短信任务结果';

DROP TABLE IF EXISTS `biz_main_task_result_aliyun_tts_call`;
CREATE TABLE `biz_main_task_result_aliyun_tts_call` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `task` varchar(128) NOT NULL DEFAULT '',
  `origin` varchar(128) DEFAULT NULL,
  `accountId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '帐号Id',
  `teamId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '团队ID',
  `to` text COMMENT '电话',
  `templateCode` text COMMENT '模板',
  `templateParamsJSON` text COMMENT '模板参数',
  `startTime` int(11) DEFAULT NULL COMMENT '任务开始时间(秒级UNIX时间戳)',
  `endTime` int(11) DEFAULT NULL COMMENT '任务结束时间(秒级UNIX时间戳)',
  `argsJSON` text COMMENT '列表参数JSON',
  `kwargsJSON` text COMMENT '字典参数JSON',
  `retvalJSON` text COMMENT '执行结果JSON',
  `callRecordJSON` text COMMENT '通话记录JSON',
  `status` varchar(64) DEFAULT '' COMMENT '任务状态: SUCCESS|FAILURE',
  `einfoTEXT` text COMMENT '错误信息TEXT',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  KEY `task` (`task`),
  KEY `origin` (`origin`),
  KEY `accountId` (`accountId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='阿里云通讯TTS语音任务结果';

DROP TABLE IF EXISTS `biz_main_task_result_ding_talk_robot`;
CREATE TABLE `biz_main_task_result_ding_talk_robot` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `task` varchar(128) NOT NULL DEFAULT '',
  `origin` varchar(128) DEFAULT NULL,
  `startTime` int(11) DEFAULT NULL COMMENT '任务开始时间(秒级UNIX时间戳)',
  `endTime` int(11) DEFAULT NULL COMMENT '任务结束时间(秒级UNIX时间戳)',
  `msgType` varchar(15) DEFAULT NULL COMMENT '消息类型',
  `argsJSON` text COMMENT '列表参数JSON',
  `kwargsJSON` text COMMENT '字典参数JSON',
  `retvalJSON` text COMMENT '执行结果JSON',
  `status` varchar(64) DEFAULT '' COMMENT '任务状态: SUCCESS|FAILURE',
  `einfoTEXT` text COMMENT '错误信息TEXT',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  KEY `task` (`task`),
  KEY `origin` (`origin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='钉钉机器人任务结果';

DROP TABLE IF EXISTS `biz_main_task_result_http_request`;
CREATE TABLE `biz_main_task_result_http_request` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `task` varchar(128) NOT NULL DEFAULT '',
  `origin` varchar(128) DEFAULT NULL,
  `accountId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '帐号Id',
  `teamId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '团队ID',
  `method` text COMMENT 'HTTP方法',
  `url` text COMMENT 'URL',
  `startTime` int(11) DEFAULT NULL COMMENT '任务开始时间(秒级UNIX时间戳)',
  `endTime` int(11) DEFAULT NULL COMMENT '任务结束时间(秒级UNIX时间戳)',
  `argsJSON` text COMMENT '列表参数JSON',
  `kwargsJSON` text COMMENT '字典参数JSON',
  `retvalJSON` text COMMENT '执行结果JSON',
  `status` varchar(64) DEFAULT '' COMMENT '任务状态: SUCCESS|FAILURE',
  `einfoTEXT` text COMMENT '错误信息TEXT',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  KEY `task` (`task`),
  KEY `origin` (`origin`),
  KEY `accountId` (`accountId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='HTTP请求任务结果';

DROP TABLE IF EXISTS `biz_main_task_result_jiguang`;
CREATE TABLE `biz_main_task_result_jiguang` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `task` varchar(128) NOT NULL DEFAULT '',
  `origin` varchar(128) DEFAULT NULL,
  `accountId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '帐号Id',
  `teamId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '团队ID',
  `toAll` tinyint(1) DEFAULT '0' COMMENT '是否广播全员',
  `toRegIds` text COMMENT '按注册ID发送',
  `toAlias` text COMMENT '按别名发送',
  `toTag` text COMMENT '按标签发送',
  `toTagAnd` text COMMENT '按标签与发送',
  `toTagNot` text COMMENT '按标签非发送',
  `toSegment` text COMMENT '按用户分群ID发送',
  `androidAlert` text COMMENT '安卓提示内容',
  `iosAlert` text COMMENT 'iOS提示内容',
  `winphoneAlert` text COMMENT 'WinPhone提示内容',
  `androidExtras` text COMMENT '安卓额外内容',
  `iosExtras` text COMMENT 'iOS额外内容',
  `winphoneExtras` text COMMENT 'WinPhone额外内容',
  `message` text COMMENT '消息',
  `messageTitle` text COMMENT '消息标题',
  `messageExtras` text COMMENT '消息额外内容',
  `startTime` int(11) DEFAULT NULL COMMENT '任务开始时间(秒级UNIX时间戳)',
  `endTime` int(11) DEFAULT NULL COMMENT '任务结束时间(秒级UNIX时间戳)',
  `argsJSON` text COMMENT '列表参数JSON',
  `kwargsJSON` text COMMENT '字典参数JSON',
  `retvalJSON` text COMMENT '执行结果JSON',
  `status` varchar(64) DEFAULT '' COMMENT '任务状态: SUCCESS|FAILURE',
  `einfoTEXT` text COMMENT '错误信息TEXT',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  KEY `task` (`task`),
  KEY `origin` (`origin`),
  KEY `accountId` (`accountId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='极光推送任务结果';

DROP TABLE IF EXISTS `biz_main_task_result_mail`;
CREATE TABLE `biz_main_task_result_mail` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `task` varchar(128) NOT NULL DEFAULT '',
  `origin` varchar(128) DEFAULT NULL,
  `accountId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '帐号Id',
  `teamId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '团队ID',
  `to` text COMMENT '收件人',
  `cc` text COMMENT '抄送',
  `bcc` text COMMENT '密送',
  `title` text COMMENT '标题',
  `startTime` int(11) DEFAULT NULL COMMENT '任务开始时间(秒级UNIX时间戳)',
  `endTime` int(11) DEFAULT NULL COMMENT '任务结束时间(秒级UNIX时间戳)',
  `argsJSON` text COMMENT '列表参数JSON',
  `kwargsJSON` text COMMENT '字典参数JSON',
  `retvalJSON` text COMMENT '执行结果JSON',
  `status` varchar(64) DEFAULT '' COMMENT '任务状态: SUCCESS|FAILURE',
  `einfoTEXT` text COMMENT '错误信息TEXT',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  KEY `task` (`task`),
  KEY `origin` (`origin`),
  KEY `accountId` (`accountId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='邮件任务结果';

DROP TABLE IF EXISTS `biz_main_task_result_old_sms`;
CREATE TABLE `biz_main_task_result_old_sms` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `task` varchar(128) NOT NULL DEFAULT '',
  `origin` varchar(128) DEFAULT NULL,
  `accountId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '帐号Id',
  `teamId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '团队ID',
  `to` text COMMENT '收件人',
  `content` text COMMENT '短信内容',
  `startTime` int(11) DEFAULT NULL COMMENT '任务开始时间(秒级UNIX时间戳)',
  `endTime` int(11) DEFAULT NULL COMMENT '任务结束时间(秒级UNIX时间戳)',
  `argsJSON` text COMMENT '列表参数JSON',
  `kwargsJSON` text COMMENT '字典参数JSON',
  `retvalJSON` text COMMENT '执行结果JSON',
  `status` varchar(64) DEFAULT '' COMMENT '任务状态: SUCCESS|FAILURE',
  `einfoTEXT` text COMMENT '错误信息TEXT',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  KEY `task` (`task`),
  KEY `origin` (`origin`),
  KEY `accountId` (`accountId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='旧平台短信任务结果';

DROP TABLE IF EXISTS `wat_main_access_key`;
CREATE TABLE `wat_main_access_key` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `organizationId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `userId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
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
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
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
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `uniqueId` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '',
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
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `organizationId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `userId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
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
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `task` varchar(128) NOT NULL DEFAULT '',
  `origin` varchar(128) DEFAULT NULL,
  `startTime` int(11) DEFAULT NULL,
  `endTime` int(11) DEFAULT NULL,
  `argsJSON` text,
  `kwargsJSON` text,
  `retvalJSON` text,
  `status` varchar(64) DEFAULT '',
  `einfoTEXT` text,
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ID` (`id`),
  KEY `task` (`task`),
  KEY `origin` (`origin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `wat_main_user`;
CREATE TABLE `wat_main_user` (
  `seq` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
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
  `entityId` char(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `entityName` varchar(64) NOT NULL DEFAULT '',
  `tagK` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `tagV` text,
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `TAG` (`entityId`,`tagK`),
  KEY `ENTITY_ID` (`entityId`),
  KEY `TAG_K` (`tagK`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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