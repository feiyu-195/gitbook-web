---
title: Docker部署elk
date: 2024-10-07 14:30:09
updated: 2024-11-23 22:56:19
categories:
  - 其他
tags:
  - docker
  - ELK
permalink: /posts/Docker部署elk/
---
# 零、概述

整体使用docker compose部署elk

1. 常用命令

```shell
docker-compose up -d	# 启动容器
docker-compose down		# 关闭容器
docker ps -a			# 查看容器（包括停止的）
docker ps				# 查看容器（不包括停止的）
docker logs 容器名		  # 查看容器运行日志
docker logs  -f 容器名	  # 实时显示容器运行日志
docker restart/start/stop 容器名 	  # 重启/启动/停止容器
docker run -itd --name 容器名 镜像名	# 运行容器
docker exec -it 容器名 /bin/bash	  # 进入容器

```

2. docker-compose文件

```shell
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





# 一、部署elk

创建elk目录并进入

```shell
mkdir elk
cd elk
```

将docker-compose文件放入

```shell
vim docker-compose-yml
```

将上述配置文件复制进去

启动容器

```shell
docker-compose up -d
```

查看容器运行状态

```shell
root@localhost:~/elk$ docker ps
CONTAINER ID   IMAGE                  COMMAND                   CREATED        STATUS        PORTS                                                                                  NAMES
064f34707685   logstash:8.15.0        "/usr/local/bin/dock…"   20 hours ago   Up 16 hours   0.0.0.0:5044->5044/tcp, :::5044->5044/tcp, 9600/tcp                                    logstash
380abab64dbe   elasticsearch:8.15.0   "/bin/tini -- /usr/l…"   23 hours ago   Up 21 hours   0.0.0.0:9200->9200/tcp, :::9200->9200/tcp, 0.0.0.0:9300->9300/tcp, :::9300->9300/tcp   elasticsearch
6a725eb9c3f7   kibana:8.15.0          "/bin/tini -- /usr/l…"   23 hours ago   Up 23 hours   0.0.0.0:5601->5601/tcp, :::5601->5601/tcp                                              kibana
```

*STATUS是运行状态*

若有容器无法正常运行，先关闭容器

```
docker-compose down
```



##### 情况一：elasticsearch容器重启

1. 尝试给文件夹赋权和归属

```shell
# 分别执行
sudo chmod 777 elasticsearch
sudo chmod 777 elasticsearch/data
sudo chown -R user:user elasticsearch
```

2. 重启容器

```shell
docker restart elasticsearch
```



##### 情况二：logstash容器重启

1. 尝试给文件夹赋权和归属

```shell
# 分别执行
sudo chmod 777 logstash
sudo chmod 777 logstash/data
sudo chmod 777 logstash/logs
sudo chmod 777 logstash/data
sudo chmod 777 logstash/config
sudo chmod 777 logstash/pipeline
sudo chown -R user:user logstash
```

2. 重启容器在看是否解决

```shell
docker restart logstash
```

3. 检查配置文件是否有错误

```shell
sudo vim logstash/pipeline/logstash.conf
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
docker restart logstash
```



# 二、配置elk用户密码

1. 运行容器

```
docker-compose up -d
```

2. 修改配置文件

复制容器内配置文件到本地

```shell
sudo docker cp elasticsearch:/usr/share/elasticsearch/config/elasticsearch.yml elasticsearch/config/elasticsearch.yml
```

添加以下内容

```
http.cors.enabled: true
http.cors.allow-origin: "*"
```

把修改后的文件拷贝回容器

```
sudo docker cp elasticsearch/config/elasticsearch.yml elasticsearch:/usr/share/elasticsearch/config/elasticsearch.yml

#重启容器
docker restart elasticsearch
```

进入elasticsearch容器修改密码

```shell
docker exec -it elasticsearch /bin/bash #进入容器

./bin/elasticsearch-setup-passwords auto #自动生成密码

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



修改kibana配置文件kibana.yml

```shell
sudo docker cp kibana:/usr/share/kibana/config/kibana.yml kibana/kibana.yml

vim kibana/kibana.yml

# 添加以下两行内容，仅可用于连接elasticsearch并与之通信, 不能用于kibana登录
elasticsearch.username: "kibana"
elasticsearch.password: "kibana_password"

# 把修改后的文件拷贝到容器
docker cp kibana/kibana.yml kibana:/usr/share/kibana/config/kibana.yml
docker restart kibana #重启kibana容器
```

