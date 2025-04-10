---
title: Docker部署青龙面板
date: 2025-01-03 17:31:06
updated: 2025-04-09 23:56:39
tags: 
permalink: /posts/Docker部署青龙面板/
---
# 一、手动添加网络

```shell
# 添加一个名称为 docker_network 的网络
docker network create --driver bridge --subnet=172.16.0.0/24 --gateway=172.16.0.1 -o com.docker.network.bridge.name=docker_network docker_network
```

# 二、编写docker-compose.yaml

```shell
version: '3'

services:
  qinglong:
    image: whyour/qinglong:debian
    container_name: qinglong
    restart: unless-stopped
    environment:
      - TZ=Asia/Shanghai
      - QlBaseUrl=/ql/    # 使用nginx子路径反代，若不使用子路径则不需要
    volumes:
      - /docker/qinglong/data:/ql/data
    # ports:
    #   - "5700:5700"
    networks:
      docker_network:
        ipv4_address: 172.16.0.7  # 随意设置网段内的IP

networks:
  docker_network:
    external: true
```

# 三、运行docker容器

```shell
[root@localhost ~ ]$ cd /path/to/qinglong
[root@localhost qinglong ]$ docker-compose up -d
```

# 四、Nginx配置反向代理

```shell
# HTTP server 
server {
  listen 80;
  listen [::]:80;
  server_name _;

  # 重定向至https
  return 301 https://$host$request_uri;
}
# HTTPS server  
server {
    listen       443 ssl;
    server_name  _;
    
    ssl_certificate      /path/to/cert/nginx.crt;
    ssl_certificate_key  /path/to/cert/nginx.key;
    ssl_session_cache    shared:SSL:1m;
    ssl_session_timeout  5m;
    ssl_ciphers  HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers  on;

    # 青龙面板子路径反代，若不是用子路径反代则`/ql/`替换为`/`
    location /ql/ {
            proxy_pass http://172.16.0.7:5700/ql/; # 最后的`/`不能少
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header REMOTE-HOST $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Upgrade $http_upgrade;
    }
}
```

# 五、青龙常用命令

```shell
# 更新青龙
docker exec -it qinglong ql update

# 更新青龙并编译
docker exec -it qinglong ql check

# 启动bot
docker exec -it qinglong ql check

# 删除7天前的所有日志
docker exec -it qinglong ql rmlog 7

# 通知测试
docker exec -it qinglong notify test test

# 立即执行脚本
docker exec -it qinglong task test.js now

# 并行执行脚本
docker exec -it qinglong task test.js conc
```
