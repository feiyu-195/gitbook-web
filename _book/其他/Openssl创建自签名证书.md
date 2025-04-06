---
title: Openssl创建自签名证书
date: 2024-07-06 14:30:13
updated: 2025-03-23 10:56:16
categories:
  - 其他
tags:
  - SSL
permalink: /posts/Openssl创建自签名证书/
---
# 生成根证书的私钥和证书

```shell
openssl req -x509 -nodes -days 36500 -newkey rsa:2048 -subj "/C=CN/ST=China/L=China/O=Private" -keyout ./cert/CA.key -out ./cert/CA.crt -reqexts v3_req -extensions v3_ca
```

- `req`：表示使用 OpenSSL 的请求（request）功能。
- `-x509`：生成自签名证书。
- `-nodes`：不加密私钥。
- `-days 36500`：证书有效期为 36500 天，即大约 100 年。
- `-newkey rsa:2048`：生成一个新的 RSA 私钥，密钥长度为 2048 位。
- `-subj "/C=CN/ST=China/L=China/O=private"`：指定证书的主题信息，包括国家代码（CN）、省份（ST）、城市（L）和组织（O）。
- `-keyout ./cert/CA.key`：指定私钥的输出文件路径。
- `-out ./cert/CA.crt`：指定证书的输出文件路径。
- `-reqexts v3_req`：指定请求扩展的配置文件（v3_req.cnf）。
- `-extensions v3_ca`：指定证书扩展的配置文件（v3_ca.cnf）。

# 创建应用证书

```shell
# 创建应用证书的私钥
openssl genrsa -out ./cert/nginx.key 2048

# 根据应用证书的私钥创建一个证书请求文件csr
openssl req -new -key  ./cert/nginx.key -subj "/C=CN/ST=China/L=China/O=Private/CN=192.168.111.3" -sha256 -out  ./cert/nginx.csr

# 根据应用证书请求文件创建应用证书，创建应用证书之前需要创建应用证书的扩展描述文件，如果不使用扩展描述文件，那么浏览器中无法授信，会提示证书无效

vim ./cert/nginx.ext
# 填入一下内容
##########################
[ req ]
default_bits        = 2048
distinguished_name  = req_distinguished_name
req_extensions      = san
extensions          = san
[ req_distinguished_name ]
countryName         = CN
stateOrProvinceName = China
localityName        = China
organizationName    = Private
[SAN]
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[ alt_names ]
IP.1 = 192.168.111.3
IP.2 = 192.168.168.3
IP.3 = 10.3.7.3
DNS.1 = feiyu.private
##########################

# 最后，使用csr，ext、以及根证书CA.crt创建应用证书
openssl x509 -req -days 3650 -in ./cert/nginx.csr -CA ./cert/CA.crt -CAkey ./cert/CA.key -CAcreateserial -sha256 -out ./cert/nginx.crt -extfile ./cert/nginx.ext -extensions SAN

```

# 浏览器添加信任

客户端访问 https 的时候，如果想浏览器不带警告，需要将根 证书即:ca.crt 安装到本地的受信任目录中。

1. 双击 ca.crt 文件
2. 点击安装证书
3. 选择本地计算机，点击下一步
4. 选择将所有证书都放入下列存储，点击浏览
5. 选择受信任的根证书颁发机构，点击确定
6. 点击完成
