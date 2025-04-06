---
title: RSA算法实现
date: 2024-03-13 14:22:21
updated: 2024-11-15 21:39:48
categories:
  - 编程语言
  - CCPlusPlus
  - 加密算法实现
tags:
  - C语言
  - 加密
permalink: /posts/RSA算法实现/
---
```c
#include<stdio.h>

int fun(int x, int y){
    int t;
    // while(y){
    //     t = x; 
    //     x = y;
    //     y = t % y;
    // }
    for (t = x; y != 0; y = t % y){
        x = y;
    }
    if (x = 1){return 0;}
    else {return 1;}
}

int canpd(int m, int b, int n){
    int r = 1;
    for (b = b + 1; b != 1; b--){
        r = r * m;
        r = r % n;
    }
    //printf("r = %d\n", r);
    return r;
}

int main(){
    int p, q, e, d, m, n, r, c, t;
    printf("请输入两个素数p、q：");
    scanf("%d %d", &p, &q);
    n = p * q;
    printf("n = %d\n", n);
    t = (p - 1) * (q - 1);
    printf("t = %d\n", t);
    printf("请输入公钥e：");
    scanf("%d", &e);
    if (e < 1 || e > t || fun(e, t)){
        printf("公钥输入有误，请重新输入e = ");
        scanf("%d", e);
    }
    d = 1;
    while(((e * d) % t) != 1){d++;}
    printf("私钥d = %d\n", d);
    printf("1.加密\n");
    printf("2.解密\n");
    printf("3.退出\n");
    while(1){
        printf("请输入你要执行的操作：");
        scanf("%d", &r);

        switch(r){
            case 1:
                printf("请输入明文：");
                scanf("%d", &m);
                c = canpd(m, e, n);
                printf("加密后的数据c = %d\n", c);
                break;
            case 2:
                printf("请输入密文：");
                scanf("%d", &c);
                m = canpd(c, d, n);
                printf("解密后的数据m = %d\n", m);
                break;
            case 3:return 0;
            default:
                printf("输入的操作数有误，请重新输入!!!\n");
                break;
        }
    }
    return 0;
}
```

