---
title: Arch双显卡驱动安装
categories:
  - 系统运维
  - Linux
permalink: /posts/Arch双显卡驱动安装/
date: 2024-11-22 22:24:37
updated: 2024-11-23 23:06:03
tags:
---
# 集成显卡
通过以下命令安装如下几个包即可：

```bash
sudo pacman -S mesa lib32-mesa vulkan-intel lib32-vulkan-intel
```

