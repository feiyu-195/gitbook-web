---
title: Filebeat安装配置
date: 2024-10-07 14:30:11
updated: 2025-01-03 14:41:08
categories:
  - 其他
tags:
  - ELK
  - filebeat
permalink: /posts/Filebeat安装配置/
---
# Ubuntu

1. 添加ElasticSearch的GPG密钥

  ```
  wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
  ```

  

2. 添加ElasticSearch的APT存储库
  ```
  echo "deb https://artifacts.elastic.co/packages/oss-8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list
  ```

  

3. 更新APT软件包索引
  ```
  sudo apt update
  ```

  

4. 安装filebeat
  ```
  sudo apt install filebeat
  ```

  

5. 配置filebeat

```
sudo vim /etc/filebeat/filebeat.yml
```
全部替换为以下内容

  ```shell
processors:
  - add_cloud_metadata: ~
  - add_docker_metadata: ~

# ============================== Filebeat inputs ===============================

filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/nginx/*.log
  # tags更改分别更改为日志应用和主机ip，后续分别对应日志文件名称
  tags: ["nginx", "[主机ip]"]

filebeat.config:
  modules:
    path: ${path.config}/modules.d/*.yml
    reload.enabled: false

# ============================== Filebeat output ===============================

# 直接发送给elasticsearch
#output.elasticsearch:
#  username: 'elastic'
#  password: 'elastic_password'
#  hosts: ["http://日志服务器ip:9200"]
#  indices:
#    - index: "nginx-%{+yyyy.MM.dd}"

# 发送给logstash
output.logstash:
  hosts: ["日志服务器ip:5044"]
  enabled: true
  ```

  

6. 启动filebeat
```
sudo systemctl enable filebeat
sudo systemctl start filebeat
```



# Centos

一. 直接yum方式安装

```
yum install filebeat
```

二. 配置filebeat

```
sudo vim /etc/filebeat/filebeat.yml
```

全部替换为以下内容

```shell
processors:
  - add_cloud_metadata: ~
  - add_docker_metadata: ~

# ============================== Filebeat inputs ===============================

filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/nginx/*.log
  # tags更改分别更改为日志应用和主机ip，后续分别对应日志文件名称
  tags: ["nginx", "[主机ip]"]

filebeat.config:
  modules:
    path: ${path.config}/modules.d/*.yml
    reload.enabled: false

# ============================== Filebeat output ===============================

# 直接发送给elasticsearch
#output.elasticsearch:
#  username: 'elastic'
#  password: 'elastic_password'
#  hosts: ["http://日志服务器ip:9200"]
#  indices:
#    - index: "nginx-%{+yyyy.MM.dd}"

# 发送给logstash
output.logstash:
  hosts: ["日志服务器ip:5044"]
  enabled: true
```

