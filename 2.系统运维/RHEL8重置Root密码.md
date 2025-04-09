---
title: RHEL8重置Root密码
categories:
  - 系统运维
  - Linux
tags:
  - Linux
  - Centos
permalink: /posts/RHEL8重置Root密码/
date: 2024-03-13 14:34:38
updated: 2024-11-23 23:07:40
---
1. 关机重启，按e键进入内核编辑程序
 ![](https://ps.feiyunote.cn/assets/image-20240309152733399.png)

2. 找到指定位置输入rd.break，按Ctrl+X运行修改后的内核程序
 ![](https://ps.feiyunote.cn/assets/image-20240309152801061.png)

3、依次输入以下命令，输入reboot重启
![](https://ps.feiyunote.cn/assets/image-20240309153935924.png)

```shell
mount -o remount,rw /sysroot   # 将文件系统以只读方式挂载在`/sysroot`目录下
chroot /sysroot                # 进入chroot环境，让我们对系统文件进行安全的更改
passwd                         # 更改新密码
touch /.autorelabel            # 让下一次系统引导时启用SELinux重新标记进程，登录成功的关键
exit                           # 退出chroot模式
reboot                         # 重启系统
```

