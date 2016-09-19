use meteor;

INSERT INTO `def_file_sys` VALUES (100, 101, 100, '导入每分钟心跳数据源', 'ImportKafka', '{\n  \"programClass\" : \"com.meteor.server.executor.ImportKafkaTaskExecutor\",\n  \"CLASS\" : \"com.meteor.model.view.importqueue.ImportKafkaTask\",\n  \"regTable\" : \"ods_heartbeat\",\n  \"beginSleepTime\" : \"0\",\n  \"priority\" : \"2\",\n  \"rePartitionNum\" : \"0\",\n  \"maxRetryTimes\" : \"2\",\n  \"isIgnoreError\" : \"0\",\n  \"threadPoolSize\" : \"1\",\n  \"groupId\" : \"meteor\",\n  \"topics\" : \"demo_heartbeat\",\n  \"finishSleepTime\" : \"0\",\n  \"retryInterval\" : \"0\",\n  \"brokers\" : \"kafka1:9092,kafka2:9092,kafka3:9092\"\n}', 0, '2099-1-1 00:00:00', 'admin', '', 1, '2016-7-11 11:32:38', '2016-9-19 16:27:57', 'admin', 'admin');
INSERT INTO `def_file_sys` VALUES (101, 0, 100, '源头数据', 'Dir', '{\r\n  \"CLASS\" : \"com.meteor.model.view.other.Dir\"\r\n}', 1, '2099-1-1 00:00:00', NULL, '', 1, '2016-7-11 11:32:59', '2016-7-11 11:32:59', 'admin', 'admin');
INSERT INTO `def_file_sys` VALUES (102, 0, 100, '构建中间表模型', 'Dir', '{\r\n  \"CLASS\" : \"com.meteor.model.view.other.Dir\"\r\n}', 1, '2099-1-1 00:00:00', NULL, '', 1, '2016-7-11 11:34:06', '2016-7-11 11:34:06', 'admin', 'admin');
INSERT INTO `def_file_sys` VALUES (103, 102, 100, '清洗ods_heartbeat生成dw_heartbeat', 'SqlTask', '{\n  \"programClass\" : \"com.meteor.server.executor.SqlTaskExecutor\",\n  \"CLASS\" : \"com.meteor.model.view.buildmodel.SqlTask\",\n  \"repartition\" : \"0\",\n  \"maxRetryTimes\" : \"2\",\n  \"isIgnoreError\" : \"0\",\n  \"beginSleepTime\" : \"0\",\n  \"threadPoolSize\" : \"1\",\n  \"sql\" : \"cache table dw_heartbeat as\\r\\nselect \\r\\n    action,\\r\\n    stime,\\r\\n    from_unixtime(unix_timestamp(stime, \'yyyy-MM-dd HH:mm:ss\'), \'yyyyMMdd\') stime_yyyyMMdd,\\r\\n    from_unixtime(unix_timestamp(stime, \'yyyy-MM-dd HH:mm:ss\'), \'yyyyMMddHH\') stime_yyyyMMddHH,\\r\\n    from_unixtime(unix_timestamp(stime, \'yyyy-MM-dd HH:mm:ss\'), \'yyyyMMddHHmm\') stime_yyyyMMddHHmm,\\r\\n    uid,\\r\\n    ref\\r\\nfrom ods_heartbeat\\r\\nwhere uid is not null\",\n  \"finishSleepTime\" : \"0\",\n  \"priority\" : \"2\",\n  \"retryInterval\" : \"0\"\n}', 0, '2099-1-1 00:00:00', 'admin', '', 1, '2016-7-11 11:36:42', '2016-7-12 15:44:48', 'admin', 'admin');
INSERT INTO `def_file_sys` VALUES (104, 0, 100, '统计', 'Dir', '{\r\n  \"CLASS\" : \"com.meteor.model.view.other.Dir\"\r\n}', 1, '2099-1-1 00:00:00', NULL, '', 1, '2016-7-11 11:36:59', '2016-7-11 11:36:59', 'admin', 'admin');
INSERT INTO `def_file_sys` VALUES (105, 104, 100, '统计每天UV -> kafka', 'ExportKafka', '{\n  \"programClass\" : \"com.meteor.server.executor.ExportKafkaTaskExecutor\",\n  \"CLASS\" : \"com.meteor.model.view.export.ExportKafkaTask\",\n  \"toTopic\" : \"uv_day\",\n  \"beginSleepTime\" : \"0\",\n  \"priority\" : \"2\",\n  \"fetchSql\" : \"csql_group_by_n:\\r\\nselect\\r\\n    stime_yyyyMMdd,\\r\\n    c_count_distinct(\'demo.uv_cd\', key(stime_yyyyMMdd), value(uid), 1000, 1, 90000, true) uv_day\\r\\nfrom  dw_heartbeat\\r\\ngroup by stime_yyyyMMdd\",\n  \"toBrokers\" : \"kafka1:9092,kafka2:9092,kafka3:9092\",\n  \"maxRetryTimes\" : \"2\",\n  \"isIgnoreError\" : \"0\",\n  \"threadPoolSize\" : \"1\",\n  \"finishSleepTime\" : \"0\",\n  \"retryInterval\" : \"0\"\n}', 0, '2099-1-1 00:00:00', 'admin', '', 1, '2016-7-11 11:46:22', '2016-9-12 16:20:21', 'admin', 'admin');
INSERT INTO `def_file_sys` VALUES (106, 104, 100, '统计每小时各渠道UV -> kafka', 'ExportKafka', '{\n  \"programClass\" : \"com.meteor.server.executor.ExportKafkaTaskExecutor\",\n  \"CLASS\" : \"com.meteor.model.view.export.ExportKafkaTask\",\n  \"toTopic\" : \"uv_ref_hour\",\n  \"beginSleepTime\" : \"0\",\n  \"priority\" : \"2\",\n  \"fetchSql\" : \"csql_group_by_n:\\r\\nselect\\r\\n    stime_yyyyMMddHH,\\r\\n    ref,\\r\\n    c_count_distinct(\'demo.uv_ref_hour_cd\', key(stime_yyyyMMddHH, ref), value(uid), 1000, 1, 7200, true) uv_ref_hour\\r\\nfrom  dw_heartbeat\\r\\ngroup by stime_yyyyMMddHH, ref\",\n  \"toBrokers\" : \"kafka1:9092,kafka2:9092,kafka3:9092\",\n  \"maxRetryTimes\" : \"2\",\n  \"isIgnoreError\" : \"0\",\n  \"threadPoolSize\" : \"1\",\n  \"finishSleepTime\" : \"0\",\n  \"retryInterval\" : \"0\"\n}', 0, '2099-1-1 00:00:00', 'admin', '', 1, '2016-7-11 11:49:49', '2016-9-12 16:20:26', 'admin', 'admin');
INSERT INTO `def_file_sys` VALUES (107, 104, 100, '统计每分钟在线人数 -> kafka', 'ExportKafka', '{\n  \"programClass\" : \"com.meteor.server.executor.ExportKafkaTaskExecutor\",\n  \"CLASS\" : \"com.meteor.model.view.export.ExportKafkaTask\",\n  \"toTopic\" : \"online_ucnt\",\n  \"beginSleepTime\" : \"0\",\n  \"priority\" : \"2\",\n  \"fetchSql\" : \"csql_group_by_n:\\r\\nselect \\r\\n    stime_yyyyMMddHHmm,\\r\\n    c_count_distinct(\'demo.online_cd\', key(stime_yyyyMMddHHmm), value(uid), 1000, 1, 900, true) online_ucnt\\r\\nfrom dw_heartbeat\\r\\ngroup by stime_yyyyMMddHHmm\",\n  \"toBrokers\" : \"kafka1:9092,kafka2:9092,kafka3:9092\",\n  \"maxRetryTimes\" : \"2\",\n  \"isIgnoreError\" : \"0\",\n  \"threadPoolSize\" : \"1\",\n  \"finishSleepTime\" : \"0\",\n  \"retryInterval\" : \"0\"\n}', 0, '2099-1-1 00:00:00', 'admin', '', 1, '2016-7-11 14:03:00', '2016-9-12 16:20:31', 'admin', 'admin');
INSERT INTO `def_file_sys` VALUES (108, 104, 100, '统计每个用户每天在线时长 -> kafka', 'ExportKafka', '{\n  \"programClass\" : \"com.meteor.server.executor.ExportKafkaTaskExecutor\",\n  \"CLASS\" : \"com.meteor.model.view.export.ExportKafkaTask\",\n  \"toTopic\" : \"online_time\",\n  \"beginSleepTime\" : \"0\",\n  \"priority\" : \"2\",\n  \"fetchSql\" : \"csql_group_by_n:\\r\\nselect \\r\\n    stime_yyyyMMdd,\\r\\n    uid,\\r\\n    c_count_distinct(\'demo.online_time\', key(stime_yyyyMMdd, uid), value(stime_yyyyMMddHHmm), 1000, 1, 90000, false) online_time\\r\\nfrom dw_heartbeat\\r\\ngroup by stime_yyyyMMdd, uid\",\n  \"toBrokers\" : \"kafka1:9092,kafka2:9092,kafka3:9092\",\n  \"maxRetryTimes\" : \"2\",\n  \"isIgnoreError\" : \"0\",\n  \"threadPoolSize\" : \"1\",\n  \"finishSleepTime\" : \"0\",\n  \"retryInterval\" : \"0\"\n}', 0, '2099-1-1 00:00:00', 'admin', '', 1, '2016-7-11 14:05:36', '2016-9-12 16:20:36', 'admin', 'admin');
INSERT INTO `def_file_sys` VALUES (109, 102, 100, '生成历史新用户表(基于cassandra)', 'SqlTask', '{\n  \"programClass\" : \"com.meteor.server.executor.SqlTaskExecutor\",\n  \"CLASS\" : \"com.meteor.model.view.buildmodel.SqlTask\",\n  \"repartition\" : \"0\",\n  \"maxRetryTimes\" : \"2\",\n  \"isIgnoreError\" : \"0\",\n  \"beginSleepTime\" : \"0\",\n  \"threadPoolSize\" : \"1\",\n  \"sql\" : \"cache table dw_new_user as\\r\\nselect \\r\\n    action,\\r\\n    stime,\\r\\n    uid,\\r\\n    ref\\r\\nwhere c_distinct(\'demo.dw_new_user\', 1800, true, 0, \'\', uid, CONCAT(\'{\',\\r\\n        \'\\\\\\\"action\\\\\\\":\\\\\\\"\', action, \'\\\\\\\",\'\\r\\n        \'\\\\\\\"stime\\\\\\\":\\\\\\\"\', stime, \'\\\\\\\",\'  \\r\\n        \'\\\\\\\"uid\\\\\\\":\\\\\\\"\', uid, \'\\\\\\\",\'  \\r\\n        \'\\\\\\\"ref\\\\\\\":\\\\\\\"\', ref, \'\\\\\\\"}\')\",\n  \"finishSleepTime\" : \"0\",\n  \"priority\" : \"2\",\n  \"retryInterval\" : \"0\"\n}', 0, '2016-1-1 00:00:00', 'admin', '', 1, '2016-7-11 14:15:45', '2016-9-19 17:00:45', 'admin', 'admin');
INSERT INTO `def_file_sys` VALUES (110, 104, 100, '用户历史第一次是通过什么渠道进入的(基于cassandra)', 'ExportKafka', '{\n  \"programClass\" : \"com.meteor.server.executor.ExportKafkaTaskExecutor\",\n  \"CLASS\" : \"com.meteor.model.view.export.ExportKafkaTask\",\n  \"toTopic\" : \"user_fist_ref\",\n  \"beginSleepTime\" : \"0\",\n  \"priority\" : \"2\",\n  \"fetchSql\" : \"select\\r\\n    stime,\\r\\n    uid,\\r\\n    ref,\\r\\n    jt_stime first_stime,\\r\\n    jt_ref first_ref\\r\\nfrom  dw_heartbeat\\r\\nLATERAL VIEW c_json_tuple(c_join(\'demo.dw_new_user\', true, true, 0, 1800, \'\', uid), \'stime\', \'ref\') jt as jt_stime, jt_ref\",\n  \"toBrokers\" : \"kafka1:9092,kafka2:9092,kafka3:9092\",\n  \"maxRetryTimes\" : \"2\",\n  \"isIgnoreError\" : \"0\",\n  \"threadPoolSize\" : \"1\",\n  \"finishSleepTime\" : \"0\",\n  \"retryInterval\" : \"0\"\n}', 0, '2016-1-1 00:00:00', 'admin', '', 1, '2016-7-11 14:21:10', '2016-9-12 10:21:04', 'admin', 'admin');
INSERT INTO `def_file_sys` VALUES (111, 104, 100, '统计每天UV -> cache table test', 'SqlTask', '{\n  \"programClass\" : \"com.meteor.server.executor.SqlTaskExecutor\",\n  \"CLASS\" : \"com.meteor.model.view.buildmodel.SqlTask\",\n  \"repartition\" : \"0\",\n  \"maxRetryTimes\" : \"2\",\n  \"isIgnoreError\" : \"0\",\n  \"beginSleepTime\" : \"0\",\n  \"threadPoolSize\" : \"1\",\n  \"sql\" : \"csql_group_by_n:\\r\\nselect\\r\\n    stime_yyyyMMdd,\\r\\n    c_count_distinct(\'demo.uv_cd\', key(stime_yyyyMMdd), value(uid), 1000, 1, 90000, true) uv_day\\r\\nfrom  dw_heartbeat\\r\\ngroup by stime_yyyyMMdd\\r\\n;\\r\\n\\r\\ncache table dw_test as\\r\\nselect *\\r\\nfrom $targetTable\",\n  \"finishSleepTime\" : \"0\",\n  \"priority\" : \"2\",\n  \"retryInterval\" : \"0\"\n}', 0, '2099-1-1 00:00:00', 'admin', '', 1, '2016-9-12 10:52:32', '2016-9-12 16:20:42', 'admin', 'admin');
INSERT INTO `def_file_sys` VALUES (112, 104, 100, '统计每天UV -> mysql', 'ExportJDBC', '{\n  \"programClass\" : \"com.meteor.server.executor.ExportJDBCTaskExecutor\",\n  \"CLASS\" : \"com.meteor.model.view.export.ExportJDBCTask\",\n  \"beginSleepTime\" : \"0\",\n  \"priority\" : \"2\",\n  \"jdbcUsername\" : \"user1\",\n  \"fetchSql\" : \"csql_group_by_n:\\r\\nselect\\r\\n    stime_yyyyMMdd,\\r\\n    c_count_distinct(\'demo.uv_cd\', key(stime_yyyyMMdd), value(uid), 1000, 1, 90000, true) uv_day\\r\\nfrom  dw_heartbeat\\r\\ngroup by stime_yyyyMMdd\",\n  \"jdbcUrl\" : \"jdbc:mysql://127.0.0.1:3306/meteor_gh?useUnicode=true&characterEncoding=utf-8\",\n  \"jdbcDriver\" : \"com.mysql.jdbc.Driver\",\n  \"maxRetryTimes\" : \"2\",\n  \"isIgnoreError\" : \"0\",\n  \"threadPoolSize\" : \"1\",\n  \"insertSql\" : \"insert into test_jdbc(stime_yyyyMMdd, uv_day) values\\r\\n(:stime_yyyyMMdd, :uv_day) ON DUPLICATE KEY UPDATE \\r\\nuv_day=IF(values(uv_day)>uv_day, values(uv_day), uv_day);\",\n  \"jdbcPassword\" : \"123456789\",\n  \"finishSleepTime\" : \"0\",\n  \"retryInterval\" : \"0\"\n}', 0, '2099-1-1 00:00:00', 'admin', 'create table test_jdbc\r\n(\r\n   stime_yyyyMMdd     date not null comment \'\',\r\n   day_uv                 int default 0 comment \'\',\r\n   primary key (stime_yyyyMMdd)\r\n) comment = \'\'\r\nengine = Innodb\r\ndefault charset utf8;', 1, '2016-9-12 11:13:28', '2016-9-19 16:38:31', 'admin', 'admin');


