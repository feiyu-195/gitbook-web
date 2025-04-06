---
title: Arch安装问题
date: 2024-10-13 14:34:25
updated: 2024-11-23 23:22:22
categories:
  - 系统运维
  - Linux
tags:
  - Linux
  - Arch
permalink: /posts/Arch安装问题/
---
# 一、无法识别声卡

```shell
sudo pacman -S sof-firmware
reboot
```

# 二、无法识别摄像头

```shell
```

# 三、常用软件

```shell
# WPS中文版+字体
sudo pacman -S wps-office-cn wps-office-mime-cn wps-office-mui-zh-cn wps-office-fonts ttf-ms-fonts  ttf-wps-fonts
```

# 四、安装微软字体

## 方法一：

### 准备 PKGBUILD

Archlinux 中 [AUR – ttf-ms-win10](https://aur.archlinux.org/packages/ttf-ms-win10/) 提供了 PKGBUILD

```bash
git clone https://aur.archlinux.org/ttf-ms-win10.git
```

您可以编辑 `PKGBUILD` 添加 `simfang.ttf` `simhei.ttf` `simkai.ttf`，或直接从 [此处](https://gist.github.com/specter119/a7a4498d04eb5294fae09fea165c0f68) 获取

### 从 Windows 10 中复制字体文件

将 Windows/Fonts 中所有文件和 Windows/System32 中的 license.rtf 复制到 ttf-ms-win10 文件夹中

您也可以从文末链接中下载博主从 Windows 中打包的字体压缩包，解压到 ttf-ms-win10 中即可

### 安装软件包

在 `ttf-ms-win10` 目录下，执行

```bash
makepkg --skipchecksums
```

由于 Windows 10 内部版本不同，使用 `--skipchecksums` 跳过文件校验

### 刷新字体缓存

```bash
fc-cache
```

## 方法二：（推荐）

### 获取字体

windwos中获取微软雅黑字体，在**C:\Windows\Fonts**下拷贝微软雅黑字体

拷贝字体到Linux系统中，在 **/usr/share/fonts/** 下新建 **msyh** 文件夹

```shell
cd /usr/share/fonts/
sudo mkdir msyh
```

### 拷贝字体到**msyh**文件夹

```sh
sudo cp path/*ttc  /usr/share/fonts/msyh
```

### 执行命令

```sh
cd /usr/share/fonts/msyh
sudo mkfontscale
sudo mkfontdir
```

### 刷新字体

```sh
fc-cache
```

### 刷新系统字体

```sh
fc-cache -fv
```
