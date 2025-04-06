---
title: RC4算法实现
date: 2024-03-13 14:22:17
updated: 2024-11-15 21:39:44
categories:
  - 编程语言
  - CCPlusPlus
  - 加密算法实现
tags:
  - C语言
  - 加密
permalink: /posts/RC4算法实现/
---
```c
#include<stdio.h>
void rc4_init(unsigned char* s, unsigned char* key, unsigned long Len_k) //鍒濆鍖栧嚱鏁�
{
    int i = 0, j = 0;
    char k[256] = { 0 };
    unsigned char tmp = 0;
    for (i = 0; i < 256; i++) {
        s[i] = i;
        k[i] = key[i % Len_k];
    }
    for (i = 0; i < 256; i++) {
        j = (j + s[i] + k[i]) % 256;
        tmp = s[i];
        s[i] = s[j];
        s[j] = tmp;
    }
}
void rc4_crypt(unsigned char* Data, unsigned long Len_D, unsigned char* key, unsigned long Len_k) //鍔犺В瀵�
{
    unsigned char s[256];
    rc4_init(s, key, Len_k);
    int i = 0, j = 0, t = 0;
    unsigned long k = 0;
    unsigned char tmp;
    for (k = 0; k < Len_D; k++) {
        i = (i + 1) % 256;
        j = (j + s[i]) % 256;
        tmp = s[i];
        s[i] = s[j];
        s[j] = tmp;
        t = (s[i] + s[j]) % 256;
        Data[k] = Data[k] ^ s[t];
    }
}
int main()
{
    unsigned char key[] = "[Warnning]Access_Unauthorized";
    unsigned long key_len = sizeof(key) - 1;
    unsigned char data[22] = { 0xC3,0x82,0xA3,0x25,0xF6,0x4C,
    0x36,0x3B,0x59,0xCC,0xC4,0xE9,0xF1,0xB5,0x32,0x18,0xB1,
    0x96,0xAe,0xBF,0x08,0x35};
    rc4_crypt(data, sizeof(data), key, key_len);
    for (int i = 0; i < sizeof(data); i++)
    {
        printf("%c", data[i]);
    }
    printf("\n");
}
 


```

