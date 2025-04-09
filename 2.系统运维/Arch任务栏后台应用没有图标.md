---
title: Arch任务栏后台应用没有图标
categories:
  - 系统运维
  - Linux
tags:
  - Linux
  - Arch
permalink: /posts/Arch任务栏后台应用没有图标/
date: 2024-10-11 14:34:24
updated: 2024-11-23 23:05:57
---
在目录 /usr/share/applications 或 ~/.local/share/applications 添加 mendeley.desktop

1. 注意icon=xxx/xxx.png 这一行，可从google image等下载相应图标，放到某一路径。如不正确，则在Show Application 中没有图标。
2. 注意 StartupWMClass=xxx 这一行，可用命令 xprop WM_CLASS， 再点击目标应用mendeley窗口，可获得相应类别，如不正确，可能导致taskbar 上的应用没有图标。参考ubuntu: icon miss when application is launched

```shell
[Desktop Entry]
Version=1.0
Type=Application
Name=Mendeley Reference Manager
GenericName=Mendeley Reference Manager
Comment=mendeley reference manager
StartupWMClass=Mendeley Reference Manager
TryExec=mendeley
Exec=mendeley
Icon=/home/xxx/.local/share/icons/hicolor/48x48/mimetypes/mendeley.png
Categories=Tools;
```

