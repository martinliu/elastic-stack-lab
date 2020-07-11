metricbeat 

metricbeat.config.modules:
  path: ${path.config}/modules.d/*.yml
  reload.enabled: true 
  reload.period: 90s
tags: ["tencent", "prod"]
fields:
  env: prod 
processors:
  - add_host_metadata: ~
  - add_cloud_metadata:
      providers: [alibaba, tencent]
  - add_docker_metadata: ~
  - add_kubernetes_metadata: ~
  - add_fields:
      target: ''
      fields:
        service.name: 'Dev Service'
        service.id: 'my-mbp'
setup.ilm.check_exists: false
logging.level: error
queue.spool: ~
cloud.id: "For-Long-Demo:YXNpYS1lYXN0MS5nY3AuZWxhc3RpYy1jbG91ZC5jb20kMGE1MTA1MWZjOTEwNDcwMjhjYzIzMTQ5N2UxMjBjMTkkYzU4NmZkZDllODEwNDgzYWExMWFiNTg0NTVmYTg0ZTU="
cloud.auth: "beats-writer:DevOpsMeetup"


auditbeat.yml

auditbeat.modules:
- module: auditd
  audit_rule_files: [ '${path.config}/audit.rules.d/*.conf' ]
  audit_rules: |
- module: file_integrity
  paths:
  - /bin
  - /usr/bin
  - /sbin
  - /usr/sbin
  - /etc
- module: system
  datasets:
  state.period: 12h
  user.detect_password_changes: true
  login.wtmp_file_pattern: /var/log/wtmp*
  login.btmp_file_pattern: /var/log/btmp*

processors:
  - add_host_metadata: ~
  - add_cloud_metadata: ~
  - add_docker_metadata: ~
  - add_fields:
      target: ''
      fields:
        service.name: 'Dev Service'
        service.id: 'my-mbp'
setup.ilm.check_exists: false
queue.spool: ~
cloud.id: "For-Long-Demo:YXNpYS1lYXN0MS5nY3AuZWxhc3RpYy1jbG91ZC5jb20kMGE1MTA1MWZjOTEwNDcwMjhjYzIzMTQ5N2UxMjBjMTkkYzU4NmZkZDllODEwNDgzYWExMWFiNTg0NTVmYTg0ZTU="
cloud.auth: "beats-writer:DevOpsMeetup"

filebeat.yml 


filebeat.inputs:
- type: log
  enabled: false
  paths:
    - /var/log/*.log
filebeat.config.modules:
  path: ${path.config}/modules.d/*.yml
  reload.enabled: true 
  reload.period: 50s
tags: ["devops-jenkins", "tencent"]
fields:
  env: prod 
setup.kibana:
  host: "localhost:5601"
cloud.id: "For-Long-Demo:YXNpYS1lYXN0MS5nY3AuZWxhc3RpYy1jbG91ZC5jb20kMGE1MTA1MWZjOTEwNDcwMjhjYzIzMTQ5N2UxMjBjMTkkYzU4NmZkZDllODEwNDgzYWExMWFiNTg0NTVmYTg0ZTU="
cloud.auth: "beats-writer:DevOpsMeetup"
processors:
  - add_host_metadata:
        netinfo.enabled: true
  - add_cloud_metadata:
      providers: [alibaba, tencent]
  - add_docker_metadata: ~
  - add_kubernetes_metadata: ~
  - add_fields:
      target: ''
      fields:
        service.name: 'Dev Service'
        service.id: 'my-mbp'
setup.ilm.check_exists: false
logging.level: error
queue.spool: ~