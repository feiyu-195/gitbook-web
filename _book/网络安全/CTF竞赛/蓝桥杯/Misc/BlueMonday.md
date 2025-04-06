---
title: BlueMonday
date: 2024-03-16 14:31:24
updated: 2024-11-15 21:49:39
categories:
  - 网络安全
  - CTF竞赛
  - 蓝桥杯
  - Misc
tags:
  - 网络安全
  - CTF
  - Misc
permalink: /posts/BlueMonday/
---
## 题目描述

Those who came before me lived through their vocations From the past until completion, they'll turn away no more And still I find it so hard to say what I need to say But I'm quite sure that you'll tell me just how I should feel today.[ blue_monday](https://static2.ichunqiu.com/icq/resources/fileupload/CTF/IceCTF/misc/blue_monday)



## 解题

下载附件，得到一个文件，用winhex打开查看flag痕迹：

![image-20240409162618804](BlueMonday/image-20240409162618804.png)



发现有很多`d乗€`将前几个文本字符连接起来发现关键词IceCTF;

据此将所有字符连接得到flag：`IceCTF{HAck1n9_mU5Ic_W17h_mID15_L3t5_H4vE_a_r4v3}`



