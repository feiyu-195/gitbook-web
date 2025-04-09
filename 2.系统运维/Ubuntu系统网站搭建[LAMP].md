---
title: 'Ubuntu系统网站搭建[LAMP]'
categories:
  - 系统运维
  - Linux
tags:
  - Linux
  - Ubuntu
permalink: '/posts/Ubuntu系统网站搭建[LAMP]/'
date: 2023-03-13 14:34:32
updated: 2025-04-09 21:42:26
---
# 前言

环境：Ubuntu 20.04 TLS

准备搭建环境：LAMP（Linux + Apache + Mysql + PHP）

# 搭建LAMP环境

1、安装Apache

```shell
sudo apt-get install apache2 -y
```



- 验证：如果是本地主机，可以在浏览器输入127.0.0.1；如果是云服务器，可以再浏览器输入服务器提供商给的IP地址，出现以下界面则表示安装成功：

![image-20240220145113368](https://ps.feiyunote.cn/assets/image-20240220145113368.png)

2、安装php
```bash
sudo apt-get install php libapache2-mod-php -y sudo systemctl restart apache2    #重启apache服务
```

- 这里安装libapache2-mod-php的主要的原因是因为

libapache2-mod-php

libapache2-mod-php

- 验证：在apache默认网页文件路径（/var/ww/html/）下创建一个文件1.php，输入以下内容

保存退出，在浏览器输入`http://IP地址/1.php`，出现以下界面，表示安装成功

![image-20240220145123404](https://ps.feiyunote.cn/assets/image-20240220145123404.png)

3、安装MySQL及其相关php组件
```shell
sudo apt-get install mysql -y    #安装mysql 
sudo apt-get install php-mysql    #安装php相关组件
```

4、安装phpmyadmin（可视化数据库管理界面）
```shell
sudo apt-get install phpmyadmin -y sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin    #建立 /var/www/html 下的软连接 
sudo systemctl restart mysql    #重启 MySQL 服务 
sudo systemctl restart apache2.service    #重启 Apache 服务
```

- 创建软链接的目的是让我们在进入phpmyadmin时更加的方便一点，只要在浏览器输入`http://IP地址/phpmyadmin`

# 创建wordpress数据库

```shell
mysql -u root -p    		 #进入mysqlroot账户，初次进入会设置密码 
CREATE DATABASE 数据库名称;    #创建数据库 
CREATE USER ‘用户名’@‘%’ IDENTIFIED BY ‘密码’;    #创建用户（远程用户）并设置密码用于连接wordpress 
GRANT ALL PRIVILEGES ON 数据库名称.* TO ‘用户名’@‘%';    #给创建的用户权限 
FLUSH PRIVILEGES;    		 #生效设置 
exit;    					 #退出
```

-  输入命令时注意最后的‘；’号，还有在赋权时数据库名称后面的‘.*’，创建成功之后可以进入phpmyadmin后台验证是否能够登录。

**wordpress下载配置**

进入wordpress官网[icon-url href="https://cn.wordpress.org/download/"]找到（下载.tar.gz）,右键复制下载链接；

![image-20240220145137458](https://ps.feiyunote.cn/assets/image-20240220145137458.png)

- 在linux终端输入

wget 复制的链接

tar -zxvf 压缩包名

```shell
sudo wget https://cn.wordpress.org/latest-zh_CN.tar.gz 
sudo tar -zxvf latest-zh_CN.tar.gz
```



- 先将apache目录下的index.php进行重命名（目的是改变Apache默认打开的网页）

```shell
sudo mv /var/www/html/index.html /var/www/html/index~.html
```



- 再将解压的wordpress文件全部移动到Apache文件目录下

```shell
sudo mv wordpress/* /var/www/html/
```



- 然后给html下的文件进行赋权限

```shell
sudo chmod -R 777 /var/www/html/    #shiji实际上不用这么高的权限，但是我这里图个方便直接给最高权限
```



- 重启Apache服务，配置完成

```shell
sudo systemctl restart apache2
```

配置完后，即可进入浏览器配置网站的相关配置了，在浏览器输入IP地址，进入wordpress配置，按照要求填写之前创建的数据库信息，和网站信息，完成后你就能拥有一个属于自己的网站了[撒花][撒花][撒花]

# 结语

到这里我们已经拥有了自己的网站了，但是这样子并不算已经上线，因为我们还没有域名，下一步我们将会给网站链接一个域名，实现域名访问[期待]。