---
title: RHEL8搭建本地yum源
categories:
  - 系统运维
  - Linux
tags:
  - Linux
  - RedHat
permalink: /posts/RHEL8搭建本地yum源/
date: 2024-06-20 14:34:37
updated: 2024-11-23 23:07:22
---
# 一、前言

一台红帽linux虚拟机，一个红帽dvd镜像(iso)。

# 二、开始搭建

1. 创建需要进行挂载的目录，并进行挂载
```shell
mkdir /mnt/cdrom        #挂载点目录 
mount /dev/src0 /mnt/cdrom
```

1. 创建repo文件

编辑/etc/yum.repo.d/local.repo文件，填入以下内容：
```shell
[BaseOS] 
name=BaseOS 
baseurl=file:///mnt/cdrom/BaseOS    # 挂载点目录/BaseOS 
enabled=1
gpgcheck=0 
[AppStream] 
name=AppStream 
baseurl=file:///mnt/cdrom/AppStream    # 挂载点目录/AppStream 
enabled=1
gpgcheck=0
```
redhat8中，所有rpm包都被拆分为BaseOS和AppStream两个目录，BaseOS里面存放一些基础应用，AppStream里面存放其他的应用。两个都要配置，才能安装全部的iso里的软件。

1. 验证是否可用

清理并刷新yum缓存
```shell
yum clean all    # 清理yum缓存 
yum repolist     # 刷新yum缓存
```

随意安装一个引用如vim，看源是否可用

# 三、配置开机自动挂载（选做）

1. 用blkid命令查看光盘文件属性，可以看到TYPE="iso9660"和UUID="2022-06-29-06-15-46-00"
```shell
[aaa@localhost yum.repos.d]$ blkid 
/dev/sr0: UUID="2022-06-29-06-15-46-00" LABEL="RHEL-8-2-0-BaseOS-x86_64" TYPE="iso9660" PTUUID="72cfe76b" PTTYPE="dos"
[aaa@localhost yum.repos.d]$
```

1. 编辑/etc/fstab文件

写入以下内容：
```shell
/dev/sr0 /mnt/cdrom iso9660 defaults 0 0 或者 UUID=2022-06-29-06-15-46-00 /mnt/cdrom iso9660 defaults 0 0
```