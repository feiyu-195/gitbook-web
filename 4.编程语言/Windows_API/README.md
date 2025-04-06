---
title: README
date: 2024-03-14 14:24:27
updated: 2024-11-15 21:49:39
categories:
  - 编程语言
  - Windows_API
tags:
  - Windows
  - api
permalink: /posts/README/
---
# 目录

[1、Windows\_API函数分类](./1、Windows_API函数分类.md)
[2、文件处理函数](./2、文件处理函数.md)
[3、网络函数](3、网络函数.md)
[4、消息函数](4、消息函数.md)
[5、打印函数](5、打印函数.md)
[6、文本和字体函数](6、文本和字体函数.md)
[7、菜单函数](7、菜单函数.md)
[8、位图、图标和光栅运算函数](8、位图、图标和光栅运算函数.md)
[9、绘图函数](9、绘图函数.md)
[10、设备场景函数](10、设备场景函数.md)
[11、硬件与系统函数](11、硬件与系统函数.md)
[12、 进程和线程函数](12、 进程和线程函数)
[13、控件与消息函数](13、控件与消息函数.md)



Windows API包括几千个可调用的函数，它们大致可以分为以下几个大类：基本服务、组件服务、用户界面服务、图形多媒体服务、消息和协作、网络、Web服务。

Windows API所提供的七类功能详细介绍：

1. **基础服务（Base Services）**： 提供对Windows系统可用的基础资源的访问接口。比如象：文件系统（file system）、外部设备（device）、，进程（process）、线程（thread）以及访问注册表（Windows registry）和错误处理机制（error handling）。这些功能接口位于，16位Windows下的kernel.exe、krnl286.exe或krnl386.exe系统文档中；以及32位Windows下的 kernel32.dll和advapi32.dll中。

2. **图形设备接口（GDI）**： 提供功能为：输出图形内容到显示器、打印机以及其他外部输出设备。它位于16位Windows下的gdi.exe；以及32位Windows下的gdi32.dll。

3. **图形化用户界面（GUI）**： 提供的功能有创建和管理屏幕和大多数基本控件（control），比如按钮和滚动条。接收鼠标和键盘输入，以及其他与GUI有关的功能。这些调用接口位于：16位Windows下的user.exe，以及32位Windows下的user32.dll。从Windows XP版本之后，基本控件和通用对话框控件（Common Control Library）的调用接口放在comctl32.dll中。

4. **通用对话框链接库（Common Dialog Box Library）**： 为应用程序提供标准对话框，比如打开/保存文档对话框、颜色对话框和字体对话框等等。这个链接库位于：16位Windows下的commdlg.dll中，以及32位Windows下comdlg32.dll中。它被归类为User Interface API之下。

5. **通用控件链接库（Common Control Library）**：为应用程序提供接口来访问操作系统提供的一些高级控件。比如像：状态栏（status bar）、进度条（progress bars）、工具栏（toolbar）和标签（tab）。这个链接库位于：16位Windows下的commctrl.dll中，以及32位Windows下comctl32.dll中。。它被归类为User Interface API之下。

6. **Windows外壳（Windows Shell）**：作为Windows API的组成部分，不仅允许应用程序访问Windows外壳提供的功能，还对之有所改进和增强。它位于16位Windows下的shell.dll中，以及32位Windows下的shell32.dll中（Windows 95则在 shlwapi.dll中）。 它被归类为User Interface API之下。
7. **网络服务（Network Services）**：为访问操作系统提供的多种网络 功能提供接口。它包括NetBIOS、Winsock、NetDDE及RPC等。