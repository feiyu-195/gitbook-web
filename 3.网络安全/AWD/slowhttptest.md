---
title: slowhttptest
date: 2024-09-27 14:30:37
updated: 2024-11-15 21:49:39
categories:
  - 网络安全
  - AWD
tags:
  - AWD
  - 网络安全
permalink: /posts/slowhttptest/
---
# [slowhttptest慢速攻击工具使用详解](https://www.cnblogs.com/gorillalee/p/14354751.html)

**参考文章**

- [浅谈“慢速HTTP攻击Slow HTTP Attack”](https://blog.csdn.net/weixin_39934520/article/details/107707268?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522161195258816780264086873%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=161195258816780264086873&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~baidu_landing_v2~default-1-107707268.first_rank_v2_pc_rank_v29&utm_term=http+attack)
- [HTTP慢速攻击](https://www.cnblogs.com/endust/p/11960901.html)
- [Slowhttptest攻击原理](https://cloud.tencent.com/developer/article/1180216)
- [InstallationAndUsage](https://github.com/shekyan/slowhttptest/wikic)

本片文章仅供学习使用，切勿触犯法律！

------

# 一、简要介绍

SlowHTTPTest是一款对服务器进行慢攻击的测试软件，所谓的慢攻击就是相对于cc或者DDoS的快而言的，并不是只有量大速度快才能把服务器搞挂，使用慢攻击有时候也能到达同一效果。slowhttptest包含了之前几种慢攻击的攻击方式，包括slowloris, Slow HTTP POST, Slow Read attack等。那么这些慢攻击工具的原理就是想办法让服务器等待，当服务器在保持连接等待时，自然就消耗了资源。

# 二、下载安装

Kali Linux：

```csharp
apt-get install slowhttptest 
```

其他Linux发行版：

```powershell
tar -xzvf slowhttptest-x.x.tar.gz
cd slowhttptest-x.x
./configure --prefix=PREFIX
make
sudo make install
```

PREFIX替换为应该安装slowhttptest工具的绝对路径。
需要安装libssl-dev才能成功编译该工具。

MacOS安装命令：

```mipsasm
brew update && brew install slowhttptest
```

git安装：

```bash
git clone https://github.com/shekyan/slowhttptest
```

# 三、执行使用

默认参数测试
`./slowhttptest`
其回应的相关参数：

| test type                         | 测试类型               |
| --------------------------------- | ---------------------- |
| number of connections             | 连接数                 |
| URL                               | 网址                   |
| verb                              | 动词                   |
| interval between follow up data   | 随机数据之间的间隔     |
| connections per second            | 每秒连接数             |
| test duration                     | 测试时间               |
| probe connection timeout          | 探针连接超时           |
| max length of followup data field | 后续数据字段的最大长度 |

## 1、参数说明

| 选项         | 描述                                                                                                   |
| ---------- | ---------------------------------------------------------------------------------------------------- |
| -a 开始      | 用于范围标头测试的range-specifier的起始值                                                                         |
| -b 字节      | 范围标题测试的范围说明符限制                                                                                       |
| -c 连接数     | 限于65539                                                                                              |
| -d 代理主机：端口 | 通过Web代理定向所有流量                                                                                        |
| -e 代理主机：端口 | 用于仅通过Web代理定向探测流量                                                                                     |
| -H，B，R或X   | 指定在标头部分或消息正文中放慢速度，-R启用范围测试，-X启用慢速读取测试                                                                |
| -f 内容类型    | 内容类型标头的值                                                                                             |
| -g         | 生成CSV和HTML格式的统计信息，格式为slow_xxx.csv / html，其中xxx是时间和日期                                                 |
| -i 秒       | 每个连接的后续数据之间的间隔（以秒为单位）                                                                                |
| -j cookie  | Cookie标头的值（例如：-j“ user_id = 1001；超时= 9000”）                                                          |
| -k 流水线系数   | 如果服务器支持HTTP管道，则在同一连接中重复请求以进行慢速读取测试的次数。                                                               |
| -l 秒       | 测试持续时间（以秒为单位）                                                                                        |
| -m 接受      | Accept标头的值                                                                                           |
| -n 秒       | 从接收缓冲区读取操作之间的间隔                                                                                      |
| -o 文件      | 定制输出文件的路径和/或名称，如果指定了-g，则有效                                                                           |
| -p 秒       | 等待探针连接上的HTTP响应超时，此后服务器被视为不可访问                                                                        |
| 每秒-r个连接    | 连接率                                                                                                  |
| -s 字节      | 如果指定了-B，则Content-Length标头的值                                                                          |
| -t 动词      | 要使用的自定义动词                                                                                            |
| -u URL     | 目标URL，与您在浏览器中键入的格式相同，例如http [s](https://github.com/shekyan/slowhttptest/wiki/s.md)：// host [：port] / |
| -v 级       | 日志0-4的详细级别                                                                                           |
| -w 字节      | 范围的开始，将从中选择广告窗口大小                                                                                    |
| -x 字节      | 随访数据的最大长度                                                                                            |
| -y 字节      | 范围的末端，将从中选择广告窗口大小                                                                                    |
| -z 字节      | 通过单个read（）操作从接收缓冲区读取的字节                                                                              |

## 2、功能命令

slowloris模式：

```armasm
slowhttptest -c 1000 -H -i 10 -r 200 -t GET -u https://yourtarget.com/index.html -x 24 -p 3
```

Slow Body攻击：
慢消息正文模式下的用法示例

```css
slowhttptest -c 1000 -B -g -o my_body_stats -i 110 -r 200 -s 8192 -t FAKEVERB -u http://www.mywebsite.com -x 10 -p 3
```

Slow Read模式：

```yaml
slowhttptest -c 1000 -X -r 1000 -w 10 -y 20 -n 5 -z 32 -u http://yourtarget.co
```

慢节奏模式下的用法示例：

```bash
./slowhttptest -c 1000 -H -g -o my_header_stats -i 10 -r 200 -t GET -u https://myseceureserver/resources/index.html -x 24 -p 3
```

通过在xxxx：8080上的代理进行探测：

```bash
./slowhttptest -c 1000 -X -r 1000 -w 10 -y 20 -n 5 -z 32 -u http://someserver/somebigresource -p 5 -l 350 -e x.x.x.x:8080
```

## 3、错误信息

| 错误信息                      | 这是什么意思                                                 |
| ----------------------------- | ------------------------------------------------------------ |
| "Hit test time limit"         | 程序达到了用-l参数指定的时间限制                             |
| "No open connections left"    | 同行关闭了所有连接                                           |
| "Cannot establish connection" | 在测试的前N秒内未建立任何连接，其中N是-i参数的值，或者是10（如果未指定）。如果没有到主机的路由或远程对等体断开，则会发生这种情况 |
| "Connection refused"          | 远程对等方不接受指定端口上的连接（仅来自您？使用代理进行探测） |
| "Cancelled by user"           | 您按了Ctrl-C或以其他方式发送了SIGINT                         |
| "Unexpected error"            | 永远不会发生                                                 |

## 3、判断依据

1. 当服务器可控，可以通过以下命令来确认是否存在该漏洞：

```bash
pgrep http | wc -l  进程数量
netstat -antp | grep 443 | wc -l  网络连接数量
```

1. 在攻击的时间段，服务无法正常访问则存在漏洞。