---
title: Crypto算法库详解
date: 2024-03-13 14:23:04
updated: 2024-11-15 21:49:39
categories:
  - 编程语言
  - python
tags:
  - python
permalink: /posts/Crypto算法库详解/
---
## 一、概述

**常见对称密码**在 Crypto.Cipher 库下，主要有：DES、3DES、AES、RC4、Salsa20

**非对称密码**在 Crypto.PublicKey 库下，主要有：RSA、ECC、DSA

**哈希密码**在 Crypto.Hash 库下，常用的有：MD5、SHA-1、SHA-128、SHA-256

**随机数**在 Crypto.Random 库下

**实用小工具**在 Crypto.Util 库下

**数字签名**在 Crypto.Signature 库下

## 二、详解

1、Crypto.Cipher

示例

```python
from Crypto.Cipher import AES
import base64

key = bytes('this_is_a_key'.ljust(16,' '),encoding='utf8')
aes = AES.new(key,AES.MODE_ECB)

# encrypt
plain_text = bytes('this_is_a_plain'.ljust(16,' '),encoding='utf8')
text_enc = aes.encrypt(plain_text)
text_enc_b64 = base64.b64encode(text_enc)
print(text_enc_b64.decode(encoding='utf8'))

# decrypt
msg_enc = base64.b64decode(text_enc_b64)
msg = aes.decrypt(msg_enc)
print(msg.decode(encoding='utf8'))
```

2、Crypto.PublicKey

3、Crypto.Hash

4、Crypto.Random

5、Crypto.Util

6、Crypto.Signature