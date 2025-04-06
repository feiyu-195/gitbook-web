---
title: Ubuntu常用软件包安装
categories:
  - 系统运维
  - Linux
tags:
  - Linux
  - Ubuntu
permalink: /posts/Ubuntu常用软件包安装/
date: 2024-08-08 14:34:32
updated: 2024-11-15 21:49:40
---
### 1、bash命令补全工具

```shell
sudo apt-get -y install bash-completion

# 在用户的shell中运行
source /etc/bash_completion
```



### 2、docker

```shell
#卸载操作系统默认安装的docker，
sudo apt-get remove docker docker-engine docker.io containerd runc

#安装必要支持
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release -y

#添加 Docker 官方 GPG key
# Ubuntu
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
#Debian
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/debian/gpg | apt-key add -



#添加 apt 源:
# Ubuntu
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#Debian
add-apt-repository "deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian $(lsb_release -cs) stable"

#更新源
sudo apt-get update

#安装最新版本的Docker
# Ubuntu
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
#Debian
apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
```

2）允许非Root用户执行docker 命令

```shell
# 添加docker用户组
sudo groupadd docker

# 将当前用户添加到用户组
sudo usermod -aG docker $USER

# 使权限生效
newgrp docker

#如果没有此行命令，你会发现，当你每次打开新的终端
#你都必须先执行一次 “newgrp docker” 命令
#否则当前用户还是不可以执行docker命令
groupadd -f docker
```

3）配置docker镜像加速

```shell
sudo tee > /etc/docker/daemon.json << EOF
{
   "registry-mirrors": [
   "https://mirror.ccs.tencentyun.com"
  ]
}
EOF
sudo systemctl restart docker
```



### 3、docker-compose

```shell
# pip3安装（此方法不适用于Ubuntu22.04tls）
sudo apt-get -y install python3-pip
sudo pip3 install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple
sudo pip3 install docker-compose -i https://pypi.tuna.tsinghua.edu.cn/simple

# 软件包安装
cd /usr/local/bin/
sudo wget https://github.com/docker/compose/releases/download/v2.27.1/docker-compose-linux-x86_64
mv docker-compose-linux-x86_64 docker-compose
sudo chmod +x docker-compose
```



### 4、Nginx

```shell
# 安装相关依赖
sudo apt install -y curl gnupg2 ca-certificates lsb-release

# 安装Nginx
sudo apt install -y nginx
```



