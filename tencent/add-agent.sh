#!/bin/bash
# author: Martin Liu
# url:martinliu.cn
# 一键式安装 filebeat 和 metricbeat ，并使用 keystore 加密相关秘密信息 

elastic_version='7.5.1'
b_rpm='https://mirrors.cloud.tencent.com/elasticstack/7.x/yum'
b_es='192.168.0.43:9200'
b_user='beats-writer'
b_pwd='DevOpsMeetup'

echo "############## 安装 Beats "$elastic_version" ..."

yum install -y $b_rpm/$elastic_version/filebeat-$elastic_version-x86_64.rpm
systemctl enable  filebeat.service
filebeat modules enable system

yum install -y $b_rpm/$elastic_version/metricbeat-$elastic_version-x86_64.rpm
systemctl enable  metricbeat.service

echo "################### 覆盖更新默认配置文件 "

cp -f filebeat-v1.yml /etc/filebeat/filebeat.yml
cp -f metricbeat-v1.yml /etc/metricbeat/metricbeat.yml
cp -f auditbeat.yml /etc/auditbeat/auditbeat.yml

echo "################### 初始化 Beats 相关的 keystore，导入只写账号信息 ..."

echo $b_es  | sudo filebeat keystore add INT_ES_SRV --stdin --force
echo $b_user  | sudo filebeat keystore add BEATS_WRITER_USERNAME --stdin --force
echo $b_pwd   | sudo filebeat keystore add BEATS_WRITER_PW --stdin --force

echo $b_es  | sudo metricbeat keystore add INT_ES_SRV --stdin --force
echo $b_user  | sudo metricbeat keystore add BEATS_WRITER_USERNAME --stdin --force
echo $b_pwd   | sudo metricbeat keystore add BEATS_WRITER_PW --stdin --force


echo "################### 启动目标 Beats 服务 ..."

sudo systemctl restart  metricbeat.service
sudo systemctl restart  filebeat.service