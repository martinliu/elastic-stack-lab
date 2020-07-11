# Beats 最佳实践

## 准备 ES 集群

创建冷热分层的集群。

Kibana 访问地址

https://c586fdd9e810483aa11ab58455fa84e5.asia-east1.gcp.elastic-cloud.com:9243/

Cloud ID For-Long-Demo:YXNpYS1lYXN0MS5nY3AuZWxhc3RpYy1jbG91ZC5jb20kMGE1MTA1MWZjOTEwNDcwMjhjYzIzMTQ5N2UxMjBjMTkkYzU4NmZkZDllODEwNDgzYWExMWFiNTg0NTVmYTg0ZTU=




## 创建 Beats 写入角色和用户

创建 beats-writer 角色

创建 beats-writer 用户，自定义一个安全的复杂密码 (DevOpsMeetup)。

## 安装和初始化配置 Beats

在 MacOS 上手工下载 filebbeat metricbeat auditbeat 解压缩这些 tar 包。

初始化 Beats 后台配置

创建索引，导入 Kibana 可视化工具。

./filebeat setup -e \
  -E output.logstash.enabled=false \
  -E cloud.id="For-Long-Demo:YXNpYS1lYXN0MS5nY3AuZWxhc3RpYy1jbG91ZC5jb20kMGE1MTA1MWZjOTEwNDcwMjhjYzIzMTQ5N2UxMjBjMTkkYzU4NmZkZDllODEwNDgzYWExMWFiNTg0NTVmYTg0ZTU=" \
  -E cloud.auth="elastic:SpOqnJs5m1yE4pgfpzNXl6kP" \
  -E setup.kibana.host=https://c586fdd9e810483aa11ab58455fa84e5.asia-east1.gcp.elastic-cloud.com:9243


./metricbeat setup -e \
  -E output.logstash.enabled=false \
  -E cloud.id="For-Long-Demo:YXNpYS1lYXN0MS5nY3AuZWxhc3RpYy1jbG91ZC5jb20kMGE1MTA1MWZjOTEwNDcwMjhjYzIzMTQ5N2UxMjBjMTkkYzU4NmZkZDllODEwNDgzYWExMWFiNTg0NTVmYTg0ZTU=" \
  -E cloud.auth="elastic:SpOqnJs5m1yE4pgfpzNXl6kP" \
  -E setup.kibana.host=https://c586fdd9e810483aa11ab58455fa84e5.asia-east1.gcp.elastic-cloud.com:9243


./auditbeat setup -e \
  -E output.logstash.enabled=false \
  -E cloud.id="For-Long-Demo:YXNpYS1lYXN0MS5nY3AuZWxhc3RpYy1jbG91ZC5jb20kMGE1MTA1MWZjOTEwNDcwMjhjYzIzMTQ5N2UxMjBjMTkkYzU4NmZkZDllODEwNDgzYWExMWFiNTg0NTVmYTg0ZTU=" \
  -E cloud.auth="elastic:SpOqnJs5m1yE4pgfpzNXl6kP" \
  -E setup.kibana.host=https://c586fdd9e810483aa11ab58455fa84e5.asia-east1.gcp.elastic-cloud.com:9243


./packetbeat setup -e \
  -E output.logstash.enabled=false \
  -E cloud.id="For-Long-Demo:YXNpYS1lYXN0MS5nY3AuZWxhc3RpYy1jbG91ZC5jb20kMGE1MTA1MWZjOTEwNDcwMjhjYzIzMTQ5N2UxMjBjMTkkYzU4NmZkZDllODEwNDgzYWExMWFiNTg0NTVmYTg0ZTU=" \
  -E cloud.auth="elastic:SpOqnJs5m1yE4pgfpzNXl6kP" \
  -E setup.kibana.host=https://c586fdd9e810483aa11ab58455fa84e5.asia-east1.gcp.elastic-cloud.com:9243

heartbeat setup -e \
  -E output.logstash.enabled=false \
  -E cloud.id="For-Long-Demo:YXNpYS1lYXN0MS5nY3AuZWxhc3RpYy1jbG91ZC5jb20kMGE1MTA1MWZjOTEwNDcwMjhjYzIzMTQ5N2UxMjBjMTkkYzU4NmZkZDllODEwNDgzYWExMWFiNTg0NTVmYTg0ZTU=" \
  -E cloud.auth="elastic:SpOqnJs5m1yE4pgfpzNXl6kP" \
  -E setup.kibana.host=https://c586fdd9e810483aa11ab58455fa84e5.asia-east1.gcp.elastic-cloud.com:9243

在 Kibana 的 Dashboard 中查看导入的各种对象。



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


## 优化初始配置和数据

在 Kibana 控制台里查看 Dashboard，查看第一个节点相关的数据。

调整 ILM 策略。

## 在其他的节点上部署 Beats

参考和修改安装脚本，一键式安装和配置 Beats

git clone https://github.com/martinliu/joint-lab.git
cd tencent
sh add-agent.sh

