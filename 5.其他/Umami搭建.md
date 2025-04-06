---
title: Umami搭建
date: 2024-08-26 14:30:16
updated: 2024-11-15 21:49:40
categories:
  - 其他
tags:
  - Umami
permalink: /posts/Umami搭建/
---
# 前言

软件需求：

- MySQL/MariaDB：Umami数据存放。
- Nginx：使用Nginx，对umami的默认3000端口进行反向代理。
- Nodejs



# 1. 克隆仓库

```shell
git clone https://github.com/umami-software/umami.git
```



# 2. 安装依赖

```shell
# 进入刚刚克隆的仓库内
cd umami
# 使用npm进行依赖安装
npm install
```



# 3. 创建数据库

## 创建用户

确保已经安装了MySQL或者MariaDB，由于两则具有包含兼容关系，可以使用相同的命令

```shell
# 登录数据库
mysql -u root -p

# 创建一个用户umami，密码为password，并仅允许本机登录
CREATE USER 'umami'@'localhost' IDENTIFIED BY 'password';

# 创建一个数据库umami
CREATE DATABASE umami;

# 赋予权限
GRANT ALL ON umami.* TO 'umami'@'localhost';
```



## 初始化数据库(V2版本忽略)

```shell
mysql -u umami -p umami < sql/schema.mysql.sql
```

其中：

- `-u umami`：使用umami账户；
- `-p umami`：理论上 `-p` 代表使用密码，这里代表使用密码访问，umami代表访问的数据库。



# 4. 环境配置

umami需要我们配置一个`.env`的环境在**umami根目录**，umami会读取这个文件进行数据库的连接

使用`vim .env`编辑文件

```shell
DATABASE_URL=mysql://umami:password@localhost:3306/umami
HASH_SALT=suijizifu
TRACKER_SCRIPT_NAME=random-string.js
```

其中：

- 第一个`umami`为用户名
- `password`为用户密码
- 第二个`umami`为数据库
- `HASH_SALT`为Hash加盐字符，任意字符串即可
- `TRACKER_SCRIPT_NAME`可以使umami绕过广告屏蔽插件的影响



# 5. 构建运行

```shell
npm run build
npm start
```



# 6. 后台服务运行

此时umami已经搭建完成，但是直接使用npm启动的话只能在前台运行，远程登录关闭之后就会退出，所以这里使用systemctl来管理该服务

编辑`/etc/systemd/system/umami.service` 文件，写入以下内容：

```shell
[Unit]
Description=UmamiServer

[Service]
Type=simple
User=user
ExecStart=/usr/local/bin/cnpm start --prefix /path/umami
Restart=always
Environment=PATH=/usr/bin:/usr/local/bin:/userhomepath/.nvm/versions/node/v20.16.0/bin
Environment=NODE_ENV=production
WorkingDirectory=/path/umami

[Install]
WantedBy=multi-user.target
```

其中：

- `User选项`是运行时的用户名
- `ExecStart`中的`/usr/local/bin/cnpm`是npm的安装位置，我这里使用的是`cnpm`运行软件，也可以选择npm的位置；
- `/userhomepath/.nvm/versions/node/v20.16.0/bin` 使由于本人使用的nvm管理nodejs版本，这里选择nvm安装对应node版本的路径，前面是用户目录；
- `/path/umami`是umami所在目录。



# 7. Nginx反向代理并与Halo搭配

为了能使用Https访问，或者说用443、80端口访问，而不用IP登录，这里使用nginx进行反向代理

```shell
# 安装nginx
sudo apt-get install nginx -y
```



为了同时与Halo搭配，这里需要提前在halo后台下载umami插件；

再编辑默认配置文件`/etc/nginx/sites-available/default`，填入以下配置：

```shell
server {
  listen 80;
  listen [::]:80;

  # 域名
  server_name [umami.domain.com];
  
  # 重定向至https
  return 301 https://$host$request_uri;
}

server {
  listen 443 ssl http2;
  server_name [umami.domain.com];

  # SSL配置
  ssl on;
  ssl_certificate      /etc/nginx/cert/[umami.domain.com].pem;
  ssl_certificate_key  /etc/nginx/cert/[umami.domain.com].key;

  add_header Access-Control-Allow-Origin 'https://[halo.domain.com]';
  add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
  add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization';
  if ($request_method = 'OPTIONS') {
    return 204;
  }
  add_header Content-Security-Policy 'frame-ancestors [halo.domain.com]';
  # 反向代理
  location / {
    proxy_pass http://localhost:3000;
    proxy_set_header HOST $host;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_hide_header 'Access-Control-Allow-Origin';
    proxy_hide_header 'Content-Security-Policy';
  }
}
```



# 8. Halo插件配置

根据插件配置要求进行填写：

![image-20240809110948537](Umami搭建/image-20240809110948537.png)



其中：

- Umami站点地址为Umami的域名地址
- 脚本名称2.x版本默认为script.js
- 站点ID是在Umami创建站点后，在站点设置编辑中可以查看
- 共享链接与站点ID一样在站点编辑中查看







