---
title: gmpy2库的使用
date: 2024-03-13 14:23:07
updated: 2024-11-15 21:49:39
categories:
  - 编程语言
  - python
tags:
  - python
permalink: /posts/gmpy2库的使用/
---
## gmpy2库的使用



1. 初始化一个高精度的数据类型

```python
a=gmpy2.mpz(x)     #可以为变量a赋予一个高精度的大整数（长度可达50位） 
a=gmpy2.mpq(x)     #可以为变量a初始化一个高精度的分数 
a=gmpy2.mpfr(x)    #可以为a初始化一个高精度的浮点数 
a=gmpy2.mpc(x)     #可以为a初始化一个高精度的复数
```



2. 其它的常用语法

```python
gmpy2.powmod(a, n, p)     # 模幂运算,对于给定的整数p,n,a,计算aⁿ 
mod p gmpy2.iroot(x, n)         # 对x开n次方根 
gmpy2.gcd(a, b)           # 欧几里得算法,求得a，b的最大公约数 
gmpy2.lcm(a, b)           # 欧几里得算法,求得最小公倍数 
gmpy2.gcdext(e1, e2)      # 扩展欧几里得,求式子e1*x+e2*y=gcd(e1,e2)。在RSA加密算法中利用该公式来求e的逆元d，由于实际上公钥e的选取需要保证gcd（e，ψ(n)）=1，所以在这种情况下式子的右边就是1，且通常用下面这个公式来求逆元。 
gmpy2.invert(a, c)        # 模逆运算,对a，求b，使得a*b=1（mod c） 
gmpy2.is_prime()          # 素数检测 
gmpy2.is_even()           # 奇数检测 
gmpy2.is_odd()            # 偶数检测
```

