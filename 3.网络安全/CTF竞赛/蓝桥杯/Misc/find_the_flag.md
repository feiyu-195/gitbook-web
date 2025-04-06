---
title: find_the_flag
date: 2024-03-17 14:31:26
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
permalink: /posts/find_the_flag/
---
## 题目描述
find the flag

## 解题
下载附件，`wireshark`打开发现包损坏，用`010Editor`打开搜索`flag`：

> 010Editor是与winhex相同类型的工具。

![](find_the_flag/image-20240228150715880.png)

在查看中选择编辑为文本，查看搜索到的flag，找到关键信息：
![](find_the_flag/image-20240228150839057.png)

将信息记录下来得到`flag{aha!_you_found_it!}`