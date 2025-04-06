---
title: shellcode
date: 2024-03-20 14:31:48
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
permalink: /posts/shellcode/
---
## 题目描述
作为一个黑客，怎么能不会使用shellcode?
这里给你一段shellcode，你能正确使用并最后得到flag吗？

文件：[shellcode](https://static2.ichunqiu.com/icq/resources/fileupload/phrackCTF/basic/shellcode)
flag格式：PCTF{flag}

## 解题
下载打开，是一段shellcode代码，搜索得知有一个shellcode代码运行器
[GitHub - bdamele/shellcodeexec: Script to execute in memory a sequence of opcodes](https://github.com/bdamele/shellcodeexec)

下载好后再cmd中运行代码：
![](shellcode/image-20240306131731384.png)

弹窗得到flag：`PCTF{Begin_4_good_pwnn3r}`
![](shellcode/image-20240306131749055.png)

