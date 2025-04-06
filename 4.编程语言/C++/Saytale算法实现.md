---
title: Saytale算法实现
date: 2024-03-13 14:22:24
updated: 2024-11-15 21:49:39
categories:
  - 编程语言
  - CCPlusPlus
  - 加密算法实现
tags:
  - C语言
  - 加密
permalink: /posts/Saytale算法实现/
---
```c
#include <string.h>
#include <stdio.h>

void *encode(char p[], char cipher[], int key[]){
    int j;
    for (int i = 0; i < strlen(p); i++){
        j = key[i] - 1;
        cipher[i] = p[j];
        printf("%c", cipher[i]); 
    }
    printf("\n");
}

void *decode(char p[], char cipher[], int key[]){
    int j;
    for (int i = 0; i < 7; i++){
        j = key[i] - 1;
        p[j] = cipher[i];
        
    }
    printf("%s", p);
}

int main(){
    char p[7], c[7];
    int k[7] = {6, 3, 2, 5, 1, 7, 4};
    
    printf("需要加密的字符：");
    scanf("%s", p);
    
    printf("Scytale加密后：");
    encode(p, c, k);
    
    printf("Scytale解密后：");
    decode(p, c, k);
    
    return 0;
} 

```

