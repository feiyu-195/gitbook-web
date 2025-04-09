---
title: Spug手动部署(Kali)
date: 2024-10-16 14:30:14
updated: 2024-12-15 19:24:04
categories:
  - 其他
tags:
  - 自动化运维
  - Spug
  - kali
permalink: /posts/Spug手动部署(Kali)/
---
## 准备环境

- Python 3.6及以上
- Mysql 5.6及以上
- 现代浏览器
- 自 `v2.3.9` 开始 `Git` 版本需要 `2.17.0+` （影响新建常规发布申请单）

## 安装步骤

以下安装步骤假设项目部署在一台 `Centos7` 系统的 `/data/spug` 目录下。

### 1. Clone项目代码

```bash
git clone https://github.com/openspug/spug /data/spug
cd /data/spug
```

### 2. 创建运行环境arch libldap24

如需要使用常规发布功能，则需要安装 git v2.17.0+。

```bash
# 安装依赖
apt-get install -y mariadb-server libmariadb-dev python3-dev gcc libldap-dev libsasl2-dev redis nginx supervisor rsync sshfs pkg-config

# 创建虚拟环境
cd /data/spug/spug_api
python3 -m venv venv
source venv/bin/activate

# 安装python包
pip install -U pip setuptools -i https://pypi.tuna.tsinghua.edu.cn/simple/
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple/
pip install gunicorn mysqlclient -i https://pypi.tuna.tsinghua.edu.cn/simple/
```

```shell
yay -S libldap24
```

### 3. 修改后端配置

后端默认使用的 `Sqlite` 数据库，通过修改配置使用 `MYSQL` 作为后端数据库，[如何使用SqlServer数据库？](https://spug.cc/docs/install-problem#use-sqlserver)

注意

在 `spug_api/spug/` 目录下创建 `overrides.py` 文件，启动后端服务后会自动覆盖默认的配置，避免直接修改 `settings.py` 以便于后期获取新版本。

spug_api/spug/overrides.py

```python
DEBUG = False

DATABASES = {
    'default': {
        'ATOMIC_REQUESTS': True,
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'spug',             # 替换为自己的数据库名，请预先创建好编码为utf8mb4的数据库
        'USER': 'spug_user',        # 数据库用户名
        'PASSWORD': 'spug_passwd',  # 数据库密码
        'HOST': '127.0.0.1',        # 数据库地址
        'OPTIONS': {
            'charset': 'utf8mb4',
            'sql_mode': 'STRICT_TRANS_TABLES',
            #'unix_socket': '/opt/mysql/mysql.sock' # 如果是本机数据库,且不是默认安装的Mysql,需要指定Mysql的socket文件路径
        }
    }
}
```

### 4. 创建数据库

```bash
systemctl restart mariadb

mariadb -uroot -p
##
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 38
Server version: 10.11.8-MariaDB-1 Debian n/a

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Support MariaDB developers by giving a star at https://github.com/MariaDB/server
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> create database spug;
Query OK, 1 row affected (0.002 sec)

MariaDB [(none)]> create user 'spug_user'@'%' identified by 'spug_passwd';
Query OK, 0 rows affected (0.023 sec)

MariaDB [(none)]> grant all on *.* to 'spug_user'@'%';
Query OK, 0 rows affected (0.037 sec)

MariaDB [(none)]> flush privileges;
Query OK, 0 rows affected (0.001 sec)

MariaDB [(none)]> quit
##

```

### 5. 初始化数据库

```bash
cd /data/spug/spug_api
python manage.py updatedb
```

### 6. 创建默认管理员账户

```bash
python manage.py user add -u admin -p spug.cc -s -n 管理员

# -u 用户名
# -p 密码
# -s 超级管理员
# -n 用户昵称
```

### 7. 创建启动服务脚本

mkdir /etc/supervisord.d/

vim /etc/supervisord.d/spug.ini

```bash
[program:spug-api]
command = bash /data/spug/spug_api/tools/start-api.sh
autostart = true
stdout_logfile = /data/spug/spug_api/logs/api.log
redirect_stderr = true

[program:spug-ws]
command = bash /data/spug/spug_api/tools/start-ws.sh
autostart = true
stdout_logfile = /data/spug/spug_api/logs/ws.log
redirect_stderr = true

[program:spug-worker]
command = bash /data/spug/spug_api/tools/start-worker.sh
autostart = true
stdout_logfile = /data/spug/spug_api/logs/worker.log
redirect_stderr = true

[program:spug-monitor]
command = bash /data/spug/spug_api/tools/start-monitor.sh
autostart = true
stdout_logfile = /data/spug/spug_api/logs/monitor.log
redirect_stderr = true

[program:spug-scheduler]
command = bash /data/spug/spug_api/tools/start-scheduler.sh
autostart = true
stdout_logfile = /data/spug/spug_api/logs/scheduler.log
redirect_stderr = true
```

### 8. 创建前端nginx配置文件

/etc/nginx/conf.d/spug.conf

```bash
server {
        listen 80;
        server_name _;     # 修改为自定义的访问域名
        root /data/spug/spug_web/build/;
        client_max_body_size 20m;   # 该值会影响文件管理器可上传文件的大小限制，请合理调整

        gzip  on;
        gzip_min_length  1k;
        gzip_buffers     4 16k;
        gzip_http_version 1.1;
        gzip_comp_level 7;
        gzip_types       text/plain text/css text/javascript application/javascript application/json;
        gzip_vary on;

        location ^~ /api/ {
                rewrite ^/api(.*) $1 break;
                proxy_pass http://127.0.0.1:9001;
                proxy_read_timeout 180s;
                proxy_redirect off;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }

        location ^~ /api/ws/ {
                rewrite ^/api(.*) $1 break;
                proxy_pass http://127.0.0.1:9002;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "Upgrade";
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }

        location / {
                try_files $uri /index.html;
        }
}
```
