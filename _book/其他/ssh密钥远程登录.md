---
title: ssh密钥远程登录
date: 2024-06-12 14:30:15
updated: 2024-11-15 21:49:40
categories:
  - 其他
tags:
  - SSH
permalink: /posts/ssh密钥远程登录/
---
1. 客户端生成公私钥对
![](https://ps.feiyunote.cn/assets/image-20240309155916162.png)

会要求输入密钥保存路径和密码，可以直接回车，默认位置是`~/ssh/`；

2. 使用ssh-copy-id命令上传公钥至服务器(ip=172.16.100.10)

```bash
ssh-copy-id aaa@172.16.100.10
```

![](https://ps.feiyunote.cn/assets/image-20240309161430258.png)

若想使用scp上传公钥，则：

```bash
scp ~/.ssh/id_rsa.pub aaa@172.16.100.10:/home/aaa/.ssh/authorized_keys
```
但是需注意使用该方法需提前在**服务器**创建.ssh文件夹，并将其权限改为`700`，
**原因是若.ssh目录或者是其中的公钥文件能够呗其他用户可读，将不会ssh程序识别**

```bash
chmod 700 ~/.ssh
或
chmod [400/600] ~/.ssh/authorized_keys
```

3. **在服务器**修改sshd_config文件，去掉注释启用以下参数：

```bash
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
```

4. 修改完配置文件保存退出，重启服务器sshd服务

```bash
sudo systemctl restart sshd
```

![](https://ps.feiyunote.cn/assets/image-20240309161907506.png)

5. 客户端验证登录
不用使用密码直接登陆成功
![](https://ps.feiyunote.cn/assets/image-20240309161955238.png)


注：本地密钥权限为600
