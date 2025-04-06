---
title: Arch多版本jdk共存以及切换
categories:
  - 系统运维
  - Linux
tags:
  - Linux
  - Arch
  - Java
permalink: /posts/Arch多版本jdk共存以及切换/
date: 2024-10-11 14:34:25
updated: 2024-11-23 23:05:52
---
ArchLinux提供了archlinux-java命令来切换jdk版本，使用如下：

- 使用ArchLinux的包管理器安装openjdk8和openjdk11

```shell
$ sudo pacman -S jdk8-openjdk jdk11-openjdk
```

- 使用archlinux-java切换默认jdk版本

```shell
# 查看archlinux-java使用说明
$ archlinux-java --help

# 查看jdk状态
$ archlinux-java status

Available Java environments:
  java-11-openjdk
  java-8-openjdk (default)

# 获取默认jdk
$ archlinux-java get

java-8-openjdk

# 设置默认jdk
$ sudo archlinux-java set java-11-openjdk

# 查看切换后的jdk版本
$ java -version

openjdk version "11.0.13" 2021-10-19
OpenJDK Runtime Environment (build 11.0.13+8)
OpenJDK 64-Bit Server VM (build 11.0.13+8, mixed mode)
```