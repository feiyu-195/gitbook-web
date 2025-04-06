---
title: kvm虚拟机配置增强功能
categories:
  - 系统运维
  - Linux
tags:
  - Linux
  - Arch
  - KVM
permalink: /posts/kvm虚拟机配置增强功能/
date: 2024-11-08 14:34:27
updated: 2024-11-23 23:06:30
---
# qemu/kvm linux 虚拟机配置（共享剪切版，文件拖拽进虚拟机）




注意：这里说的是虚拟机的配置，不是宿主机的配置

```shell
sudo apt install qemu-guest-agent spice-vdagent
sudo yum install qemu-guest-agent spice-vdagent -y

systemctl enable qemu-guest-agent
systemctl enable spice-vdagent
```



qemu-guest-agent，spice-vdagent 安装后体验直线上升，可以双向拖拽，共享剪切版，自适应缩放

virt-what 可以查询虚拟机使用的虚拟化技术

```shell
sudo apt install virt-what
```

