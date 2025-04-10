---
title: Docker部署elk
date: 2024-10-07 14:30:09
updated: 2025-04-10 00:14:26
categories:
  - 其他
tags:
  - docker
  - ELK
permalink: /posts/Docker部署elk/
---
# 一、部署elk

1. 创建elk目录并进入

```shell
[root@localhost ~ ]$ mkdir elk
[root@localhost ~ ]$ cd elk
```

2. 编辑docker-compose文件

```shell
[root@localhost ~/elk ]$ vim docker-compose.yml

version: "3.0"

services:
  elasticsearch:
    image: elasticsearch:8.15.0
    container_name: elasticsearch
    restart: always
    #entrypoint: /bin/bash
    volumes:
      - ./elasticsearch/data:/usr/share/elasticsearch/data
    environment:
      - ES_JAVA_OPTS=-Xms2g -Xmx24g
      - discovery.type=single-node
      # 是否开启用户密码验证，初始配置时可先设置为false
      - xpack.security.enabled=true
    ports:
      - "9200:9200"
      - "9300:9300"
    networks:
      elk:
        ipv4_address: 172.31.0.2

  kibana:
    image: kibana:8.15.0
    container_name: kibana
    restart: always
    #entrypoint: /bin/bash
    depends_on:
      - elasticsearch
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
      - I18N_LOCALE=zh-CN
    ports:
      - "5601:5601"
    networks:
      elk:
        ipv4_address: 172.31.0.3
  logstash:
    image: logstash:8.15.0
    container_name: logstash
    restart: always
    extra_hosts:
      elasticsearch: 日志服务器(elk)ip
    ports:
      - "5044:5044"
    volumes:
      - ./logstash/logs:/usr/share/logstash/logs
      - ./logstash/data:/usr/share/logstash/data
      - ./logstash/config:/usr/share/logstash/config
      - ./logstash/pipeline:/usr/share/logstash/pipeline
    networks:
      elk:
        ipv4_address: 172.31.0.4

networks:
  elk:
    driver: bridge
    ipam:
      config:
        - subnet: 172.31.0.0/16
```

3. 启动容器

```shell
[root@localhost ~/elk ]$ docker-compose up -d
```

4. 查看容器运行状态

```shell
[root@localhost ~/elk ]$ docker ps
CONTAINER ID   IMAGE                  COMMAND                   CREATED        STATUS        PORTS                                                                                  NAMES
064f34707685   logstash:8.15.0        "/usr/local/bin/dock…"   20 hours ago   Up 16 hours   0.0.0.0:5044->5044/tcp, :::5044->5044/tcp, 9600/tcp                                    logstash
380abab64dbe   elasticsearch:8.15.0   "/bin/tini -- /usr/l…"   23 hours ago   Up 21 hours   0.0.0.0:9200->9200/tcp, :::9200->9200/tcp, 0.0.0.0:9300->9300/tcp, :::9300->9300/tcp   elasticsearch
6a725eb9c3f7   kibana:8.15.0          "/bin/tini -- /usr/l…"   23 hours ago   Up 23 hours   0.0.0.0:5601->5601/tcp, :::5601->5601/tcp                                              kibana
```

*STATUS是运行状态*

## 容器运行异常

**若有容器无法正常运行，先关闭容器**

```shell
[root@localhost ~/elk ]$ docker-compose down
```

### 情况一：elasticsearch容器异常

1. 尝试给文件夹赋权和归属

```shell
# 分别执行
[root@localhost ~/elk ]$ sudo chmod 777 elasticsearch
[root@localhost ~/elk ]$ sudo chmod 777 elasticsearch/data
[root@localhost ~/elk ]$ sudo chown -R root:root elasticsearch
```

2. 重启容器

```shell
[root@localhost ~/elk ]$ docker restart elasticsearch
```

### 情况二：logstash容器异常

1. 尝试给文件夹赋权和归属

