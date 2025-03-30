---
title: DES算法实现
date: 2024-03-13 14:22:14
updated: 2024-11-15 21:39:39
categories:
  - 编程语言
  - CCPlusPlus
  - 加密算法实现
tags:
  - C语言
  - 加密
permalink: /posts/DES算法实现/
---
```c
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

/*========================初始置换表IP=========================*/
int IP_Table[64] = {
    57, 49, 41, 33, 25, 17, 9, 1,
    59, 51, 43, 35, 27, 19, 11, 3,
    61, 53, 45, 37, 29, 21, 13, 5,
    63, 55, 47, 39, 31, 23, 15, 7,
    56, 48, 40, 32, 24, 16, 8, 0,
    58, 50, 42, 34, 26, 18, 10, 2,
    60, 52, 44, 36, 28, 20, 12, 4,
    62, 54, 46, 38, 30, 22, 14, 6};

/*========================逆初始置换表IP^-1====================*/
int IP_1_Table[64] = {
    39, 7, 47, 15, 55, 23, 63, 31,
    38, 6, 46, 14, 54, 22, 62, 30,
    37, 5, 45, 13, 53, 21, 61, 29,
    36, 4, 44, 12, 52, 20, 60, 28,
    35, 3, 43, 11, 51, 19, 59, 27,
    34, 2, 42, 10, 50, 18, 58, 26,
    33, 1, 41, 9, 49, 17, 57, 25,
    32, 0, 40, 8, 48, 16, 56, 24};

/*========================扩展变换表E盒========================*/
int E_Table[48] = {
    31, 0, 1, 2, 3, 4,
    3, 4, 5, 6, 7, 8,
    7, 8, 9, 10, 11, 12,
    11, 12, 13, 14, 15, 16,
    15, 16, 17, 18, 19, 20,
    19, 20, 21, 22, 23, 24,
    23, 24, 25, 26, 27, 28,
    27, 28, 29, 30, 31, 0};

/*===========================S盒==============================*/
int S_Box[8][4][16] =
    {
        // S1
        {
            {14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7},
            {0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8},
            {4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0},
            {15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13}},
        // S2
        {
            {15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10},
            {3, 13, 4, 7, 15, 2, 8, 14, 12, 0, 1, 10, 6, 9, 11, 5},
            {0, 14, 7, 11, 10, 4, 13, 1, 5, 8, 12, 6, 9, 3, 2, 15},
            {13, 8, 10, 1, 3, 15, 4, 2, 11, 6, 7, 12, 0, 5, 14, 9}},
        // S3
        {
            {10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8},
            {13, 7, 0, 9, 3, 4, 6, 10, 2, 8, 5, 14, 12, 11, 15, 1},
            {13, 6, 4, 9, 8, 15, 3, 0, 11, 1, 2, 12, 5, 10, 14, 7},
            {1, 10, 13, 0, 6, 9, 8, 7, 4, 15, 14, 3, 11, 5, 2, 12}},
        // S4
        {
            {7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15},
            {13, 8, 11, 5, 6, 15, 0, 3, 4, 7, 2, 12, 1, 10, 14, 9},
            {10, 6, 9, 0, 12, 11, 7, 13, 15, 1, 3, 14, 5, 2, 8, 4},
            {3, 15, 0, 6, 10, 1, 13, 8, 9, 4, 5, 11, 12, 7, 2, 14}},
        // S5
        {
            {2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9},
            {14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6},
            {4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14},
            {11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3}},
        // S6
        {
            {12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11},
            {10, 15, 4, 2, 7, 12, 9, 5, 6, 1, 13, 14, 0, 11, 3, 8},
            {9, 14, 15, 5, 2, 8, 12, 3, 7, 0, 4, 10, 1, 13, 11, 6},
            {4, 3, 2, 12, 9, 5, 15, 10, 11, 14, 1, 7, 6, 0, 8, 13}},
        // S7
        {
            {4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1},
            {13, 0, 11, 7, 4, 9, 1, 10, 14, 3, 5, 12, 2, 15, 8, 6},
            {1, 4, 11, 13, 12, 3, 7, 14, 10, 15, 6, 8, 0, 5, 9, 2},
            {6, 11, 13, 8, 1, 4, 10, 7, 9, 5, 0, 15, 14, 2, 3, 12}},
        // S8
        {
            {13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7},
            {1, 15, 13, 8, 10, 3, 7, 4, 12, 5, 6, 11, 0, 14, 9, 2},
            {7, 11, 4, 1, 9, 12, 14, 2, 0, 6, 10, 13, 15, 3, 5, 8},
            {2, 1, 14, 7, 4, 10, 8, 13, 15, 12, 9, 0, 3, 5, 6, 11}}};

/*========================置换函数P盒==========================*/
int P_Box[32] = {
    15, 6, 19, 20, 28, 11, 27, 16,
    0, 14, 22, 25, 4, 17, 30, 9,
    1, 7, 23, 13, 31, 26, 2, 8,
    18, 12, 29, 5, 21, 10, 3, 24};

/*========================置换选择器1==========================*/
int PC_1_table[56] = {56, 48, 40, 32, 24, 16, 8,
                0, 57, 49, 41, 33, 25, 17,
                9, 1, 58, 50, 42, 34, 26,
                18, 10, 2, 59, 51, 43, 35,
                62, 54, 46, 38, 30, 22, 14,
                6, 61, 53, 45, 37, 29, 21,
                13, 5, 60, 52, 44, 36, 28,
                20, 12, 4, 27, 19, 11, 3};

/*========================置换选择器2==========================*/
int PC_2_table[48] = {13, 16, 10, 23, 0, 4, 2, 27,
                14, 5, 20, 9, 22, 18, 11, 3,
                25, 7, 15, 6, 26, 19, 12, 1,
                40, 51, 30, 36, 46, 54, 29, 39,
                50, 44, 32, 46, 43, 48, 38, 55,
                33, 52, 45, 41, 49, 35, 28, 31};

/*========================对左移次数的规定====================*/
int MOVE_table[16] = {1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1};


void CharToBit(char *input,int *output,int bits);//将字符数组转换成二进制数组

void BitToChar(int *input, char *output, int bits);//将二进制数组转换成字符数组

void Xor(int InA[],int InB[],int len);//异或操作

void IP_IPR(int input[64],int output[64],int table[64]);//IP初始置换和逆置换函数,由table决定是逆置换还是初始置换

void E(int input[32],int output[48],int table[48]);//E盒扩展

void P(int input[32],int output[32],int table[32]);//P盒替代

void PC_1(int input[64],int output[56],int table[56]);//PC-1置换选择器

void PC_2(int input[56],int output[48],int table[48]);//PC-2置换选择器

void S(int input[48],int output[32],int table[8][4][16]);//S盒压缩

void F_func(int input[32],int subkey[48]);//F轮函数

void BitsCopy(int *DatOut,int *DatIn,int Len);//把DatIn开始的长度位Len位的二进制复制到DatOut后

void RotateL(int input[28],int output[28], int move);//子秘钥中循环左移函数

void  subKey_fun(int input[64],int Subkey[16][48]);//子秘钥生成

void BitToHex(char *DatOut,int *DatIn,int Num);//二进制密文转换为十六进制需要16个字符表示

void  DES_Dfun(int input[],char key_in[],char output[]);//DES加密

void ShowArray(int *array,int num);//输出字符数组

int main(){
    int i = 0;
    char key[9] = {0};
    char message[9] = {0};
    int keybin[64] = {0}, mesbin[64] = {0};
    char cipher[9];

    printf("输入8字节的明文：");
    //fgets(message, sizeof(message), stdin);
    scanf("%s", message);
    printf("输入8字节的秘钥：");
    //fgets(key, sizeof(key), stdin);
    scanf("%s", key);

    while(strlen(key) != 8)
    {
        printf("请输入正确的密钥：");
        //fgets(key, sizeof(key), stdin);
        scanf("%s", key);
        i = 0;
        while(key[i] != '\0')
        {
            i++;
        }
    }

    CharToBit(message, mesbin, 64);
    DES_Dfun(mesbin, key, cipher);

    printf("\n------------加密后数据------------\n");
    for(i = 0; i < 16; i++)
    {
        printf("%c", cipher[i]);
    }
    printf("\n");
    //system("pause");

    return 0;
}

void CharToBit(char *input,int *output,int bits)
{
    for(int i = 0; i < bits; i++)
    {
        output[i] = (input[i / 8] >> (i % 8)) & 1;
    }
}

void BitToChar(int *input, char *output, int bits)
{
    for(int i = 0; i < (bits / 8); i++)
    {
        output[i] = 0;
    }
    for(int i = 0; i < bits; i++)
    {
        output[i / 8] = input[i] << (i % 8) | output[i / 8];
    }
}

void  Xor(int DataA[],int DataB[],int len)
{
    for(int i = 0; i < len; i++)
    {
        DataA[i] ^= DataB[i];
    }
}

void IP_IPR(int input[64],int output[64],int table[64])
{
    for(int i = 0; i < 64; i++)
    {
        output[i] = input[table[i]];
    }
}

void E(int input[32],int output[48],int table[48])
{
    for(int i = 0; i < 48; i++)
    {
        output[i] = input[table[i]];
    }
}

void S(int input[48],int output[32],int table[8][4][16])
{
    for(int i = 0, X = 0, Y = 0; i < 0; i++, input+=6, output+=4)
    {
        Y = (input[0] << 1) + input[5];
        X = (input[1] << 3) + (input[2] << 2) + (input[3] << 1) + input[4];
        char temp = (char)table[i][4][16];
        CharToBit(&temp, output, 4);
    }
}

void P(int input[32],int output[32],int table[32])
{
    for(int i = 0; i < 32; i++)
    {
        output[i] = input[table[i]];
    }
}

void PC_1(int input[64],int output[56],int table[56])
{
    for(int i = 0; i < 56; i++)
    {
        output[i] = input[table[i]];
    }
}

void PC_2(int input[56],int output[48],int table[48])
{
    for(int i = 0; i < 48; i++)
    {
        output[i] = input[table[i]];
    }
}

void F_func(int input[32],int subkey[48])
{
    int mir[48] = {0};
    int temp[32];

    printf("E盒拓展：");
    E(input, mir,E_Table);
    ShowArray(mir, 48);
    
    printf("S盒代换：");
    S(mir, input, S_Box);
    ShowArray(input, 32);

    BitsCopy(temp, input, 32);

    printf("P盒置换：");
    P(temp, input, P_Box);
    ShowArray(input,32);
}

void BitsCopy(int *dataout,int *datain,int len)
{
    for(int i = 0; i < len; i++)
    {
        dataout[i] = datain[i];
    }
}

void RotateL(int input[28],int output[28], int move)
{
    BitsCopy(output, input + move, 28 - move);
    BitsCopy(output + 28 - move, input, move);
}

void  subKey_fun(int input[64],int Subkey[16][48])
{
    int i = 0, temp[56];
    int *keyL = &temp[0], *keyR = &temp[28];
    printf("\n----------子密钥生成----------\n");

    printf("\nPC-1置换：");
    PC_1(input, temp, PC_1_table);
    ShowArray(temp, 56);

    for(i = 0; i < 16; i++)
    {
        printf("\n-----第%d个子秘钥-----\n",i+1);

        printf("循环左移左半部分:");
        RotateL(keyL, keyL, MOVE_table[i]);
        ShowArray(keyL, 28);

        printf("循环左移右半部分:");
        RotateL(keyR, keyR, MOVE_table[i]);
        ShowArray(keyR, 28);

        printf("PC-2置换：");
        PC_2(temp, Subkey[i], PC_2_table);
        ShowArray(Subkey[i], 48);
    }
}

void BitToHex(char *dataout,int *datain,int num)
{
    int i = 0;
    for(i = 0; i < num / 4; i++)
    {
        dataout[i] = 0;
    }
    for(i = 0; i < num / 4; i++)
    {
        dataout[i] = datain[i * 4] + (datain[i * 4 + 1] << 1) + (datain[i * 4 + 2] << 2) + (datain[i * 4 + 3] << 3);
        if ((dataout[i] % 16) > 9)
        {
            dataout[i] = dataout[i] % 16 + '7';     // 余数大于9时处理 10-15 to A-F
        }else{
            dataout[i] = dataout[i] % 16 + '0';
        }
    }
}

void ShowArray(int * array, int num)
{
    int i;
    for(i = 0; i < num; i++)
    {
        printf("%d", array[i]);
    }
    printf("\n");
}

void  DES_Dfun(int input[],char key_in[],char output[])
{
    int ml[32] = {0}, mr[32] = {0};
    int temp1[64], temp2[32], temp3[64];
    int subkey[16][48];
    int input_l[32] = {0}, input_r[32] = {0};
    int testi = 0;

    for(testi = 0; testi < 32; testi++)
    {
        input_r[testi] = input[32 + testi];
    }
    for(testi = 0; testi < 32; testi++)
    {
        input_r[testi] = input[32 + testi];
    }

    BitsCopy(ml, input_l, 32);
    BitsCopy(mr, input_r, 32);
    BitsCopy(temp1, input, 64);

    printf("IP初始置换：\n");
    IP_IPR(temp1, input, IP_Table);
    ShowArray(input,64);

    CharToBit(key_in, temp3, 64);
    subKey_fun(temp3, subkey);
    for(int i = 0; i < 16; i++)
    {
        printf("\n***第%d轮迭代:***\n",i+1);
        BitsCopy(temp2, mr, 32);
        F_func(mr, subkey[i]);
        Xor(mr, ml, 32);
        BitsCopy(ml, temp2, 32);

        printf("ML: ");
        ShowArray(ml,32);
        printf("MR: ");
        ShowArray(ml,32);
    }

    IP_IPR(input, temp1, IP_Table);
    BitToHex(output, input, 64);
}
```

