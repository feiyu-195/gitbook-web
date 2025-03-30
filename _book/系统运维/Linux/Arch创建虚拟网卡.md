---
title: Arch创建虚拟网卡
categories:
  - 系统运维
  - Linux
tags:
  - Linux
  - Arch
permalink: /posts/Arch创建虚拟网卡
date: 2024-07-06 14:34:23
updated: 2024-11-23 23:05:43
---
创建虚拟网卡：

```
>$ sudo ip link add dev virnet0 type veth
```

其中 virnet0 是虚拟网卡的名字，可以换成你喜欢的名字。

接下来为虚拟网卡配置IP地址：

```
>$ sudo ip addr add 192.168.20.1/24 dev virnet0
```

激活虚拟网卡，以下两条命令使用任意一条均可：

```
>$ sudo ip link set virnet0 up
>$ sudo ifconfig virnet0 up
```

现在虚拟网卡已经激活了，可以查看它的状态了：

```
>$ sudo ip link show virnet0
7: virnet0@veth0: <NO-CARRIER,BROADCAST,MULTICAST,UP,M-DOWN> mtu 1500 qdisc noqueue state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
    link/ether 7e:5e:f0:ca:c9:74 brd ff:ff:ff:ff:ff:ff
```



当然也可以用 ifconfig 查看状态：

```
>$ ifconfig virnet0
virnet0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 192.168.99.2  netmask 255.255.255.0  broadcast 0.0.0.0
        ether 7e:5e:f0:ca:c9:74  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```



停用虚拟网卡，同样是以下两条命令任选其一：

```
>$ sudo ip link set virnet0 down
>$ sudo ifconfig virnet0 down
```

此时再查看虚拟网卡的状态，发现已经是 down 的状态了：

```
>$ sudo ip link show virnet0
7: virnet0@veth0: <NO-CARRIER,BROADCAST,MULTICAST,UP,M-DOWN> mtu 1500 qdisc noqueue state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
    link/ether 7e:5e:f0:ca:c9:74 brd ff:ff:ff:ff:ff:ff
```

 

删除虚拟网卡：

```
>$ sudo ip link delete dev virnet0
```

再次查看虚拟网卡的状态，会提示该设备不存在：

```
>$ sudo ip link show virnet0
Device "virnet0" does not exist.
```



