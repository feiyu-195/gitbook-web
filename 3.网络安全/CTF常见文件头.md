---
title: CTF常见文件头
date: 2024-04-27 14:32:27
updated: 2025-04-10 15:00:06
categories:
  - 网络安全
  - 理论知识
tags:
  - CTF
  - 文件格式
permalink: /posts/CTF常见文件头/
---

| 文件类型                        | 文件头                          | ASCII码             | 文件尾         |
| --------------------------- | ---------------------------- | ------------------ | ----------- |
| JPEG (jpg)                  | FFD8FF                       | \|ÿØÿ\|            | FF D9       |
| PNG (png)                   | 89504E47                     | \|.PNG\|           | AE 42 60 82 |
| GIF (gif)                   | 47494638 或GIF89A             | \|GIF8\|           | 00 3B       |
| ZIP Archive (zip)           | 504B0304                     | \|PK..\|           | 50 4B       |
| RAR Archive (rar)           | 52617221                     | \|Rar!\|           |             |
| bmp                         | 424D                         | \|BM\|             |             |
| HTML (html)                 | 68746D6C3E                   | \|html>\|          |             |
| Wave (wav)                  | 57415645                     | \|WAVE\|           |             |
| AVI (avi)                   | 41564920                     | \|AVI \|           |             |
| Email [thorough only] (eml) | 44656C69766572792D646174653A | \|Delivery-date:\| |             |
| Adobe Acrobat (pdf)         | 255044462D312E               | \|%PDF-1.\|        |             |
| Photoshop (psd)             | 38425053                     | \|8BPS\|           |             |
| XML (xml)                   | 3C3F786D6C                   | \|<?xml\|          |             |

2.7版本文件头：03F3 0D0A
3.8版本文件头：550D 0D0A

upx脱壳：`upx.exe -d 文件路径`

uncompyle6 pyc逆向：`uncompyle6 -o pcat.py pcat.pyc`

pyinstxtractor：`python pyinstxtractor exe文件`
