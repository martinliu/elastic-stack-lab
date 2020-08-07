# Beats 最佳实践

## 创建 Elastic Cloud 账号

Elastic Cloud 是一种SaaS 服务，他允许任何人都可以用可用的邮箱申请，而且免行用卡认证。免费试用账号的周期是 14 天，两周的时间可以基本上满足一定数量的项目的使用需求。

申请网址： https://cloud.elastic.co 

## 准备 ES 集群

创建测试用 Elastic Stack 集群。

记录 Kibana 访问地址 ：https://c586fdd9e810483aa11ab58455fa84e5.asia-east1.gcp.elastic-cloud.com:9243/

Cloud ID ：For-Long-Demo:YXNpYS1lYXN0MS5nY3AuZWxhc3RpYy1jbG91ZC5jb20kMGE1MTA1MWZjOTEwNDcwMjhjYzIzMTQ5N2UxMjBjMTkkYzU4NmZkZDllODEwNDgzYWExMWFiNTg0NTVmYTg0ZTU=

还有最高权限用户名和密码：elastic / xxxxxxxx


## 创建 Beats 写入角色和用户

登录 Kibana 之后。

创建 beats-writer 角色

创建 beats-writer 用户，自定义一个安全的复杂密码 ，本练习使用的密码是 (DevOpsMeetup) 会用在后面的脚本中。

## 安装和初始化 Beats 的配置

在 MacOS 上手工下载 filebbeat metricbeat auditbeat 解压缩这些 tar 包。（你也可以用任何可用的 Linux、MacOS 系统做一下操作）

初始化 Beats 后台配置：导入索引模板、导入 ILM 策略、导入 Kibana 可视控件。

./filebeat setup -e \
  -E output.logstash.enabled=false \
  -E cloud.id="For-Long-Demo:YXNpYS1lYXN0MS5nY3AuZWxhc3RpYy1jbG91ZC5jb20kMGE1MTA1MWZjOTEwNDcwMjhjYzIzMTQ5N2UxMjBjMTkkYzU4NmZkZDllODEwNDgzYWExMWFiNTg0NTVmYTg0ZTU=" \
  -E cloud.auth="elastic:xxxxxx" \
  -E setup.kibana.host=https://c586fdd9e810483aa11ab58455fa84e5.asia-east1.gcp.elastic-cloud.com:9243


./metricbeat setup -e \
  -E output.logstash.enabled=false \
  -E cloud.id="For-Long-Demo:YXNpYS1lYXN0MS5nY3AuZWxhc3RpYy1jbG91ZC5jb20kMGE1MTA1MWZjOTEwNDcwMjhjYzIzMTQ5N2UxMjBjMTkkYzU4NmZkZDllODEwNDgzYWExMWFiNTg0NTVmYTg0ZTU=" \
  -E cloud.auth="elastic:xxxxxx" \
  -E setup.kibana.host=https://c586fdd9e810483aa11ab58455fa84e5.asia-east1.gcp.elastic-cloud.com:9243


./auditbeat setup -e \
  -E output.logstash.enabled=false \
  -E cloud.id="For-Long-Demo:YXNpYS1lYXN0MS5nY3AuZWxhc3RpYy1jbG91ZC5jb20kMGE1MTA1MWZjOTEwNDcwMjhjYzIzMTQ5N2UxMjBjMTkkYzU4NmZkZDllODEwNDgzYWExMWFiNTg0NTVmYTg0ZTU=" \
  -E cloud.auth="elastic:xxxxxx" \
  -E setup.kibana.host=https://c586fdd9e810483aa11ab58455fa84e5.asia-east1.gcp.elastic-cloud.com:9243


./packetbeat setup -e \
  -E output.logstash.enabled=false \
  -E cloud.id="For-Long-Demo:YXNpYS1lYXN0MS5nY3AuZWxhc3RpYy1jbG91ZC5jb20kMGE1MTA1MWZjOTEwNDcwMjhjYzIzMTQ5N2UxMjBjMTkkYzU4NmZkZDllODEwNDgzYWExMWFiNTg0NTVmYTg0ZTU=" \
  -E cloud.auth="elastic:xxxxxx" \
  -E setup.kibana.host=https://c586fdd9e810483aa11ab58455fa84e5.asia-east1.gcp.elastic-cloud.com:9243

heartbeat setup -e \
  -E output.logstash.enabled=false \
  -E cloud.id="For-Long-Demo:YXNpYS1lYXN0MS5nY3AuZWxhc3RpYy1jbG91ZC5jb20kMGE1MTA1MWZjOTEwNDcwMjhjYzIzMTQ5N2UxMjBjMTkkYzU4NmZkZDllODEwNDgzYWExMWFiNTg0NTVmYTg0ZTU=" \
  -E cloud.auth="elastic:xxxxxx" \
  -E setup.kibana.host=https://c586fdd9e810483aa11ab58455fa84e5.asia-east1.gcp.elastic-cloud.com:9243


在 Kibana 的 Dashboard 中查看导入的各种对象。

以上初始化都成功以后，下面找一台被管理服务器，测试相关配置文件是否在这个环境中可用。

git clone https://github.com/martinliu/elastic-stack-lab.git
cd elastic


复制相关配置文件到 Beats 实际安装的目录中。

cp -f filebeat-v1.yml /etc/filebeat/filebeat.yml
cp -f metricbeat-v1.yml /etc/metricbeat/metricbeat.yml
cp -f auditbeat.yml /etc/auditbeat/auditbeat.yml

初始化每个 Beats 都需要的 Elastic Cloud



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

git clone https://github.com/martinliu/elastic-stack-lab.git
cd elastic
sh add-agent.sh
