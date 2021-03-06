#!/bin/bash
# author: Martin Liu
# url: http://martinliu.cn

elastic_version='7.8.0'
b_rpm='https://artifacts.elastic.co/downloads/beats'
b_id='For-Long-Demo:YXNpYS1lYXN0MS5nY3AuZWxhc3RpYy1jbG91ZC5jb20kMGE1MTA1MWZjOTEwNDcwMjhjYzIzMTQ5N2UxMjBjMTkkYzU4NmZkZDllODEwNDgzYWExMWFiNTg0NTVmYTg0ZTU='
b_auth='beats-writer:DevOpsMeetup'

cloud.id: "${BEATS_CLOUD_ID}"
cloud.auth:  "${BEATS_CLOUD_AUTH}"


echo "############## Installing  Beats "$elastic_version" ..."


yum install -y $b_rpm/filebeat/filebeat-$elastic_version-x86_64.rpm
systemctl enable  filebeat.service
filebeat modules enable system

yum install -y $b_rpm/metricbeat/metricbeat-$elastic_version-x86_64.rpm
systemctl enable  metricbeat.service

yum install -y $b_rpm/auditbeat/auditbeat-$elastic_version-x86_64.rpm
systemctl enable  auditbeat.service

yum install -y $b_rpm/heartbeat/heartbeat-$elastic_version-x86_64.rpm


echo "################### Update Beats configuration files ..."

cp -f filebeat-v1.yml /etc/filebeat/filebeat.yml
cp -f metricbeat-v1.yml /etc/metricbeat/metricbeat.yml
cp -f auditbeat.yml /etc/auditbeat/auditbeat.yml

echo "################### Setup Keystor for Beats ..."

echo $b_id  | sudo filebeat keystore add BEATS_CLOUD_ID --stdin --force
echo $b_auth  | sudo filebeat keystore add BEATS_CLOUD_AUTH --stdin --force


echo $b_id  | sudo metricbeat keystore add BEATS_CLOUD_ID --stdin --force
echo $b_auth  | sudo metricbeat keystore add BEATS_CLOUD_AUTH --stdin --force


echo $b_id  | sudo auditbeat keystore add BEATS_CLOUD_ID  --stdin --force
echo $b_auth  | sudo auditbeat keystore add BEATS_CLOUD_AUTH--stdin --force


echo "################### Start Beats services ..."

sudo systemctl start  metricbeat.service
sudo systemctl start  filebeat.service
sudo systemctl start  auditbeat.service