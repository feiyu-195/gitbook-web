---
title: Arch安装卸载软件
date: 2024-08-27 14:34:23
updated: 2025-04-09 21:55:26
categories:
  - 系统运维
  - Linux
tags:
  - Linux
  - Arch
permalink: /posts/Arch安装卸载软件常用命令/
---
# 简介

pacman是arclinux中的软件管理工具，可以直接从网络上的软件仓库下载安装及删除软件，自动处理依赖关系，类似ubuntu中的apt-get。pacman也是widows上msys2默认的软件管理工具。

# 安装软件

- 安装软件。也可以同时安装多个包，只需以空格分隔包名即可。

```shell
pacman -S 软件名
```

- 安装软件，但不重新安装已经是最新的软件。

```shell
pacman -S --needed 软件名1 软件名2
```

- 安装软件前，先从远程仓库下载软件包数据库(数据库即所有软件列表)。

```shell
pacman -Sy 软件名
```

- 在显示一些操作信息后执行安装。

```shell
pacman -Sv 软件名
```

-  只下载软件包，不安装。

```shell
pacman -Sw 软件名
```

- 安装本地软件包。

```shell
pacman -U 软件名.pkg.tar.gz
```

-  安装一个远程包（不在 pacman 配置的源里面）。

```shell
pacman -U http://www.example.com/repo/example.pkg.tar.xz
```

# 更新系统

-  从服务器下载新的软件包数据库（实际上就是下载远程仓库最新软件列表到本地）。

```shell
pacman -Sy
```

-  升级所有已安装的软件包。

```shell
pacman -Su
```

pacman 可以用一个命令就可以升级整个系统。花费的时间取决于系统有多老。这个命令会同步非本地(local)软件仓库并升级系统的软件包：

```shell
pacman -Syu
```

> 在msys2中 pacman -Syu后需要重启一下msys2(关掉shell重新打开即可)。

在Arch linux中，只支持系统完整升级，不支持部分升级。所以即使在msys2中，pacman -Syu也会升级整个系统。可以观察一下，即使新安装的msys2，pacman -Syu后，msys2安装目录占用空间立马变大很多。

如果升级时，网络比较慢，觉得既浪费时间又浪费硬盘，实在不想升级那么多东西，可以逐个软件包升级。用下面命令可以升级核心包：

```shell
pacman -S --needed filesystem msys2-runtime bash libreadline libiconv libarchive libgpgme libcurl pacman ncurses libintl
```

# 卸载软件

-  该命令将只删除包，保留其全部已经安装的依赖关系

```shell
pacman -R 软件名
```

-  删除软件，并显示详细的信息

```shell
pacman -Rv 软件名
```

-  删除软件，同时删除本机上只有该软件依赖的软件。

```shell
pacman -Rs 软件名
```

-  删除软件，并删除所有依赖这个软件的程序，慎用

```shell
pacman -Rsc 软件名
```

-  删除软件,同时删除不再被任何软件所需要的依赖

```shell
pacman -Ru 软件名
```

# 搜索软件

-  在仓库中搜索含关键字的软件包（本地已安装的会标记）

```shell
pacman -Ss 关键字
```

- 显示软件仓库中所有软件的列表，可以省略，通常这样用:`pacman -Sl | 关键字`

```shell
pacman -Sl <repo>
```

-  搜索已安装的软件包

```shell
pacman -Qs 关键字
```

-  列出所有可升级的软件包

```shell
pacman -Qu
```

-  列出不被任何软件要求的软件包

```shell
pacman -Qt
```

参数加q可以简洁方式显示结果，比如pacman -Ssq gcc会比pacman -Ss gcc显示的好看一些。

> `pacman -Sl | gcc`跟`pacman -Ssq gcc`很接近，但是会少一些和gcc有关但软件名不包含gcc的包。

查询软件信息

-  查看软件包是否已安装，已安装则显示软件包名称和版本

```shell
pacman -Q 软件名
```

-  查看某个软件包信息，显示较为详细的信息，包括描述、构架、依赖、大小等等

```shell
pacman -Qi 软件名
```

-  列出软件包内所有文件，包括软件安装的每个文件、文件夹的名称和路径

```shell
pacman -Ql 软件名
```

# 清理缓存

- 清理未安装的包文件，包文件位于 /var/cache/pacman/pkg/ 目录。

```shell
pacman -Sc
```

- 清理所有的缓存文件。

```shell
pacman -Scc
```

# yay

> Yet Another Yogurt: 一个用于 Arch Linux 的工具，用于从 Arch User Repository 中构建和安装软件包。 另见 `pacman`。

- 从仓库和 AUR 中交互式搜索和安装软件包：

```shell
yay {{软件包|搜索词}}
```

- 同步并更新所有来自仓库和 AUR 的软件包：

```shell
yay
```

- 只同步和更新 AUR 软件包：

```shell
yay -Sua
```

- 从仓库和 AUR 中安装一个新的软件包。

```shell
yay -S {{软件包}}
```

- 从仓库和 AUR 中搜索软件包数据库中的关键词：

```shell
yay -Ss {{关键词}}
```

- 显示已安装软件包和系统健康状况的统计数据：

```shell
yay -Ps
```

# 最常用的pacman命令小结

pacman命令较多，作为新手，将个人最常用的命令总结如下：

- `pacman -Syu`: 升级系统及所有已经安装的软件。
- `pacman -S 软件名`: 安装软件。也可以同时安装多个包，只需以空格分隔包名即可。
- `pacman -Rs 软件名`: 删除软件，同时删除本机上只有该软件依赖的软件。
- `pacman -Ru 软件名`: 删除软件，同时删除不再被任何软件所需要的依赖。
- `pacman -Ssq 关键字`: 在仓库中搜索含关键字的软件包，并用简洁方式显示。
- `pacman -Qs 关键字`: 搜索已安装的软件包。
- `pacman -Qi 软件名`: 查看某个软件包信息，显示软件简介,构架,依赖,大小等详细信息。
- `pacman -Sg`: 列出软件仓库上所有的软件包组。
- `pacman -Sg 软件包组`: 查看某软件包组所包含的所有软件包。
- `pacman -Sc`：清理未安装的包文件，包文件位于 /var/cache/pacman/pkg/ 目录。
- `pacman -Scc`：清理所有的缓存文件。
