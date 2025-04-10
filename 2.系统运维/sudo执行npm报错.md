---
title: sudo执行npm报错
date: 2024-08-27 14:30:05
updated: 2025-04-09 23:38:59
categories:
  - 其他
tags:
  - nodejs
  - nvm
permalink: /posts/解决nvm安装的node使用sudo npm报错的问题/
---
# 解决nvm安装的node使用`sudo npm`报错

通过软链将npm添加到usr/local/bin下面：

```shell
sudo ln -s "$NVM_DIR/versions/node/$(nvm version)/bin/node" "/usr/local/bin/node"
sudo ln -s "$NVM_DIR/versions/node/$(nvm version)/bin/npm" "/usr/local/bin/npm"
```