INSERT INTO `def_depend` VALUES (103, 100, 100, NULL, 1, '2016-7-12 15:44:48', '2016-7-12 15:44:48', 'admin', 'admin');
INSERT INTO `def_depend` VALUES (105, 103, 100, NULL, 1, '2016-9-12 16:20:21', '2016-9-12 16:20:21', 'admin', 'admin');
INSERT INTO `def_depend` VALUES (106, 103, 100, NULL, 1, '2016-9-12 16:20:26', '2016-9-12 16:20:26', 'admin', 'admin');
INSERT INTO `def_depend` VALUES (107, 103, 100, NULL, 1, '2016-9-12 16:20:31', '2016-9-12 16:20:31', 'admin', 'admin');
INSERT INTO `def_depend` VALUES (108, 103, 100, NULL, 1, '2016-9-12 16:20:36', '2016-9-12 16:20:36', 'admin', 'admin');
INSERT INTO `def_depend` VALUES (109, 103, 100, NULL, 1, '2016-7-11 14:15:45', '2016-7-11 14:15:45', 'admin', 'admin');
INSERT INTO `def_depend` VALUES (110, 109, 100, NULL, 1, '2016-9-12 10:21:04', '2016-9-12 10:21:04', 'admin', 'admin');
INSERT INTO `def_depend` VALUES (110, 103, 100, NULL, 1, '2016-9-12 10:21:04', '2016-9-12 10:21:04', 'admin', 'admin');
INSERT INTO `def_depend` VALUES (111, 103, 100, NULL, 1, '2016-9-12 16:20:42', '2016-9-12 16:20:42', 'admin', 'admin');
INSERT INTO `def_depend` VALUES (112, 103, 100, NULL, 1, '2016-9-12 16:20:47', '2016-9-12 16:20:47', 'admin', 'admin');