```shell
# 分别执行
[root@localhost ~/elk ]$ sudo chmod 777 logstash
[root@localhost ~/elk ]$ sudo chmod 777 logstash/data
[root@localhost ~/elk ]$ sudo chmod 777 logstash/logs
[root@localhost ~/elk ]$ sudo chmod 777 logstash/data
[root@localhost ~/elk ]$ sudo chmod 777 logstash/config
[root@localhost ~/elk ]$ sudo chmod 777 logstash/pipeline
[root@localhost ~/elk ]$ sudo chown -R root:root logstash
```

2. 重启容器在看是否解决

```shell
[root@localhost ~/elk ]$ docker restart logstash
```

3. 检查配置文件是否有错误

```shell
[root@localhost ~/elk ]$ sudo vim logstash/pipeline/logstash.conf
```

放入以下内容

```shell
input {
    beats {
        port => 5044
    }

}

filter {
    json {
      source => "message"
    }
    if [tags][0] in ["nginx", "httpd", "apache", "mysql", "router", "switch"] {
        mutate {
          add_field => {
            "index_name" => "%{[host][name]}@%{[tags][1]}-%{[tags][0]}-%{+YYYY.MM.dd}"
          }
        }
      } else {
        mutate {
          add_field => {
            "index_name" =>  "non_hosts_log"
          }
        }
      }

}

output {
    elasticsearch {
      hosts => ["http://日志服务器ip:9200"]
      index => "%{index_name}"
      user => "elastic"
      password => "elastic_password"
  }
  stdout {
    codec => rubydebug
  }
}
```

4. 重启容器在看是否解决

```shell
[root@localhost ~/elk ]$ docker restart logstash
```

# 二、开启elk用户认证

1. 运行容器

```shell
[root@localhost ~/elk ]$ docker-compose up -d
```

2. 修改配置文件

## 1. elasticsearch 开启认证功能

复制容器内配置文件到本地

```shell
[root@localhost ~/elk ]$ sudo docker cp elasticsearch:/usr/share/elasticsearch/config/elasticsearch.yml elasticsearch/config/elasticsearch.yml
```

编辑`elasticsearch.yml`添加以下内容

```shell
http.cors.enabled: true
http.cors.allow-origin: "*"
```

把修改后的文件拷贝回容器

```shell
[root@localhost ~/elk ]$ sudo docker cp elasticsearch/config/elasticsearch.yml elasticsearch:/usr/share/elasticsearch/config/elasticsearch.yml

#重启容器
[root@localhost ~/elk ]$ docker restart elasticsearch
```

## 2. elasticsearch 创建密码

1. 进入elasticsearch容器

```shell
[root@localhost ~/elk ]$ docker exec -it elasticsearch /bin/bash
```

2. 在容器中执行：

```shell
./bin/elasticsearch-setup-passwords auto
```

3. 分别执行以下两条`curl`命令

```shell
#修改elastic为指定的密码
curl -XPOST -u elastic 'http://localhost:9200/_security/user/elastic/_password' -H "Content-Type: application/json" -d'
{
"password": "elastic_password"
}
'

#修改kibana为指定的密码
curl -XPOST -u kibana 'http://localhost:9200/_security/user/kibana/_password' -H "Content-Type: application/json" -d'
{
"password": "kibana_password"
}
'

# 修改后exit退出容器，可在浏览器验证密码是否正确（http://192.168.1.11:9200）
```

## 3. Kibana 配置密码

1. 复制`kibana.yml`到本地

```shell
[root@localhost ~/elk ]$ sudo docker cp kibana:/usr/share/kibana/config/kibana.yml kibana/kibana.yml
```

2. 编辑`kibana.yml`

```shell
# 添加以下两行内容，仅可用于连接elasticsearch并与之通信, 不能用于kibana登录
elasticsearch.username: "kibana"
elasticsearch.password: "kibana_password"
```

3. 把修改后的文件拷贝回容器

```shell
[root@localhost ~/elk ]$ docker cp kibana/kibana.yml kibana:/usr/share/kibana/config/kibana.yml
```

4. 重启kibana容器

```shell
[root@localhost ~/elk ]$ docker restart kibana
```
