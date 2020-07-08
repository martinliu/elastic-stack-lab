#!/bin/bash
# author: Martin Liu
# url:martinliu.cn

elastic_version='7.5.1'
b_rpm='https://mirrors.cloud.tencent.com/elasticstack/7.x/yum'
b_es='192.168.0.12:9200'
b_user='beats-writer'
b_pwd='DevOpsMeetup'



echo "############## Installing  Beats "$elastic_version" ..."


yum install -y $b_rpm/$elastic_version/filebeat-$elastic_version-x86_64.rpm
systemctl enable  filebeat.service
filebeat modules enable system

yum install -y $b_rpm/$elastic_version/metricbeat-$elastic_version-x86_64.rpm
systemctl enable  metricbeat.service

yum install -y $b_rpm/$elastic_version/auditbeat-$elastic_version-x86_64.rpm
systemctl enable  auditbeat.service


echo "################### Update Beats configuration files ..."

cp -f filebeat-v1.yml /etc/filebeat/filebeat.yml
cp -f metricbeat-v1.yml /etc/metricbeat/metricbeat.yml

echo "################### Setup Keystor for Beats ..."

echo $b_es  | sudo filebeat keystore add INT_ES_SRV --stdin --force
echo $b_user  | sudo filebeat keystore add BEATS_WRITER_USERNAME --stdin --force
echo $b_pwd   | sudo filebeat keystore add BEATS_WRITER_PW --stdin --force

echo $b_es  | sudo metricbeat keystore add INT_ES_SRV --stdin --force
echo $b_user  | sudo metricbeat keystore add BEATS_WRITER_USERNAME --stdin --force
echo $b_pwd   | sudo metricbeat keystore add BEATS_WRITER_PW --stdin --force


echo "################### Start Beats services ..."

sudo systemctl start  metricbeat.service
sudo systemctl start  filebeat.service