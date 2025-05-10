---
title: ARP
date: 2022-09-08 14:33:59
updated: 2025-04-09 21:00:33
categories:
  - 数据通信
  - HCIA
  - 4.路由
tags:
  - 数据通信
  - HCIA
permalink: /posts/ARP/
---
# ARP

address resolution protocol 地址解析协议

![image-20240219155311154](ARP/image-20240219155311154.png)

目的MAC不能不存在，负责完成不了封装，于是出现ARP

![image-20240219155317751](ARP/image-20240219155317751.png)

ARP报文的类型分为request请求和reply/respond回应

ARP请求：

![image-20240219155329773](ARP/image-20240219155329773.png)

ARP请求发送的类型为广播帧 （同一广播域的主机都会收到）

ARP响应：

![image-20240219155338765](ARP/image-20240219155338765.png)

ARP响应的类型为单播帧 （可以使用软件修改为广播-ARP欺骗）

ARP缓存表：获取到的MAC地址会存放在该表

![image-20240219155349077](ARP/image-20240219155349077.png)

| 命令   | 备注        |
| ------ | ----------- |
| Arp -a | 查看ARP缓存 |
| Arp -d | 清空ARP缓存 |

ARP欺骗：攻击者发送“无故ARP响应”来伪装其他设备

![image-20240219155406898](ARP/image-20240219155406898.png)

免费arp：用来检测配置/修改的IP地址是否重复

![image-20240219155415415](ARP/image-20240219155415415.png)

连续发送3次来检测地址有没有冲突

![image-20240219155422945](ARP/image-20240219155422945.png)
