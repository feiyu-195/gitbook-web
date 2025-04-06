---
title: cstdlib-stdlib.h
date: 2024-03-13 14:22:40
updated: 2024-11-15 21:49:39
categories:
  - 编程语言
  - CCPlusPlus
  - CPlusPlus
  - CPlusPlus文件头
tags:
  - C语言
permalink: /posts/cstdlib-stdlib.h/
---
此头文件定义了几个通用功能，包括：
- 动态内存管理
- 随机数生成
- 与环境的通信
- 整数算术
- 搜索、排序
- 转换

1. **字符串转换函数**

| 函数                                                                               | 描述                                  |
| -------------------------------------------------------------------------------- | ----------------------------------- |
| [**atof**](http://www.cplusplus.com/reference/cstdlib/atof/)                     | 转换 string -> double                 |
| [**atoi**](http://www.cplusplus.com/reference/cstdlib/atoi/)                     | 转换 string -> int                    |
| [**atol**](http://www.cplusplus.com/reference/cstdlib/atol/)                     | 转换 string -> long int               |
| **[atoll](http://www.cplusplus.com/reference/cstdlib/atoll/) (C++11)**           | 转换 string -> long long int          |
| 下述函数是上述函数的稳定代替                                                                   |                                     |
| [**strtod**](http://www.cplusplus.com/reference/cstdlib/strtod/)                 | 转换 string -> double                 |
| [**strtof**](http://www.cplusplus.com/reference/cstdlib/strtof/) **(C++11)**     | 转换 string -> float                  |
| [**strtol**](http://www.cplusplus.com/reference/cstdlib/strtol/)                 | 转换 string -> long int               |
| [**strtoul**](http://www.cplusplus.com/reference/cstdlib/strtoul/)               | 转换 string -> unsigned long int      |
| [**strtoll**](http://www.cplusplus.com/reference/cstdlib/strtoll/) **(C++11)**   | 转换 string -> long long int          |
| [**strtoull**](http://www.cplusplus.com/reference/cstdlib/strtoull/) **(C++11)** | 转换 string -> unsigned long long int |

2. **伪随机序列生成**

| 函数                                                             | 描述        |
| -------------------------------------------------------------- | --------- |
| [**srand**](http://www.cplusplus.com/reference/cstdlib/srand/) | 初始化随机数生成器 |
| [**rand**](http://www.cplusplus.com/reference/cstdlib/rand/)   | 生成随机数     |

3. **动态内存管理**

| 函数                                                                 | 描述        |
| ------------------------------------------------------------------ | --------- |
| [**calloc**](http://www.cplusplus.com/reference/cstdlib/calloc/)   | 分配和零初始化数组 |
| [**free**](http://www.cplusplus.com/reference/cstdlib/free/)       | 解除已分配内存块  |
| [**malloc**](http://www.cplusplus.com/reference/cstdlib/malloc/)   | 分配内存块     |
| [**realloc**](http://www.cplusplus.com/reference/cstdlib/realloc/) | 重新分配内存块   |

4. **搜索和排序**

| 函数                                                                 | 描述              |
| ------------------------------------------------------------------ | --------------- |
| [**bsearch**](http://www.cplusplus.com/reference/cstdlib/bsearch/) | 对数组进行二进制搜索      |
| [**qsort**](http://www.cplusplus.com/reference/cstdlib/qsort/)     | 采用快速排序对数组元素进行排序 |

5. **数学函数**

| 函数                                                           | 描述                |
| ------------------------------------------------------------ | ----------------- |
| [**abs**](http://www.cplusplus.com/reference/cstdlib/abs/)   | 计算整数的绝对值          |
| [**labs**](http://www.cplusplus.com/reference/cstdlib/labs/) | 计算长整数的绝对值         |
| [**div**](http://www.cplusplus.com/reference/cstdlib/div/)   | 除以整数得出商，返回余数结果    |
| [**ldiv**](http://www.cplusplus.com/reference/cstdlib/ldiv/) | 除以长整数整数得出商，返回余数结果 |

6. **多字节字符和字符串**

| 函数                                                                   | 描述                |
| -------------------------------------------------------------------- | ----------------- |
| [**mblen**](http://www.cplusplus.com/reference/cstdlib/mblen/)       | 返回多字节符的长度大小       |
| [**mbtowc**](http://www.cplusplus.com/reference/cstdlib/mbtowc/)     | 将多字节字符转换为宽字符      |
| [**wctomb**](http://www.cplusplus.com/reference/cstdlib/wctomb/)     | 将宽字符转换为多字节字符      |
| [**mbstowcs**](http://www.cplusplus.com/reference/cstdlib/mbstowcs/) | 将多字节字符串序列转换为宽字符序列 |
| [**wcstombs**](http://www.cplusplus.com/reference/cstdlib/wcstombs/) | 将宽字符序列转换为多字节字符串序列 |

7. 程序进程控制

| 函数                                                                         | 描述         |
| -------------------------------------------------------------------------- | ---------- |
| [**abort**](http://www.cplusplus.com/reference/cstdlib/abort/)             | 中止当前进程     |
| [**atexit**](http://www.cplusplus.com/reference/cstdlib/atexit/)           | 设置退出时执行的函数 |
| [**exit**](http://www.cplusplus.com/reference/cstdlib/exit/)               | 终止呼叫进程     |
| [**getenv**](http://www.cplusplus.com/reference/cstdlib/getenv/)           | 获取环境字符串    |
| [**system**](http://www.cplusplus.com/reference/cstdlib/system/)           | 执行系统命令     |

