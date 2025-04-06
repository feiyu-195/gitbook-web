---
title: RHEL8搭建DNS服务器
categories:
  - 系统运维
  - Linux
tags:
  - Linux
  - RedHat
  - DNS
permalink: /posts/RHEL8搭建DNS服务器/
date: 2024-04-19 14:34:37
updated: 2024-11-23 23:07:06
---
# 一、主要配置文件

1. 主程序名：/usr/sbin/named
2. 主配置文件：/etc/named.conf
3. 区域配置文件：/etc/named.rfc1912.zones
4. 正反向解析文件路径(名字可以自己随意设置)：/var/named/

如：正向解析区域文件：xxx.com.zone

反向解析区域文件：xxx.com.arpa

# 二、准备工作

1. 环境：两台红帽8.2；前提，做DNS服务器的系统必须已搭建完本地yum源，用于下载bind；两台虚拟机之间能够互相通信。
2. 安装bind：
```shell
sudo yum install bind* -y
```

# 三、开始搭建

注：本次搭建需要操作的文件全部都需要root权限才能修改，若不是root用户，记得用sudo命令。

1. 修改配置文件/etc/named.conf

![image-20240220144321054](https://ps.feiyunote.cn/assets/image-20240220144321054.png)

2. 编辑区域信息配置文件 /etc/named.rfc1912.zones

*注*：直接在文件最后追加区域信息即可

![image-20240220144340396](https://ps.feiyunote.cn/assets/image-20240220144340396.png)

​	a. 其中type是服务类型有三种：hint（根区域）、master（主区域）、slave（辅助区域）
​	b. 其中file是域名与IP地址解析规则保存的文件地址。
​	c. 其中allow-update是允许那些客户机动态更新解析信息，在配置从DNS服务器时使用。

3. 编辑正向解析信息

注意区域文件中的file信息位置，在/var/named/文件夹下创建对应名字的文件“hehe.com.zone”, "172.16.100.arpa"。
```shell
[root@localhost ~]# cd /var/named/ 
[root@localhost named]# ls -al named.localhost 
-rw-r-----. 1 root named 152 Aug 25 01:31 named.localhost 
[root@localhost named]# cp -a named.localhost hehe.com.zone    #注意此处使用-a选项的意义，为了连同named.localhost文件的文件属组信息一起复制出来，若没使用-a，后续可以用chown命令为相应文件进行修改。 
[root@localhost named]# vim hehe.com.zone
```

![image-20240220144511912](https://ps.feiyunote.cn/assets/image-20240220144511912.png)

对“hehe.com.zone”进行修改，二级域名c1的意思为“c1.hehe.com”，A记录即为ipv4记录。

1. 编辑反向解析信息
```shell
[root@localhost ~]# cd /var/named/
[root@localhost named]# ls -al named.loopback
-rw-r-----. 1 root named 152 Aug 25 01:31 named.loopback
[root@localhost named]# cp -a named.loopback 172.16.100.arpa
[root@localhost named]# vim 172.16.100.arpa
```

![image-20240220144528033](https://ps.feiyunote.cn/assets/image-20240220144528033.png)

1. 测试配置文件是否出错

用`named-checkzone`命令对正向解析区域和反向解析区域进行测试是否有错。

```bash
named-checkzone 文件名 /var/named/文件名
```



# 四、测试

1. 重启DNS服务，查看状态
```shell
[root@localhost named]# systemctl restart named //重启服务 
[root@localhost named]# systemctl status named //查看运行状态
```

1. 测试

使用另一台linux主机（客户端），编辑/etc/resolv.conf文件，添加一条解析记录指向DNS服务器IP：

![image-20240220144538538](https://ps.feiyunote.cn/assets/image-20240220144538538.png)

用nslookup命令测试，出现以下两条信息说明正向和反向解析都已成功，此时使用ping命令pingDNS服务器域名也可ping通。

![image-20240220144620121](https://ps.feiyunote.cn/assets/image-20240220144620121.png)

![image-20240220144627813](https://ps.feiyunote.cn/assets/image-20240220144627813.png)