---
title: NPM镜像加速
date: 2024-11-10 14:34:28
updated: 2024-11-23 23:19:06
categories:
  - 系统运维
  - Linux
tags:
  - Linux
  - Arch
  - nodejs
permalink: /posts/NPM镜像加速/
---
# 国内npm源镜像（npm加速下载）

### 指定npm镜像

> npm 官方原始镜像网址是：https://registry.npmjs.org/
>
> 淘宝 NPM 镜像：http://registry.npmmirror.com
>
> 阿里云 NPM 镜像：https://npm.aliyun.com
>
> 腾讯云 NPM 镜像：https://mirrors.cloud.tencent.com/npm/
>
> 华为云 NPM 镜像：https://mirrors.huaweicloud.com/repository/npm/
>
> 网易 NPM 镜像：https://mirrors.163.com/npm/
>
> 中国科学技术大学开源镜像站：http://mirrors.ustc.edu.cn/
>
> 清华大学开源镜像站：https://mirrors.tuna.tsinghua.edu.cn/
>
> 腾讯，华为，阿里的镜像站基本上比较全

### **淘宝**镜像源加速 NPM

最新的：

```typescript
 npm config set registry https://registry.npmmirror.com
```

### **阿里云**镜像源加速 NPM

```typescript
npm config set registry https://npm.aliyun.com
```

### **腾讯云**镜像源加速 NPM

```typescript
npm config set registry http://mirrors.cloud.tencent.com/npm/
```

### **华为云**镜像源加速 NPM

```typescript
npm config set registry https://mirrors.huaweicloud.com/repository/npm/
```

### 返回**npm官方原始镜像**

```typescript
npm config set registry https://registry.npmjs.org/
```

### **查看当前的镜像源**

```typescript
npm config get registry
```
