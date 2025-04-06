---
title: Caesar算法实现
date: 2024-03-13 14:22:11
updated: 2024-11-15 21:39:31
categories:
  - 编程语言
  - CCPlusPlus
  - 加密算法实现
tags:
  - C语言
  - 加密
permalink: /posts/Caesar算法实现/
---
```c
#include<stdio.h>
#include<string.h>
#define MAX 255

void encode(char str[], int n){
    int i, j, k;
    char min[26]={'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
    char max[26]={'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};

    for (i = 0; i <= strlen(str); i++){
        if (str[i] >= 'a' && str[i] <= 'z'){
            j = str[i] - 'a';
            k = (26 +j + n) % 26;       
            str[i] = min[k];
        }else if (str[i] >= 'A' && str[i] <= 'Z'){
            j = str[i] - 'A';
            k = (26 + j + n) % 26;
            str[i] = min[k];
        }
    }
}

void decode(char str[], int n){
    int i, j, k;
    char min[26]={'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
    char max[26]={'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};

    for (i = 0; i <= strlen(str); i++){
        if (str[i] >= 'a' && str[i] <= 'z'){
            j = str[i] - 'a';
            k = (26 + j - n) % 26;
            str[i] = min[k];
        }else if (str[i] >= 'A' && str[i] <= 'Z'){
            j = str[i] - 'A';
            k = (26 + j - n) % 26;
            str[i] = min[k];
        }
    }
}

int main(){
    char a[MAX], b[MAX];
    int n;
    // printf("请输入需要移位的长度：");
    // scanf("%d", &n);
    printf("请输入需要加密的数据：");
    scanf("%s", a);

    // encode(a, n);
    // printf("凯撒加密后：");
    // puts(a);
    // decode(a, n);
    // printf("凯撒解密后：");
    // puts(a);
    for(int i = 0; i <= 24; i++){
        encode(a, i);
        printf("偏移量为%d：", i);
        //printf("凯撒加密后：");
        puts(a);
    }
    
    return 0;
}

```

