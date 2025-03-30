---
title: z3库（z3_solver）使用
date: 2024-03-13 14:23:12
updated: 2024-11-15 21:49:39
categories:
  - 编程语言
  - python
tags:
  - python
permalink: /posts/z3库（z3_solver）使用/
---
# z3库（z3_solver）使用

**简介**

>  Z3 在工业应用中实际上常见于软件验证、程序分析等。然而由于功能实在强大，也被用于很多其他领域。CTF 领域中，能够用约束求解器搞定的问题常见于密码题、二进制逆向、符号执行、Fuzzing 模糊测试等。

**库内函数：**

1.创建一个解的声明对象：

```python
s = Solver() 
```

2.添加条件：

```python
s.add(判断公式)
```

3.判断是否有解：

```python
s.check() # 如果有解,则反回sate/sat 反之 返回 unsate/unsat
```

4.返回最后的解：

```python
result=s.modul()
print(result)
```

5.声明不同类型的未知数：

```python
a, s, d = Ints('a s d')#创建一个‘int’类型的对象，但其实运算时候是'ArithRef'类型，并且无法使用按位运算 
x = Real('x')   #创建一个有理数类型的变量。 
y = Real('y')  
```

z3库最牛逼的来了:上面两个就是比正常多元未知数复杂了点，求解按位运算才是这个库最吊的！

```python
BitVecs(name,bv,ctx=None)     # 创建一个有多变量的位向量，name是名字，bv表示大小
# a,b,c=s=BitVecs('a b c',32)
Bitvex(name,bv,ctx=None)      # 创建一个位向量，name是他的名字，bv表示大小
BitVecSort(bv,ctx=None)       # 创建一个指定大小的位向量
BitVecVal(val,bv,ctx=None)    # 创建一个位向量，有初始值，没名字
```

**整型(Int)方程求解**

```python
from z3 import *

a, s, d = Ints('a s d')
x = Solver()
x.add(a-d == 18)
x.add(a+s == 12)
x.add(s-d == 20)
check = x.check()
print(check)
model = x.model()
print(model)
# sat
# [a = 5, d = -13, s = 7]
```

**有理数(Real)型解方程求解**

```python
from z3 import *

x = Real('x')
y = Real('y')
s = Solver()
s.add(x**2 + y**2 == 3)
s.add(x**3 == 2)
check = s.check()
print(check)
model = s.model()
print(model)
# sat
# [y = -1.1885280594?, x = 1.2599210498?]
```



**位向量(BitVec)型解方程**

```python
from z3 import *

x, y, z = BitVecs('x y z', 8)
s = Solver()
s.add(x ^ y & z == 12)
s.add(y & z >> 3 == 3)
s.add(z ^ y == 4)
check = s.check()
print(check)
model = s.model()
print(model)
# sat
# [z = 27, y = 31, x = 23]
```

