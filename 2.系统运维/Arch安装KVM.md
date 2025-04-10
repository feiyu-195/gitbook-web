---
title: Arch安装KVM
categories:
  - 系统运维
  - Linux
tags:
  - Linux
  - Arch
  - KVM
permalink: /posts/Arch安装KVM/
date: 2024-11-08 14:34:27
updated: 2024-11-23 23:05:25
---
# 安装使用

KVM(Kernel-based Virtual Machine, 即内核级虚拟机) 是一个开源的系统虚拟化模块。

QEMU是个独立的虚拟化解决方案，从这个角度它并不依赖KVM。而KVM是另一套虚拟化解决方案，不过因为这个方案实际上只实现了内核中对处理器（Intel VT）, AMD SVM)虚拟化特性的支持，换言之，它缺乏设备虚拟化以及相应的用户空间管理虚拟机的工具，所以它借用了QEMU的代码并加以精简，连同KVM一起构成了另一个独立的虚拟化解决方案：KVM + QEMU。

要使用起来，需要硬件支持，并且需要加载相应的模块。按以下的步骤去检测安装即可。

```shell
sudo pacman -S qemu libvirt ovmf virt-manager dnsmasq bridge-utils openbsd-netcat
```

- kvm 负责CPU和内存的虚拟化
- qemu 向Guest OS模拟硬件（例如，CPU，网卡，磁盘，等）
- ovmf 为虚拟机启用UEFI支持
- libvirt 提供管理虚拟机和其它虚拟化功能的工具和API
- virt-manager 是管理虚拟机的GUI

**注** : 实际上，这步只需要安装qemu就可以使用虚拟机，但是qemu-kvm接口有些复杂，libvirt和virt-manager让配置和管理虚拟机更便捷。



# 启动KVM libvirt服务

- 启用服务并设置开机自启动

```shell
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service
```

- 查看运行状态

```shell
systemctl status libvirtd.service
```

# 配置普通用户可以使用KVM

- 打开/etc/libvirt/libvirtd.conf文件进行编辑。

```shell
sudo pacman -S vim
sudo vim /etc/libvirt/libvirtd.conf
```

- 将UNIX域套接字组所有权设置为libvirt（第85行左右）

```shell
unix_sock_group = "libvirt"
```

- 为R/W套接字设置UNIX套接字权限（第102行附近）

```shell
unix_sock_rw_perms = "0770"
```

- 将当前用户帐户添加到libvirt组

```shell
sudo usermod -a -G libvirt $(whoami)
newgrp libvirt
```

- 重新启动libvirt守护进程。

```shell
sudo systemctl restart libvirtd.service
```



# 启用嵌套虚拟化（可选）

- 嵌套虚拟化就是在虚拟机中运行虚拟机。
  如图所示，通过启用内核模块为kvm_intel / kvm_amd启用嵌套虚拟化。

一般不会这样搞。

```shell
### Intel Processor ###
sudo modprobe -r kvm_intel
sudo modprobe kvm_intel nested=1

### AMD Processor ###
sudo modprobe -r kvm_amd
sudo modprobe kvm_amd nested=1
```

- 要使此配置持久化，请运行：

```shell
echo "options kvm-intel nested=1" | sudo tee /etc/modprobe.d/kvm-intel.conf
```

- 确认“嵌套虚拟化”设置为“yes”：

```shell
## Intel Processor ###
$ systool -m kvm_intel -v | grep nested
    nested              = "Y"
    nested_early_check  = "N"
$ cat /sys/module/kvm_intel/parameters/nested
Y

### AMD Processor ###
$ systool -m kvm_amd -v | grep nested
    nested              = "Y"
    nested_early_check  = "N"
$ cat /sys/module/kvm_amd/parameters/nested 
Y
```

# 在Arch Linux 上使用KVM

至此，已经在Arch Linux上成功安装了KVM、QEMU和Virt Manager。现在就可以用了。

```
virt-install --name vmware --memory 8192 --vcpus sockets=2,cores=2,threads=2 --disk device=cdrom,path=/mnt/Windows-D/VirtualMachine/Images/VMware-VMvisor-Installer-201701001-4887370.x86_64.iso --disk path=/mnt/Windows-D/VirtualMachine/KVM/esxi-1.img,size=200,bus=ide --network bridge=virbr1,model=e1000 --noautoconsole --accelerate --hvm --graphics vnc,listen=0.0.0.0,port=20005 --video vga --input tablet,bus=usb --cpu host-passthrough
```
