---
title: 通过公钥文件获取n，e
date: 2024-03-13 14:23:02
updated: 2024-11-15 21:49:39
categories:
  - 编程语言
  - python
tags:
  - python
permalink: /posts/通过公钥文件获取n，e/
---
## 通过公钥文件获取n，e
```python
from Crypto.PublicKey import RSA

with open("./key.pub", "rb") as file:
    key = file.read()

print(key)
pub = RSA.importKey(key)
n = pub.n
e = pub.e
print("n = ", n)
print("e = ", e)

```

