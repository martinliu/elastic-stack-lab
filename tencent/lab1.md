# Beats 最佳实践

## 准备 ES 集群

创建冷热分层的集群。

启用 Kibana 内网地址： http://es-ot7wei87.internal.kibana.tencentelasticsearch.com:5601


## 创建 Beats 写入角色和用户

创建 beats-writer 角色

创建 beats-writer 用户，自定义一个安全的复杂密码。

## 安装和初始化配置 Beats

安装脚本


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

初始化 Beats 后台配置

创建索引，导入 Kibana 可视化工具。

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

更新配置文件，启动 Beats 服务。

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
