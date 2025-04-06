---
title: Base64逆表生成
date: 2024-03-13 14:22:01
updated: 2024-11-17 17:39:50
categories:
  - 编程语言
  - CCPlusPlus
  - 加密算法实现
tags:
  - 加密
  - C语言
permalink: /posts/Base64逆表生成/
---
```c++
#include<iostream>
#include<cstring>
using namespace std;

int main(){
    unsigned char encode_table[65] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    unsigned char decode_table[256], c;

    for (int i = 0; i < 256; i++){ decode_table[i] = 255; }
    for (int i = 0; i < 64; i++)
    {
        c = encode_table[i];
        decode_table[c] = i;
    }
    cout << "Encode_Table = {" << encode_table << "}\n";
    cout << "Decode_Table = {" << int(decode_table[0]);
    for (int i = 1; i < 256; i++) { cout << ", " << int(decode_table[i]); }
    cout << "}" << endl;

}
```
