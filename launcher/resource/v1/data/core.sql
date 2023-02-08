-- 免费额度限制配置
INSERT INTO `main_config`(`keyCode`, `description`, `value`) VALUES ('FreeLimitV2', '免费额度', '{\"ts\": 3000, \"job\": 100000, \"rum_pv\": 2000, \"logs\": 1000000, \"trace\": 8000, \"dialing_api\": 200000}') ON DUPLICATE KEY UPDATE description=VALUES(description),value=VALUES(value);

-- 插入付费版工作空间使用量和计费统计公式
INSERT INTO `main_config`(`keyCode`, `description`, `value`) VALUES ('MeteringUnitPriceConfig', 'priceQuantity表示价格对应的数量，price表示priceQuantity数量对应的价格，discountQuantity表示免费额度，equation是计算公式, count_equation是账单计算时的统计数量计算公式', '{\"ts\": {\"price\": 3, \"equation\": \"(count/priceQuantity)*price\", \"countEquation\": \"max(0, count - datakit_count * 300)\", \"priceQuantity\": 300, \"discountQuantity\": 0}, \"job\": {\"price\": 1, \"equation\": \"(count/priceQuantity)*price\", \"countEquation\": \"count\", \"priceQuantity\": 10000, \"discountQuantity\": 0}, \"sms\": {\"price\": 1, \"equation\": \"count*price\", \"countEquation\": \"count\", \"priceQuantity\": 10, \"discountQuantity\": 0}, \"rum_pv\": {\"price\": 1, \"equation\": \"(count/priceQuantity)*price\", \"countEquation\": \"count\", \"priceQuantity\": 10000, \"discountQuantity\": 0}, \"datakit\": {\"price\": 3, \"equation\": \"count*price\", \"countEquation\": \"count\", \"priceQuantity\": 1, \"discountQuantity\": 0}, \"logging\": {\"price\": 1.5, \"equation\": \"(count/priceQuantity)*price\", \"countEquation\": \"sum([count, keyevent_count, security_count])\", \"priceQuantity\": 1000000, \"discountQuantity\": 0}, \"tracing\": {\"price\": 3, \"equation\": \"(count/priceQuantity)*price\", \"countEquation\": \"count\", \"priceQuantity\": 1000000, \"discountQuantity\": 0}, \"api_test\": {\"price\": 1, \"equation\": \"(count/priceQuantity)*price\", \"countEquation\": \"count\", \"priceQuantity\": 10000, \"discountQuantity\": 0}, \"backup_log\": {\"price\": 2, \"equation\": \"(count/priceQuantity)*price\", \"countEquation\": \"count\", \"priceQuantity\": 10000000, \"discountQuantity\": 0}}') ON DUPLICATE KEY UPDATE description=VALUES(description),value=VALUES(value);

-- 插入体验版工作空间使用量统计配置
INSERT INTO `main_config` (`keyCode`,`description`,`value`) VALUES ('FreeMeteringUnitConfig','体验版工作空间使用量统计计算配置; priceQuantity表示价格对应的数量，price表示priceQuantity数量对应的价格，discountQuantity表示免费额度，equation是计算公式, count_equation是账单计算时的统计数量计算公式','{\"ts\": {\"price\": 0, \"equation\": \"0\", \"countEquation\": \"count\", \"priceQuantity\": 1, \"discountQuantity\": 0}, \"job\": {\"price\": 0, \"equation\": \"0\", \"countEquation\": \"count \", \"priceQuantity\": 10000, \"discountQuantity\": 0}, \"rum_pv\": {\"price\": 0, \"equation\": \"0\", \"countEquation\": \"count\", \"priceQuantity\": 1000, \"discountQuantity\": 0}, \"logging\": {\"price\": 0, \"equation\": \"0\", \"countEquation\": \"sum([count, keyevent_count, security_count])\", \"priceQuantity\": 1000000, \"discountQuantity\": 0}, \"tracing\": {\"price\": 0, \"equation\": \"0\", \"countEquation\": \"count\", \"priceQuantity\": 1000000, \"discountQuantity\": 0}, \"api_test\": {\"price\": 0, \"equation\": \"0\", \"countEquation\": \"count\", \"priceQuantity\": 10000, \"discountQuantity\": 0}}') ON DUPLICATE KEY UPDATE description=VALUES(description),value=VALUES(value);

-- 添加内置对象分类名配置
INSERT INTO `main_config`(`keyCode`, `description`, `value`) VALUES ('BuiltInObjectClass', '内置对象分类列表', '[\"host_processes\", \"docker_containers\", \"kubelet_pod\", \"HOST\", \"kubernetes_pods\", \"kubernetes_services\", \"kubernetes_deployments\", \"kubernetes_clusters\", \"kubernetes_nodes\", \"kubernetes_replica_sets\", \"kubernetes_jobs\", \"kubernetes_cron_jobs\", \"host_processes_history\"]') ON DUPLICATE KEY UPDATE description=VALUES(description),value=VALUES(value);

-- 新增工作空间使用量统计公式
INSERT INTO `main_config` (`keyCode`,`description`,`value`) VALUES ('UsageStatisticalFormula','工作空间使用量统计公式（非计费公式）','{\"job\": {\"countEquation\": \"count\", \"discountQuantity\": 0}, \"rum\": {\"countEquation\": \"count\", \"discountQuantity\": 0}, \"rum_pv\": {\"countEquation\": \"count\", \"discountQuantity\": 0}, \"datakit\": {\"countEquation\": \"count\", \"discountQuantity\": 0}, \"ts\": {\"countEquation\": \"max(0, ts_count - count * 500)\", \"discountQuantity\": 0}, \"logging\": {\"countEquation\": \"count + keyevent_count + security_count\", \"discountQuantity\": 0}, \"tracing\": {\"countEquation\": \"count\", \"discountQuantity\": 0}, \"api_test\": {\"countEquation\": \"count\", \"discountQuantity\": 0}, \"backup_log\": {\"countEquation\": \"count\", \"discountQuantity\": 0}, \"browser_test\": {\"countEquation\": \"count\", \"discountQuantity\": 0}}') ON DUPLICATE KEY UPDATE description=VALUES(description),value=VALUES(value);