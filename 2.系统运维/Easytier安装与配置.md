---
title: Easytier安装与配置
date: 2025-01-03 14:15:28
updated: 2025-04-10 14:45:59
tags:
  - 组网
permalink: /posts/Easytier安装与配置/
---
# 下载

GitHub地址：[EasyTier](https://github.com/EasyTier/EasyTier).

1. **下载预编译的二进制文件**

	访问 [GitHub Release 页面](https://github.com/EasyTier/EasyTier/releases) 下载适用于您操作系统的二进制文件。Release 压缩包中同时包含命令行程序和图形界面程序。

2. **解压安装**

```bash
# 下载
wget https://github.com/EasyTier/EasyTier/releases/download/v2.1.1/easytier-linux-x86_64-v2.1.1.zip
# 解压
unzip easytier-linux-x86_64-v2.1.1.zip -d ~/
# 添加软链接
cd ~/
sudo ln -s easytier-linux-x86_64/easytier-cli /usr/local/bin/
sudo ln -s easytier-linux-x86_64/easytier-core /usr/local/bin/
# 验证
easytier-core --version
easytier-cli --version
```

# 使用指南

### 无公网IP组网

EasyTier 支持共享公网节点进行组网。目前已部署共享的公网节点 `tcp://public.easytier.top:11010`。

使用共享节点时，需要每个入网节点提供相同的 `--network-name` 和 `--network-secret` 参数，作为网络的唯一标识。

以双节点为例，节点 A 执行：

```shell
sudo easytier-core -i 10.144.144.1 --network-name abc --network-secret abc -e tcp://public.easytier.top:11010
```

节点 B 执行

```shell
sudo easytier-core --ipv4 10.144.144.2 --network-name abc --network-secret abc -e tcp://public.easytier.top:11010
```

命令执行成功后，节点 A 即可通过虚拟 IP 10.144.144.2 访问节点 B。

### 双节点组网

假设双节点的网络拓扑如下

1. 在节点 A 上执行：

    ```shell

sudo easytier-core --ipv4 10.144.144.1

    ```

命令执行成功会有如下打印。

2. 在节点 B 执行

    ```shell

sudo easytier-core --ipv4 10.144.144.2 --peers udp://22.1.1.1:11010

    ```

3. 测试联通性

    两个节点应成功连接并能够在虚拟子网内通信

    ```shell

ping 10.144.144.2

    ```

    使用 easytier-cli 查看子网中的节点信息

    ```shell

easytier-cli peer

    ```

    ```shell

easytier-cli route

    ```

    ```shell

easytier-cli node

    ```

# 添加systemd单元

```shell
[Unit]
Description=easytier
After=network.target

[Service]
Type=simple
ExecStart=easytier-core --hostname test_name -i 10.144.144.1 --network-name abc --network-secret abc -e tcp://public.easytier.top:11010
WorkingDirectory=/path/to/you/easytier-linux-x86_64
User=root
Group=root

[Install]
WantedBy=multi-user.target
```

启动easytier并添加开机自启

```bash
# 重载systemd
sudo systemctl daemon-reload
# 重启easytier
sudo systemctl restart easytier.service
# 开机自启
sudo systemctl enable easytier.service
```
