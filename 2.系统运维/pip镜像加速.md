---
title: pip镜像加速
date: 2025-01-03 17:23:17
updated: 2025-04-10 14:55:14
tags: 
permalink: /posts/pip镜像加速/
---
# 清华源

```bash
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
```

# 阿里源

```bash
pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
```

# 腾讯源

```bash
pip config set global.index-url http://mirrors.cloud.tencent.com/pypi/simple
```

# 豆瓣源

```bash
pip config set global.index-url http://pypi.douban.com/simple/  
```

# 换回默认源  

```bash
pip config unset global.index-url
```
