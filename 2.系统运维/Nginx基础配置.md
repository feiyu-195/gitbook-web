---
title: Nginx基础配置
date: 2024-08-06 14:30:12
updated: 2025-04-10 14:54:29
categories:
  - 其他
tags:
  - nginx
  - 反向代理
  - SSL
permalink: /posts/Nginx基础配置/
---
# 一、配置模版

```shell
server {
    listen 80;
    server_name www.domain.com;

    # location / {  // 强制 https 重定向
    #     rewrite ^(.*)$  https://$host$1 permanent;
    # }
    
    # 重定向至https
	return 301 https://$host$request_uri;
	
	# 网站根目录及默认网页
	#root  /www/xxx;
    #index index.html;
    
    # 日志文件
    access_log  /var/log/nginx/host.access.log  main;
}

server {
    listen 443 ssl;
    server_name www.domain.com;
    
    # SSL配置
    ssl on;
    ssl_certificate      /root/ssl/chained.pem;
    ssl_certificate_key  /root/ssl/domain.key;
    # SSL/TLS默认值
    ssl_protocols   TLSv1 TLSv1.1 TLSv1.2;
	ssl_ciphers     HIGH:!aNULL:!MD5;

    
    # 减少点击劫持
    add_header X-Frame-Options DENY;
    # 禁止服务器自动解析资源类型
    add_header X-Content-Type-Options nosniff;
    # 防XSS攻击
    add_header X-Xss-Protection 1;

	# 反向代理
    location / {
            proxy_pass http://127.0.0.1:8080;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header REMOTE-HOST $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

# 二、非80端口转https

```shell
error_page 497 301 https://$http_host$request_uri;
```

重点是，错误时返回301转成https ：

```shell
497 - normal request was sent to HTTPS
解释：当网站只允许https访问时，当用http访问时nginx会报出497错误码
```
