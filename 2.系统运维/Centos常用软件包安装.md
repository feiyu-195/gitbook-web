---
title: Centos常用软件包安装
categories:
  - 系统运维
  - Linux
tags:
  - Linux
  - Centos
permalink: /posts/Centos常用软件包安装/
date: 2024-05-16 14:34:36
updated: 2025-04-11 17:24:54
---
### 1、htop

```shell
sudo yum install epel-release -y && sudo yum install htop -y
```

### 2、nginx

```shell
sudo rpm -ivh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm && sudo yum install -y nginx
```

# 3、nvm

```shell
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
```