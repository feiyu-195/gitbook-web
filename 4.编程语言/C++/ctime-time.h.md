---
title: ctime-time.h
date: 2024-03-13 14:22:44
updated: 2024-11-15 21:49:39
categories:
  - 编程语言
  - CCPlusPlus
  - CPlusPlus
  - CPlusPlus文件头
tags:
  - C语言
permalink: /posts/ctime-time.h/
---
## 时间的数据类型
### （1）struct tm
自1900年至今**经过的时间**：

| Member   | Type | Meaning                   | Range |
| -------- | ---- | ------------------------- | ----- |
| tm_sec   | int  | seconds after the minute  | 0-60* |
| tm_min   | int  | minutes after the hour    | 0-59  |
| tm_hour  | int  | hours since midnight      | 0-23  |
| tm_mday  | int  | day of the month          | 1-31  |
| tm_mon   | int  | months since January      | 0-11  |
| tm_year  | int  | **years since 1900**      |       |
| tm_wday  | int  | days since Sunday         | 0-6   |
| tm_yday  | int  | days since January 1      | 0-365 |
| tm_isdst | int  | Daylight Saving Time flag |       |

### （2）clock_t

- 表示时钟的滴答，可以用ticks 表示。实际是long类型。
- 1秒的clicks为CLOCKS_PER_SEC个ticks，定义为1000个。

### （3）time_t

从1900年1月1日0点UTC时间开始的时间， 实际是一个long类型。单位**秒**。

### （4）size_t

size_t类型很多地方都可以使用，实际上是一个unsigned int类型。

## 2. 时间转换函数
5个时间转换函数功能如下：

|函数|说明|
|---|---|
|asctime|tm 转 string|
|ctime|time_t 转 string|
|gmtime|UTC时间的time_t 转 tm|
|localtime|本地时间的time_t 转 tm|
|strftime|格式化为string|
|mktime|tm 转time_t|

## 3. 时间操作的函数

有4种处理时间的函数：

| 函数         | 描述                                                                     |
| ---------- | ---------------------------------------------------------------------- |
| time()     | 获取当地时间，返回time_t类型。返回的时间为UTC格林尼治时间1970年1月1日00:00:00到当前时刻的时长，**时长单位是秒**。 |
| clock()    | 获取时钟的clicks，返回clock_t类型。                                               |
| difftime() | 获取时间差的函数，返回double类型。其实可以直接做减法                                          |

```c++
#include <iostream>
#include <time.h>

int main ()
{
  time_t timer;
  time(&timer);  //或者timer = time(NULL),两种方式获取当地时间
  std::cout << timer <<std::endl;

  return 0;
}
```

```c++
#include <iostream>
#include <time.h>       /* clock_t, clock, CLOCKS_PER_SEC */

int main ()
{
  clock_t t;
  int f;
  t = clock();//获取现在的clicks

  for (int i=0; i<=10000; ++i)
      for (int j=0;j<10000;++j)
  {
      int x = i + j;
  }

  t = clock() - t;//获取ticks差

  std::cout << "Time diff: " << t << " ticks" << std::endl;
  std::cout << "Time diff: " << ((float)t/CLOCKS_PER_SEC) << " s" <<std::endl;

  return 0;
}

```

```c++
#include <iostream>
#include <time.h>       /* time_t, struct tm, difftime, time, mktime */
#include <string>

int main ()
{
  time_t t1;
  time_t t2;
  struct tm tm1, tm2;
  double seconds;

  time(&t1);//获取现在的时间
  for (int i=0; i<=100000; ++i)
       for (int j=0;j<100000;++j)
   {
       int x = i + j;
   }
  time(&t2);//获取现在的时间

  seconds = difftime(t2,t1);//返回double类型
  int diffTime = t2 - t1;//因为time_t为long类型
  std::cout << "difftime(): " << seconds <<std::endl;
  std::cout << "sub: " << diffTime <<std::endl;

  return 0;
}

```
