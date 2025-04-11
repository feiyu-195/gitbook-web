---
title: CTF离谱密码总结
date: 2024-04-28 14:32:27
updated: 2025-04-10 16:32:05
categories:
  - 网络安全
  - 理论知识
tags:
  - CTF
  - 加密
permalink: /posts/CTF离谱密码总结/
---
# 零、工具箱总结

[在线工具 - Bugku CTF](https://ctf.bugku.com/tools)

# 一、凯撒密码

在线加解密：[凯撒(Caesar)加密/解密 - Bugku CTF](https://ctf.bugku.com/tool/caesar)

在密码学中，[凯撒密码](https://baike.baidu.com/item/%E5%87%AF%E6%92%92%E5%AF%86%E7%A0%81/0?fromModule=lemma_inlink)（英语：Caesar cipher），或称恺撒加密、恺撒变换、变换加密，是一种最简单且最广为人知的加密技术。它是一种替换加密的技术，明文中的所有字母都在字母表上向后（或向前）按照一个固定数目进行偏移后被替换成密文。

> 下面是明文字母表移回3位的对比：  
> 明文字母表 X Y Z A B C D E F G H I J K L M N O P Q R S T U V W  
> 密文字母表 A B C D E F G H I J K L M N O P Q R S T U V W X Y Z

## 特定恺撒密码

根据偏移量的不同，还存在若干特定的恺撒密码名称：

- 偏移量为10：Avocat(A→K)
- 偏移量为13：ROT13
- 偏移量为-5：Cassis (K 6)
- 偏移量为-6：Cassette (K 7)

## C语言实现

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
	printf("请输入需要加密的数据：");
	scanf("%s", a);

	for(int i = 0; i <= 24; i++){
		encode(a, i);
		printf("偏移量为%d：", i);
		puts(a);
	}
	
	return 0;
}

```

# 二、维吉尼亚密码

在线加解密：[维吉尼亚加密/解密 - Bugku CTF](https://ctf.bugku.com/tool/vigenere)

[维吉尼亚密码](https://blog.csdn.net/weixin_47585015/article/details/112999152)（又译维热纳尔密码）是使用一系列[凯撒密码](https://baike.baidu.com/item/%E5%87%AF%E6%92%92%E5%AF%86%E7%A0%81/0?fromModule=lemma_inlink "百度百科")组成密码字母表的加密算法，属于多表密码的一种简单形式。

# 三、字母频率

在线加解密：[字母频率在线分析](https://www.quipqiup.com/)

[频率分析法](https://blog.csdn.net/Leon_Jinhai_Sun/article/details/108691183)指的是各个字母在文本材料中出现的频率。常被应用于密码学，尤其是可破解古典密码的频率分析。

# 四、培根密码

在线加解密：[培根密码在线加密/解密](http://www.hiencode.com/baconian.html)

[培根密码](https://baike.baidu.com/item/%E5%9F%B9%E6%A0%B9%E5%AF%86%E7%A2%BC/2134182)，又名倍康尼密码（英语：Bacon's cipher）是由法兰西斯·培根发明的一种隐写术。实际上就是一种替换密码，根据所给表一一对应转换即可加密解密 。它的特殊之处在于：可以通过不明显的特征来隐藏密码信息，比如大小写、正斜体等，只要两个不同的属性，密码即可隐藏。

# 五、栅栏密码

在线加解密：[栅栏加密/解密 - Bugku CTF](https://ctf.bugku.com/tool/railfence)

[栅栏密码](https://baike.baidu.com/item/%E6%A0%85%E6%A0%8F%E5%AF%86%E7%A0%81/228209)，就是把要加密的明文分成N个一组，然后把每组的第1个字连起来，形成一段无规律的话。 不过栅栏密码本身有一个潜规则，就是组成栅栏的字母一般不会太多。（一般不超过30个，也就是一、两句话），分为**传统型**与**W型**

明文举例：`f5-lf5aa9gc9{-8648cbfb4f979c-c2a851d6e5-c}`

*标准型栅栏数为3*加密后：`flag{6cb9c256-5fac-4b47-a1ec-59988ff9c8d5}`

# 六、QP(quoted-printable)编码

在线加解密：[Quoted-printable在线编码](http://www.hiencode.com/quoted.html)

[Quoted-printable 编码](https://blog.csdn.net/qq_22146195/article/details/107500750)可译为“可打印字符引用编码”、“使用可打印字符的编码”，我们收邮件，查看信件原始信息，经常会看到这种类型的编码！

# 七、ROT编码

在线加解密：[凯撒(Caesar)加密/解密 - Bugku CTF](https://ctf.bugku.com/tool/caesar)

`ROT5、ROT13、ROT18、ROT47` 编码是一种简单的码元位置顺序替换暗码。此类编码具有可逆性，可以自我解密，主要用于应对快速浏览，或者是机器的读取，而不让其理解其意。

> 实际就是凯撒密码不同的偏移量

下面分别说说它们的编码方式：

- **ROT5**是 rotate by 5 places 的简写，意思是旋转5个位置，其它皆同。ROT5：只对数字进行编码，用当前数字往前数的第5个数字替换当前数字，例如当前为0，编码后变成5，当前为1，编码后变成6，以此类推顺序循环。
- **ROT13**：只对字母进行编码，用当前字母往前数的第13个字母替换当前字母，例如当前为A，编码后变成N，当前为B，编码后变成O，以此类推顺序循环。
- **ROT18**：这是一个异类，本来没有，它是将ROT5和ROT13组合在一起，为了好称呼，将其命名为ROT18。
- **ROT47**：对数字、字母、常用符号进行编码，按照它们的ASCII值进行位置替换，用当前字符ASCII值往前数的第47位对应字符替换当前字符，例如当前为小写字母z，编码后变成大写字母K，当前为数字0，编码后变成符号_。用于ROT47编码的字符其ASCII值范围是33－126，具体可参考ASCII编码。

# 八、URL编码

在线编码：[Url 编码/解码 - 在线工具 (toolhelper.cn)](https://www.toolhelper.cn/EncodeDecode/UrlEncodeDecode)

[HTML URL 编码参考手册 (w3school.com.cn)](https://www.w3school.com.cn/tags/html_ref_urlencode.asp)

密文特点：`%66%6C%61%67%7B%61%6E%64%20%31%3D%31%7D`

# 九、BrainFuck编码/Ook!密码

在线加解密：[Brainfuck/OoK加密解密 - Bugku CTF](https://ctf.bugku.com/tool/brainfuck)

## BrainFuck编码

[Brainfuck](https://baike.baidu.com/item/Brainfuck/1152785#1)是一种极小化的计算机语言，它是由Urban Müller在1993年创建的，是一种简单的、可以用最小的[编译器](https://baike.baidu.com/item/%E7%BC%96%E8%AF%91%E5%99%A8/0?fromModule=lemma_inlink)来实现的、符合[图灵完全](https://baike.baidu.com/item/%E5%9B%BE%E7%81%B5%E5%AE%8C%E5%85%A8/0?fromModule=lemma_inlink)思想的编程语言。这种语言由八种状态构成。

下面是这八种状态的描述，其中每个状态由一个字符标识：

| 字符  | 含义                              |
| --- | ------------------------------- |
| >   | 指针加一                            |
| <   | 指针减一                            |
| +   | 指针指向的字节的值加一                     |
| -   | 指针指向的字节的值减一                     |
| .   | 输出指针指向的单元内容（ASCⅡ码）              |
| ,   | 输入内容到指针指向的单元（ASCⅡ码）             |
| [   | 如果指针指向的单元值为零，向后跳转到对应的]指令的次一指令处  |
| ]   | 如果指针指向的单元值不为零，向前跳转到对应的[指令的次一指令处 |

密文特点：`+++++ +++++ [->++ +++++ +++<] >++.+ +++++ .<+++ [->-- -<]>- -.+++ +++.<++++[ ->+++ +<]>+ +++.< +++++ +++[- >---- ----< ]>--- --.+. ----- -.<+++++++ [->++ +++++ <]>++ ++.-- --.<+ +++++ [->-- ----< ]>--- ----- .------.++ +++++ +.<++ +[->- --<]> --.++ +++.+ +++.- .<+++ +++[- >++++ ++<]>+++++ +++.< +++++ ++[-> ----- --<]> ---.+ +++++ +.+++ ++.-- ----- .<+++++++[ ->+++ ++++< ]>+++ .<+++ ++++[ ->--- ----< ]>--- ----- .<+++ ++++[->+++ ++++< ]>+++ .<+++ ++++[ ->--- ----< ]>.++ ++.-- -.--- -.<++ +++++[->++ +++++ <]>++ ++.<+ +++++ [->-- ----< ]>--- ----- ---.- --.<+ ++++++[->+ +++++ +<]>+ ..<++ ++++[ ->--- ---<] >---- --.-- -.+.+ ++.-- ---.+++++. ----- ----. <++++ ++++[ ->+++ +++++ <]>++ +++++ +++++ +.<`

解密后：`flag{671fb608-265a-492f-a041-b30bb8569490}`

## Ook!密码

特征：所有明文转换成**Ook.?!**

# 十、摩斯密码

[摩尔斯电码](https://baike.baidu.com/item/%E6%91%A9%E5%B0%94%E6%96%AF%E7%94%B5%E7%A0%81/1527853)：`.`和`-`和`间隔符`或`.`和`-`和`间隔符`

密文举例：`..-. .-.. .- --. . --... .---- -.-. .- ..... -.-. -.. -....- --... -.. -... ----. -....- ....- -... .- ...-- -....- ----. ...-- ---.. ...-- -....- .---- .- ..-. ---.. -.... --... ---.. ---.. .---- ..-. ----- --...`

解密后：`FLAGE71CA5CD-7DB9-4BA3-9383-1AF867881F07`

# 十一、XXencode/UUencode编码

在线编码：

- [XXencode加密/解密 - Bugku CTF](https://ctf.bugku.com/tool/xxencode)
- [UUencode加密/解密 - Bugku CTF](https://ctf.bugku.com/tool/uuencode)

**UUencode**的加密方式和base64很相似。但他的编码表有很多是特殊字符: `!”#￥%&‘（）*+=’` 等等。
**XXencode**的加密方式也和base64相似。跟base64打印字符相比，就是比UUencode多一个 `-` 字符，少一个`/` 字符。

特征举例：

- UUencode（1234567）= (,3(S-#4V-PH\`
	特征：看着特别奇怪  
- XXencode（1234567）= `6AH6nB1IqBkc+`
	特征：与base64相似

XXencode密文举例：`LNalVNrhIO4ZnLqZnLpVsAqtXA4FZTEc+`

解密后：`flag{This_is_Xx3nc0de}`

# 十二、社会主义核心价值观编码

在线编码：[核心价值观编码 - Bugku CTF](https://ctf.bugku.com/tool/cvecode)

没啥好说的，举例：

明文：`flag{}`

加密后：`公正公正公正诚信文明公正民主公正法治法治诚信民主法治友善法治`

# 十三、希尔密码

在线编码：[希尔(Hill Cipher)加密/解密 - Bugku CTF](https://ctf.bugku.com/tool/hill)

# 十四、Base家族编码

常见base

1. base16：
2. base32：
3. base58：
4. base64：
