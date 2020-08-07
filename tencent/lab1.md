# 腾讯云下 Elastic Stack 的 Beats 部署最佳实践

主题：腾讯云下 Elastic Stack 的 Beats 部署最佳实践

## 概述：

使用 Elastic Stack 的各种 Beats 模块可以彻底的终结在服务器上手工捞日志查指标的扭曲实践。利用腾讯云提供的 Elasticsearch 服务，可以轻松搞定大规模云环境的运维。本文一次性的帮你梳理清楚基必备的基础操作，确保你能用 Elastic Stack 安全、稳定和扩展的持续监控你的生产环境。

## 准备 ES 集群

登录腾讯云服务控制台，查询并进入 Elasticsearc 服务，点击新建按钮，创建 Elasticsearch 集群。如下图所示。

[](qcloud-es.jpeg)


创建冷热分层的集群。

启用 Kibana 内网地址： http://es-ot7wei87.internal.kibana.tencentelasticsearch.com:5601


## 创建 Beats 写入角色和用户

创建 beats-writer 角色

创建 beats-writer 用户，自定义一个安全的复杂密码。

## 安装和初始化配置 Beats

安装脚本

```
elastic_version='7.5.1'
b_rpm='https://mirrors.cloud.tencent.com/elasticstack/7.x/yum'

echo "############## Installing  Beats "$elastic_version" ..."

yum install -y $b_rpm/$elastic_version/filebeat-$elastic_version-x86_64.rpm
systemctl enable  filebeat.service
filebeat modules enable system

yum install -y $b_rpm/$elastic_version/metricbeat-$elastic_version-x86_64.rpm
systemctl enable  metricbeat.service

yum install -y $b_rpm/$elastic_version/auditbeat-$elastic_version-x86_64.rpm
systemctl enable  auditbeat.service
```

初始化 Beats 后台配置

创建索引，导入 Kibana 可视化工具。

```
filebeat setup -e \
  -E output.logstash.enabled=false \
  -E output.elasticsearch.hosts=['192.168.0.43:9200'] \
  -E output.elasticsearch.username=elastic \
  -E output.elasticsearch.password=JointLab@987 \
  -E setup.kibana.host=es-ot7wei87.internal.kibana.tencentelasticsearch.com:5601


metricbeat setup -e   \
  -E output.elasticsearch.hosts=['192.168.0.43:9200']   \
  -E output.elasticsearch.username=elastic   \
  -E output.elasticsearch.password=JointLab@987   \
  -E setup.kibana.host=es-ot7wei87.internal.kibana.tencentelasticsearch.com:5601

auditbeat setup -e \
  -E output.elasticsearch.hosts=['192.168.0.43:9200'] \
  -E output.elasticsearch.username=elastic \
  -E output.elasticsearch.password=JointLab@987 \
  -E setup.kibana.host=es-ot7wei87.internal.kibana.tencentelasticsearch.com:5601
```

更新配置文件，启动 Beats 服务。

讲解 

* keystore 的使用，
* 配置文件中因此机密信息

```
echo "################### Update Beats configuration files ..."

cp -f filebeat-v1.yml /etc/filebeat/filebeat.yml
cp -f metricbeat-v1.yml /etc/metricbeat/metricbeat.yml
cp -f auditbeat.yml /etc/auditbeat/auditbeat.yml

echo "################### Setup Keystor for Beats ..."

echo $b_es  | sudo filebeat keystore add INT_ES_SRV --stdin --force
echo $b_user  | sudo filebeat keystore add BEATS_WRITER_USERNAME --stdin --force
echo $b_pwd   | sudo filebeat keystore add BEATS_WRITER_PW --stdin --force

echo $b_es  | sudo metricbeat keystore add INT_ES_SRV --stdin --force
echo $b_user  | sudo metricbeat keystore add BEATS_WRITER_USERNAME --stdin --force
echo $b_pwd   | sudo metricbeat keystore add BEATS_WRITER_PW --stdin --force

echo $b_es  | sudo auditbeat keystore add INT_ES_SRV --stdin --force
echo $b_user  | sudo auditbeat keystore add BEATS_WRITER_USERNAME --stdin --force
echo $b_pwd   | sudo auditbeat keystore add BEATS_WRITER_PW --stdin --force

echo "################### Start Beats services ..."

sudo systemctl start  metricbeat.service
sudo systemctl start  filebeat.service
sudo systemctl start  auditbeat.service
```

## 优化初始配置和数据

在 Kibana 控制台里查看 Dashboard，查看第一个节点相关的数据。

调整 ILM 策略。

## 在其他的节点上部署 Beats

参考和修改安装脚本，一键式安装和配置 Beats

```
git clone https://github.com/martinliu/joint-lab.git
cd tencent
sh add-agent.sh
```

## 最佳实践配置

* 讲解不同 Beats 中共性的配置， ILM， spool， logging.level,
* ECS 扩展字段
* 启用监控
* 位置数据
