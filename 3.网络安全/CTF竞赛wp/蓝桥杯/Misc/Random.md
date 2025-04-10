---
title: Random
date: 2024-03-19 14:31:44
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
permalink: /posts/Random/
---
## 题目描述
答案加flag{}

## 解题
下载附件，题目给了一个pyo文件和一个二进制文件flag.enc

对pyo文件进行反编译：
[在线pyc,pyo,python,py文件反编译](http://tools.bugscaner.com/decompyle/)

得到源代码：
```python
from random import randint
from math import floor, sqrt
_ = ''
__ = '_'
____ = [ ord(___) for ___ in __ ]
_____ = randint(65, max(____)) * 255
for ___ in range(len(__)):
    _ += str(int(floor(float(_____ + ____[___]) / 2 + sqrt(_____ * ____[___])) % 255)) + ' '

print _
```

可以看出附件的flag.enc就是代码的输出结果，