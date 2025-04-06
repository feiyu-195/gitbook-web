---
title: WEB服务口令(后台密码)
date: 2024-09-27 14:30:38
updated: 2024-11-15 21:49:39
categories:
  - 网络安全
  - AWD
tags:
  - AWD
  - 网络安全
permalink: /posts/WEB服务口令(后台密码)/
---
**配置文件方式的后台**密码

```bash
find /var/www/html -path 'config' #查找配置文件中的密码凭证
```

数据库后台管理员密码


```shell
mysql -u root -p
show databases;
use dataname;选择站点的数据库
show tables;
select * from admin;
updata admin set user pass=’d1fd2i64m527bd4B’; //updata 表名 set 字段名 = ‘值’;
flush privileges;
```

