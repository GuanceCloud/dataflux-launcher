CREATE DATABASE IF NOT EXISTS `dialtesting`;
USE `dialtesting`;

DROP TABLE IF EXISTS `aksk`;
CREATE TABLE `dialtesting`.`aksk` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 aksk_ 前缀',
  `accessKey` varchar(20) NOT NULL COMMENT '推送 commit 的 AK',
  `secretKey` varchar(40) NOT NULL COMMENT '推送 commit 的 SK',
  `owner` varchar(128) NOT NULL COMMENT 'AK 归属',
  `parent_ak` varchar(48) NOT NULL DEFAULT '',
  `external_id` varchar(128) NOT NULL DEFAULT '',
  `status` enum('OK','DISABLED') NOT NULL DEFAULT 'OK' COMMENT 'AK 状态',
  `version` int(11) NOT NULL DEFAULT '1' COMMENT 'AK 版本，便于 AK 验证方式变更（not used）',
  `createAt` int(11) NOT NULL DEFAULT '-1',
  `updateAt` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一',
  UNIQUE KEY `uk_ak` (`accessKey`) COMMENT 'AK 做成全局唯一',
  UNIQUE KEY `uk_sk` (`secretKey`) COMMENT 'SK 做成全局唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `region`;
CREATE TABLE `dialtesting`.`region` (
  `id` int(16) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL DEFAULT '' COMMENT '全局唯一',
  `city` varchar(48) NOT NULL DEFAULT '' COMMENT '如果是海外：国家 + 城市；如果国内：省份 + 城市',
  `country` varchar(48) NOT NULL DEFAULT '',
  `province` varchar(48) NOT NULL DEFAULT '',
  `name` varchar(128) NOT NULL COMMENT '部署区域',
  `internal` tinyint(4) NOT NULL COMMENT '中国,则为true; 海外,则为false',
  `owner` enum('custom','default') NOT NULL DEFAULT 'default',
  `heartbeat` bigint(16) NOT NULL DEFAULT '-1',
  `keycode` varchar(48) NOT NULL DEFAULT '',
  `external_id` varchar(128) NOT NULL DEFAULT '',
  `isp` varchar(48) NOT NULL DEFAULT '' COMMENT '如电信/连通/移动/未知等',
  `status` enum('OK','DISABLED') NOT NULL DEFAULT 'OK' COMMENT '当前region 状态',
  `createAt` bigint(16) NOT NULL DEFAULT '-1',
  `updateAt` bigint(16) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uid` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `task`;
CREATE TABLE `dialtesting`.`task` (
  `id` int(16) NOT NULL AUTO_INCREMENT COMMENT '自增 ID',
  `uuid` varchar(48) NOT NULL COMMENT '全局唯一 ID，带 dialt_ 前缀',
  `external_id` varchar(128) NOT NULL COMMENT '外部 ID',
  `class` enum('BROWSER','HEADLESS','HTTP','TCP','DNS','OTHER','ICMP','WEBSOCKET') NOT NULL DEFAULT 'OTHER' COMMENT '任务分类',
  `region_uuid` varchar(128) NOT NULL DEFAULT '',
  `owner_external_id` varchar(128) NOT NULL DEFAULT '',
  `task` text NOT NULL COMMENT '任务的 json 描述',
  `createAt` bigint(16) NOT NULL DEFAULT '-1',
  `updateAt` bigint(16) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uuid` (`uuid`) COMMENT 'UUID 做成全局唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
