
-- template 初始化
INSERT INTO `biz_template`(`uuid`,  `owner`,  `name`,  `content`,  `extend`,  `status`,  `creator`,  `updator`,  `createAt`,  `deleteAt`,  `updateAt`)  VALUES  ('dataway',  'SYS',  'dataway  运行状态',  '{\"tags\":  [\"dataway\"],  \"type\":  \"template\",  \"vars\":  [],  \"title\":  \"dataway  运行状态\",  \"charts\":  [{\"pos\":  {\"h\":  5,  \"w\":  4,  \"x\":  0,  \"y\":  0},  \"name\":  \"运行时间\",  \"type\":  \"singlestat\",  \"group\":  {\"name\":  \"总览\"},  \"extend\":  {\"settings\":  {}},  \"queries\":  [{\"name\":  \"\",  \"unit\":  \"天\",  \"color\":  \"#2db7f5\",  \"qtype\":  \"sql\",  \"query\":  {\"q\":  \"SELECT  last(\\\"uptime\\\")  /  86400  FROM  \\\"dataway_self\\\"\"},  \"datasource\":  \"ftinfluxdb\"}]},  {\"pos\":  {\"h\":  5,  \"w\":  4,  \"x\":  4,  \"y\":  0},  \"name\":  \"路由数\",  \"type\":  \"singlestat\",  \"group\":  {\"name\":  \"总览\"},  \"extend\":  {\"settings\":  {}},  \"queries\":  [{\"name\":  \"\",  \"unit\":  \"\",  \"color\":  \"#2db7f5\",  \"qtype\":  \"sql\",  \"query\":  {\"q\":  \"SELECT  last(\\\"route_num\\\")  FROM  \\\"dataway_self\\\"\"},  \"datasource\":  \"ftinfluxdb\"}]},  {\"pos\":  {\"h\":  5,  \"w\":  4,  \"x\":  8,  \"y\":  0},  \"name\":  \"内存使用率\",  \"type\":  \"singlestat\",  \"group\":  {\"name\":  \"总览\"},  \"extend\":  {},  \"queries\":  [{\"name\":  \"\",  \"unit\":  \"%\",  \"color\":  \"#2db7f5\",  \"qtype\":  \"sql\",  \"query\":  {\"q\":  \"SELECT  last(\\\"mem_percent\\\")  FROM  \\\"dataway_self\\\"\"},  \"datasource\":  \"ftinfluxdb\"}]},  {\"pos\":  {\"h\":  5,  \"w\":  4,  \"x\":  0,  \"y\":  5},  \"name\":  \"CPU使用率\",  \"type\":  \"singlestat\",  \"group\":  {\"name\":  \"总览\"},  \"extend\":  {},  \"queries\":  [{\"name\":  \"\",  \"unit\":  \"%\",  \"color\":  \"#2db7f5\",  \"qtype\":  \"sql\",  \"query\":  {\"q\":  \"SELECT  last(\\\"cpu_percent\\\")  FROM  \\\"dataway_self\\\"\"},  \"datasource\":  \"ftinfluxdb\"}]},  {\"pos\":  {\"h\":  5,  \"w\":  4,  \"x\":  4,  \"y\":  5},  \"name\":  \"客户端数\",  \"type\":  \"singlestat\",  \"group\":  {\"name\":  \"总览\"},  \"extend\":  {},  \"queries\":  [{\"name\":  \"\",  \"unit\":  \"个\",  \"color\":  \"#2db7f5\",  \"qtype\":  \"sql\",  \"query\":  {\"q\":  \"SELECT  COUNT(DISTINCT(\\\"f_client_uuid\\\"))  FROM  \\\"dataway_client\\\"\"},  \"datasource\":  \"ftinfluxdb\"}]},  {\"pos\":  {\"h\":  5,  \"w\":  4,  \"x\":  8,  \"y\":  5},  \"name\":  \"数据上报错误次数\",  \"type\":  \"singlestat\",  \"group\":  {\"name\":  \"总览\"},  \"extend\":  {},  \"queries\":  [{\"name\":  \"\",  \"unit\":  \"次\",  \"color\":  \"#2db7f5\",  \"qtype\":  \"sql\",  \"query\":  {\"q\":  \"SELECT  last(\\\"1min_report_err_cnt\\\")  FROM  \\\"dataway_self\\\"\"},  \"datasource\":  \"ftinfluxdb\"}]},  {\"pos\":  {\"h\":  10,  \"w\":  12,  \"x\":  12,  \"y\":  0},  \"name\":  \"基本信息\",  \"type\":  \"table\",  \"group\":  {\"name\":  \"总览\"},  \"extend\":  {\"settings\":  {\"pageSize\":  50,  \"queryMode\":  \"toMergeColumn\"}},  \"queries\":  [{\"name\":  \"当前版本\",  \"unit\":  \"\",  \"qtype\":  \"sql\",  \"query\":  {\"q\":  \"SELECT  last(\\\"version\\\")  FROM  \\\"dataway_self\\\"\"},  \"datasource\":  \"ftinfluxdb\"},  {\"name\":  \"主机hostname\",  \"unit\":  \"\",  \"qtype\":  \"sql\",  \"query\":  {\"q\":  \"SELECT  last (\\\"f_hostname\\\") FROM \\\"dataway_self\\\"\"}, \"datasource\": \"ftinfluxdb\"}, {\"name\": \"主机IP\", \"unit\": \"\", \"qtype\": \"sql\", \"query\": {\"q\": \"SELECT last(\\\"f_ip_addrs\\\") FROM \\\"dataway_self\\\"\"}, \"datasource\": \"ftinfluxdb\"}, {\"name\": \"进程号\", \"unit\": \"\", \"qtype\": \"sql\", \"query\": {\"q\": \"SELECT last(\\\"pid\\\") FROM \\\"dataway_self\\\"\"}, \"datasource\": \"ftinfluxdb\"}, {\"name\": \"网关地址\", \"unit\": \"\", \"qtype\": \"sql\", \"query\": {\"q\": \"SELECT last(\\\"f_dataway_addr\\\") FROM \\\"dataway_self\\\"\"}, \"datasource\": \"ftinfluxdb\"}, {\"name\": \"主机CPU核数\", \"unit\": \"个\", \"qtype\": \"sql\", \"query\": {\"q\": \"SELECT last(\\\"cpu_cores\\\") FROM \\\"dataway_self\\\"\"}, \"datasource\": \"ftinfluxdb\"}, {\"name\": \"主机内存大小\", \"unit\": \"G\", \"qtype\": \"sql\", \"query\": {\"q\": \"SELECT last(\\\"mem_total\\\")/1024/1024/1024 FROM \\\"dataway_self\\\"\"}, \"datasource\": \"ftinfluxdb\"}]}, {\"pos\": {\"h\": 10, \"w\": 12, \"x\": 0, \"y\": 10}, \"name\": \"CPU使用率\", \"type\": \"line\", \"group\": {\"name\": \"CPU和内存使用率\"}, \"extend\": {}, \"queries\": [{\"name\": \"CPU使用率\", \"unit\": \"%\", \"color\": \"#2db7f5\", \"qtype\": \"sql\", \"query\": {\"q\": \"SELECT \\\"cpu_percent\\\" FROM \\\"dataway_self\\\"\"}, \"datasource\": \"ftinfluxdb\"}]}, {\"pos\": {\"h\": 10, \"w\": 12, \"x\": 12, \"y\": 10}, \"name\": \"内存使用率\", \"type\": \"line\", \"group\": {\"name\": \"CPU和内存使用率\"}, \"extend\": {}, \"queries\": [{\"name\": \"内存使用率\", \"unit\": \"%\", \"color\": \"#2db7f5\", \"qtype\": \"sql\", \"query\": {\"q\": \"SELECT \\\"mem_percent\\\" FROM \\\"dataway_self\\\"\"}, \"datasource\": \"ftinfluxdb\"}]}, {\"pos\": {\"h\": 10, \"w\": 12, \"x\": 0, \"y\": 20}, \"name\": \"每分钟接收和上报的数据量\", \"type\": \"line\", \"group\": {\"name\": \"网络\"}, \"extend\": {}, \"queries\": [{\"name\": \"每分钟接收数据量\", \"unit\": \"bytes\", \"color\": \"#2db7f5\", \"qtype\": \"sql\", \"query\": {\"q\": \"SELECT \\\"1min_in_bytes\\\" FROM \\\"dataway_self\\\"\"}, \"datasource\": \"ftinfluxdb\"}, {\"name\": \"每分钟上报数据量\", \"unit\": \"bytes\", \"color\": \"#0AEEDA\", \"qtype\": \"sql\", \"query\": {\"q\": \"SELECT \\\"1min_out_bytes\\\" FROM \\\"dataway_self\\\"\"}, \"datasource\": \"ftinfluxdb\"}]}, {\"pos\": {\"h\": 10, \"w\": 12, \"x\": 12, \"y\": 20}, \"name\": \"数据请求统计\", \"type\": \"line\", \"group\": {\"name\": \"网络\"}, \"extend\": {}, \"queries\": [{\"name\": \"每分钟接收的请求数\", \"unit\": \"次\", \"color\": \"#2db7f5\", \"qtype\": \"sql\", \"query\": {\"q\": \"SELECT \\\"1min_receive_cnt\\\" FROM \\\"dataway_self\\\"\"}, \"datasource\": \"ftinfluxdb\"}, {\"name\": \"每分钟上报请求数\", \"unit\": \"次\", \"color\": \"#2db7f5\", \"qtype\": \"sql\", \"query\": {\"q\": \"SELECT \\\"1min_request_cnt\\\" FROM \\\"dataway_self\\\"\"}, \"datasource\": \"ftinfluxdb\"}, {\"name\": \"每分钟请求错误数\", \"unit\": \"次\", \"color\": \"#0AEEDA\", \"qtype\": \"sql\", \"query\": {\"q\": \"SELECT \\\"1min_report_err_cnt\\\" FROM \\\"dataway_self\\\"\"}, \"datasource\": \"ftinfluxdb\"}]}, {\"pos\": {\"h\": 10, \"w\": 12, \"x\": 0, \"y\": 30}, \"name\": \"客户端数\", \"type\": \"line\", \"group\": {\"name\": \"其他\"}, \"extend\": {}, \"queries\": [{\"name\": \"客户端数\", \"unit\": \"个\", \"color\": \"#2db7f5\", \"qtype\": \"sql\", \"query\": {\"q\": \"SELECT COUNT(DISTINCT(\\\"f_client_uuid\\\")) FROM \\\"dataway_client\\\" group by time(1m)\"}, \"datasource\": \"ftinfluxdb\"}]}, {\"pos\": {\"h\": 10, \"w\": 12, \"x\": 12, \"y\": 30}, \"name\": \"缓存数统计\", \"type\": \"line\", \"group\": {\"name\": \"其他\"}, \"extend\": {}, \"queries\": [{\"name\": \"缓存数\", \"unit\": \"个\", \"color\": \"#2db7f5\", \"qtype\": \"sql\", \"query\": {\"q\": \"SELECT last(\\\"cache_cnt\\\") FROM \\\"dataway_self\\\" group by time(1m)\"}, \"datasource\": \"ftinfluxdb\"}]}], \"groups\": [\"总览\", \"CPU和内存使用率\", \"网络\", \"其他\"], \"version\": \"1.0\", \"description\": \"dataway 运行状态\"}', NULL, 0, 'SYS', '', 1575629571, -1, -1);
INSERT INTO `biz_template`(`uuid`, `owner`, `name`, `content`, `extend`, `status`, `creator`, `updator`, `createAt`, `deleteAt`, `updateAt`) VALUES ('ft_client', 'SYS', 'ft_client 运行状态', '{\"tags\": [], \"type\": \"template\", \"vars\": [], \"title\": \"ft_client 运行状态\", \"charts\": [{\"pos\": {\"h\": 10, \"w\": 24, \"x\": 0, \"y\": 0}, \"name\": \"基本信息\", \"type\": \"table\", \"extend\": {\"settings\": {\"pageSize\": 50, \"queryMode\": \"toMergeColumn\"}}, \"queries\": [{\"name\": \"上报路由\", \"unit\": \"\", \"color\": \"#2db7f5\", \"qtype\": \"sql\", \"query\": {\"q\": \"SELECT last(\\\"f_route\\\") FROM \\\"dataway_client\\\"\"}, \"datasource\": \"ftinfluxdb\"}, {\"name\": \"采集器类型\", \"unit\": \"\", \"color\": \"#2db7f5\", \"qtype\": \"sql\", \"query\": {\"q\": \"SELECT last(\\\"f_user_agent\\\") FROM \\\"dataway_client\\\"\"}, \"datasource\": \"ftinfluxdb\"}, {\"name\": \"当前版本\", \"unit\": \"\", \"color\": \"#2db7f5\", \"qtype\": \"sql\", \"query\": {\"q\": \"SELECT last(\\\"f_version\\\") FROM \\\"dataway_client\\\"\"}, \"datasource\": \"ftinfluxdb\"}, {\"name\": \"IP\", \"unit\": \"\", \"color\": \"#2db7f5\", \"qtype\": \"sql\", \"query\": {\"q\": \"SELECT last(\\\"f_ip\\\") FROM \\\"dataway_client\\\"\"}, \"datasource\": \"ftinfluxdb\"}]}, {\"pos\": {\"h\": 10, \"w\": 12, \"x\": 0, \"y\": 10}, \"name\": \"Dataway每分钟接收数据量\", \"type\": \"line\", \"extend\": {}, \"queries\": [{\"name\": \"每分钟接收数据量\", \"unit\": \"bytes\", \"color\": \"#2db7f5\", \"qtype\": \"sql\", \"query\": {\"q\": \"SELECT \\\"1min_in_bytes\\\" FROM \\\"dataway_client\\\"\"}, \"datasource\": \"ftinfluxdb\"}]}, {\"pos\": {\"h\": 10, \"w\": 12, \"x\": 12, \"y\": 10}, \"name\": \"每分钟上报数据量\", \"type\": \"line\", \"extend\": {}, \"queries\": [{\"name\": \"每分钟上报数据量\", \"unit\": \"bytes\", \"color\": \"#2db7f5\", \"qtype\": \"sql\", \"query\": {\"q\": \"SELECT \\\"1min_out_bytes\\\" FROM \\\"dataway_client\\\"\"}, \"datasource\": \"ftinfluxdb\"}]}], \"groups\": [], \"version\": \"1.0\", \"description\": \"\"}', NULL, 0, 'SYS', '', 1575629571, -1, -1);
INSERT INTO `biz_template`(`uuid`, `owner`, `name`, `content`, `extend`, `status`, `creator`, `updator`, `createAt`, `deleteAt`, `updateAt`) VALUES ('my_dashboard', 'SYS', '我的', '{\"tags\": [], \"type\": \"template\", \"vars\": [], \"title\": \"我的\", \"charts\": [{\"pos\": {\"h\": 20, \"w\": 12, \"x\": 0, \"y\": 0}, \"name\": \"快速上手指南\", \"type\": \"text\", \"group\": {\"name\": \"图表\"}, \"extend\": {\"settings\": {}}, \"queries\": [{\"query\": {\"content\": \"# 快速上手指南\\n\\n欢迎使用 DataFlux 实时数据洞察分析平台。DataFlux 是由驻云公司打造的，面向全场景的数据洞察分析平台，具有强实时性、简单易用、强大的数据分析能力等特点，接下来让我们花10分钟体验下 Dataflux 的强大的数据分析功能。\\n\\n## 数据采集\\n\\nDataFlux 开发了专门的数据采集工具 DataKit，DataKit 支持多种标准化的数据源的数据采集。另外 DataKit 采集数据后需发送到数据网关 DataWay，DataWay 再将数据上报到 DataFlux 中进行洞察分析和异常检测。DataWay 除了可以做数据采集的代理网关，可以在DataWay 中进行数据的清洗等相关操作。\\n\\n![](https://xg-test1.oss-cn-beijing.aliyuncs.com/dataflux/data_scrap.png)\\n\\n### 第一步:部署 DataWay\\n\\n登录 DataFlux，进入 管理 - DataWay 网关管理，点击「添加 DataWay」，输入 DataWay 名称，点击「确认」会生成 Dataway 安装脚本。复制 DataWay 安装脚本到部署 DataWay 的服务器中执行即可。\\n\\n![](https://xg-test1.oss-cn-beijing.aliyuncs.com/dataflux/dataway_install_script.png)\\n\\n安装成功后 Dataway 会自动运行，且终端会提示 Dataway 状态管理命令。\\n\\n![](https://xg-test1.oss-cn-beijing.aliyuncs.com/dataflux/dataway_install_success.png)\\n\\n\\n**注意：Dataway 只支持在 Linux 服务器上部署，且服务器必须能访问外网**\\n\\n### 第二步:部署 DataKit\\n\\n部署好 DataWay 网关后，接下来则需要部署 DataKit 进行数据采集。\\n\\n点击 「集成」进入集成界面，点击右侧筛选栏，筛选「采集器」，找到 DataKit 采集器，点击 「DataKit 采集器」，安装 DataKit 的采集器进行部署即可。\\n\\n![](https://xg-test1.oss-cn-beijing.aliyuncs.com/dataflux/datakit_install.png)\\n\\n## 数据洞察\\n\\n数据采集并上报到 DataFlux 后，可在 DataFlux 中查看当前工作空间中已经接收到的上报指标。\\n\\n进入 「查询」- 「指标浏览」即可查看当前工作空间的所有采集的指标。\\n\\n![](https://xg-test1.oss-cn-beijing.aliyuncs.com/dataflux/metics.png)\\n\\n指标浏览只是提供了一个快速查看当前工作空间的数据指标的工具，更重要的是，你可以根据不同的视角构建不同的洞察场景对数据进行分析。\\n\\n### 构建洞察场景\\n\\n在 DataFlux 中最有特色的一个功能是，你可以根据不同的视角构建不同的洞察「场景」从而满足不同业务的数据分析和洞察的需求。\\n\\n进入「管理」- 「场景管理」，点击「+添加场景」，输入场景名称和描述，即可创建一个新的洞察场景。\\n\\n![](https://xg-test1.oss-cn-beijing.aliyuncs.com/dataflux/create_sence.png)\\n\\n场景创建成功后，回到「洞察」界面，选择刚创建的场景名，添加「+添加节点」接口开始场景数据洞察的信息结构的构建。\\n\\n![](https://xg-test1.oss-cn-beijing.aliyuncs.com/dataflux/create_sence_struc.png)\\n\\n在节点弹框中，可设置节点名称、节点的数据范围、节点对应的视图模板，已经是否根据采集的指标的标签自动生成该节点的子节点。\\n\\n你也可以不选择视图模板，默认会创建一个空白的视图模板，后续和自定义该视图模板中的图表。\\n\\n![](https://xg-test1.oss-cn-beijing.aliyuncs.com/dataflux/create_node.png)\\n\\n开启了自动生成子节点后，会根据你选择的标签自动生成对应的子节点。\\n\\n![](https://xg-test1.oss-cn-beijing.aliyuncs.com/dataflux/child_node.png)\\n\\n选中节点，点击「添加图表」，则可以向该节点的视图中添加图表。\\n\\n![](https://xg-test1.oss-cn-beijing.aliyuncs.com/dataflux/create_chart.png)\\n\\n添加图表时，可选择查询的指标、图表类型、已经指标的时间范围，选择好后，点击「保存图图表」则该图表会保存到该节点的视图中。\\n\\n在视图中，数据默认会实时刷新，同时你也可以通过时间选择组件快速切换视图中图表的时间范围。\\n\\n![](https://xg-test1.oss-cn-beijing.aliyuncs.com/dataflux/node_view.png)\\n\\n\\n### 自定义查询\\n\\n除了通过构建场景对数据进行洞察外，你你可以选择「自定义查询」对指标进行实时分析和查询。\\n\\n进入「查询」-「自定义查询」，选择需要查询的指标，以及展示的图表类型即可对数据进行分析。\\n\\n![](https://xg-test1.oss-cn-beijing.aliyuncs.com/dataflux/custom_search.png)\\n\\n更多功能请参考官方帮助中心\\n\"}}]}, {\"pos\": {\"h\": 20, \"w\": 12, \"x\": 12, \"y\": 0}, \"name\": \"定制我的概览页\", \"type\": \"text\", \"group\": {\"name\": \"图表\"}, \"extend\": {\"settings\": {}}, \"queries\": [{\"query\": {\"content\": \"# 定制我的概览页\\n\\nDataFlux 「我的概览」页支持自定义，你可以将常用的场景、视图、图表钉到「我的概览」页面。\\n\\n## 将场景钉到我概览页\\n\\n进入「管理」-「场景管理」，找到需要钉到概览页的场景，点击右上角下拉菜单，选择「钉到」-「我的概览」，即可将该场景钉到我的概览页面。\\n\\n钉到概览页后，点击该场景，即可跳转到对应的场景。\\n\\n![](https://xg-test1.oss-cn-beijing.aliyuncs.com/dataflux/add_sence_to_dashboard.png)\\n\\n## 将视图钉到我概览页\\n\\n进入「洞察」，选择「场景」，找到需要的钉到「我的概念」的视图，点击右上角的钉到图标，选择钉到「我的概览」即可将该视图钉到概览页。\\n\\n钉到概览页后，点击该视图，即可跳转到对应的视图。\\n\\n![](https://xg-test1.oss-cn-beijing.aliyuncs.com/dataflux/add_view_to_mydashboard.png)\\n\\n## 将图表钉到我概览页\\n\\n可以通过 2 个方式将图表钉到概览页：\\n\\n在「洞察」页面，选择需要钉到「我的概览」的图表，点击图表右上角的下拉菜单，选择「钉到」-「我的概览」页即可将该图表钉到「我的概览页」\\n\\n![](https://xg-test1.oss-cn-beijing.aliyuncs.com/dataflux/add_custom_chart_to_dashboard.png)\\n\\n在「查询」-「自定义查询」界面，设置好查询条件后，点击图表右上角的下拉菜单，选择「钉到」-「我的首页」即可将该图表钉到「我的首页」\\n\\n![](https://xg-test1.oss-cn-beijing.aliyuncs.com/dataflux/add_view_chart_to_dashboard.png)\\n\\n\\n## 我的概览管理\\n\\n在概览页，可以拖拽同一个分组下的元素进行排序，同时点击右上角下拉按钮，可以将该元素移除我的概览页\\n\\n![](https://xg-test1.oss-cn-beijing.aliyuncs.com/dataflux/my_dashboard.png)\\n\"}}]}], \"groups\": [\"场景\", \"视图\", \"图表\"], \"version\": \"1.0\", \"description\": \"\"}', NULL, 0, 'SYS', '', 1575629571, -1, -1);
INSERT INTO `biz_template`(`uuid`, `owner`, `name`, `content`, `extend`, `status`, `creator`, `updator`, `createAt`, `deleteAt`, `updateAt`) VALUES ('workspace_overview', 'SYS', '工作空间概览', '{\"tags\": [], \"type\": \"template\", \"vars\": [], \"title\": \"工作空间概览\", \"charts\": [], \"groups\": [\"场景\", \"视图\", \"图表\"], \"version\": \"1.0\", \"description\": \"\"}', NULL, 0, 'SYS', '', 1575629571, -1, -1);
