---
title: Centos开启VirtualBox增强模式
categories:
  - 系统运维
  - Linux
tags:
  - Linux
  - Centos
  - VirtualBox
permalink: /posts/Centos开启VirtualBox增强模式/
date: 2024-08-15 14:34:36
updated: 2024-11-15 21:49:39
---
# 问题

运行安装程序报错找不到kernel-header



# 1、更新kernel内核版本

```shell
sudo yum update kernel -y
```



# 2、安装kernel header

```shell
sudo yum install kernel-headers kernel-devel gcc make -y
```



# 3、运行安装程序

双击打开桌面增强的iso文件，右键文件空白处打开终端，

运行： 

```shell
sudo sh VBoxLinuxAdditions.run
```

成功！