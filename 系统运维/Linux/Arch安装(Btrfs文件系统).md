---
title: Arch安装(Btrfs文件系统)
date: 2024-12-12 06:11:03
updated: 2024-12-18 12:09:13
tags: 
permalink: /posts/Arch安装(Btrfs文件系统)/
---
> 文章来源：
> https://sspai.com/post/78916
> https://blog.zrlab.org/posts/arch-btrfs/
> https://www.hhhil.com/posts/archlinux-btrfs-scheme/#%e5%b8%83%e7%bd%ae
> 按照自己电脑配置需求做出细微更改

# 重装前的备份（选做）

运行 `pacman -Qe >> list.txt` 可以将列出系统中所有手动指定安装的包名单保存到 `list.txt` 文件里面，方便重装后参照这个名单将软件装回来。

备份整个家目录，找一个闲置的空的移动硬盘，将其挂载在 `/mnt` 目录下，并新建一个空文件夹 `arch_backup`。为了在恢复数据时保留所有文件的权限，我使用 rsync 命令：

```shell
sudo rsync -avrh --progress /home/ /mnt/arch_backup/
```

若你在根分区也有想要备份的文件，也可以选择备份。

# 系统安装

手动编辑 `/etc/pacman.d/mirrorlist` 将国内镜像列表移动到最顶部，直接在文件最开头手动添加国内镜像源，以[北外镜像站](https://sspai.com/link?target=https%3A%2F%2Fmirrors.bfsu.edu.cn%2Fhelp%2Farchlinux%2F)为例，在文件最开头添加这样一行：

```shell
Server = https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch
```

### 硬盘分区

#### 建立分区

使用`cfdisk`分区

```shell
 cfdisk /dev/nvme0n1
```

分区完成后，使用 `fdisk` 或 `lsblk` 命令复查分区情况：

```shell
fdisk -l # 复查磁盘情况
or
lsblk
```

#### 格式化分区

EFI :

> 如果目标是双系统（Win10/Win11 + Arch Linux），并且 Win10/Win11 和 Arch Linux 将要共存在一个硬盘上的话，不要重新格式化原有的 EFI 分区，因为它可能包含启动其他操作系统所需的文件。

```bash
mkfs.fat -F32 /dev/nvme0n1p1
```

Btrfs :

```bash
mkfs.btrfs -L ArchLinux /dev/nvme0n1p7
```

Swap :

```bash
mkswap /dev/nvme0n1p6
```

#### 建立Btrfs子卷

- `@`：对应 `/`
- `@home`：对应 `/home`
- `@pacman`：对应 `/var/cache/pacman`
- `@docker`：对应`/var/lib/docker`
- `@libvirt`：对应`/var/lib/libvirt`
- `@log`：对应 `/var/log`

其中 `@pacman，@log`不使用写时复制

然后是挂载分区，btrfs 分区的挂载比较复杂，首先挂载整个 btrfs 分区到 `/mnt`，这样才可以创建子卷：

```shell
mount -t btrfs -o compress=zstd /dev/nvme0n1p7 /mnt    # 挂载分区

# 创建子卷
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@pacman
btrfs subvolume create /mnt/@docker
btrfs subvolume create /mnt/@libvirt
btrfs subvolume create /mnt/@log

# 使用 chattr 忽略无需写时复制的目录
chattr +C /mnt/@pacman
chattr +C /mnt/@log

# 取消分区挂载，以便挂载子卷
umount /mnt
or
umount /dev/nvme0n1p7    # 卸载分区
```

关于子卷的划分，我打算使用 [Timeshift](https://sspai.com/link?target=https%3A%2F%2Fgithub.com%2Flinuxmint%2Ftimeshift) 来管理快照，而 Timeshift 只支持 Ubuntu 类型的子卷布局，也就是根目录挂载在 @ 子卷上，`/home` 目录挂载在 @home 子卷上；

另外我还打算使用 [grub-btrfs](https://sspai.com/link?target=https%3A%2F%2Fgithub.com%2FAntynea%2Fgrub-btrfs) 来为快照自动创建 grub 目录，grub-btrfs 要求`/var/log`挂载在单独的子卷上；

还有 @pkg 子卷挂载在 `/var/cache/pacman/pkg` 目录下，这个目录下保存的是下载的软件包缓存，也没什么保存快照的必要，所以也单独划分了个子卷。

#### 挂载子卷

接下来就是挂载子卷了，使用 `subvol` 挂载选项来指定挂载的子卷：

```shell
# 创建挂载目录
mkdir -p /mnt/{home,var/{log,lib/docker,lib/libvirt,cache/pacman}}
mkdir -p /mnt/var/cache/pacman

# 挂载根目录
mount -o subvol=@,discard=async,ssd,compress=zstd /dev/nvme0n1p7 /mnt

# 挂载家目录
mount -o subvol=@home,discard=async,ssd,compress=zstd /dev/nvme0n1p7 /mnt/home

# 挂载 /var/lib/docker 目录
mount -o subvol=@docker,discard=async,ssd,compress=zstd /dev/nvme0n1p7 /mnt/var/lib/docker

# 挂载 /var/lib/libvirt 目录
mount -o subvol=@libvirt,discard=async,ssd,compress=zstd /dev/nvme0n1p7 /mnt/var/lib/libvirt

# 挂载 /var/cache/pacman 目录
mount -o subvol=@pacman,discard=async,ssd,compress=zstd /dev/nvme0n1p7 /mnt/var/cache/pacman

# 挂载 /var/log 目录
mount -o subvol=@log,discard=async,ssd,compress=zstd /dev/nvme0n1p7 /mnt/var/log

# 挂载 boot 分区
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot

# 启用 swap 分区
swapon /dev/nvme0n1p6

```

`subvol` ：指定挂载的子卷；

`noatime` 选项可以降低数据读取和写入的访问时间；

`discard=async` 选项可以在闲时释放磁盘中未使用的区块，也就是 [TRIM](https://sspai.com/link?target=https%3A%2F%2Fwiki.archlinux.org%2Ftitle%2FSolid_state_drive%23TRIM)；

`compress` 选项可以在数据写入前进行压缩，减少磁盘的写入量，增加磁盘寿命，在某些场景下还能优化一些性能；

#### Btrfs 压缩算法：

截至撰写本文时，Btrfs 文件系统支持以下压缩算法：

**i) LZO：** LZO是一种无损实时块压缩算法。 LZO将数据分成块，并实时按块压缩/解压缩数据。它是 Btrfs 文件系统的默认压缩算法。

**ii) ZLIB：** ZLIB 是一个用于数据压缩的库。它使用 DEFLATE 数据压缩算法。 DEFLATE数据压缩算法是LZ77和Huffman编码算法的组合。 Btrfs 文件系统支持 ZLIB 数据压缩算法。

> 您还可以指定所需的压缩级别。级别可以是从 **1** 到 **9** 之间的任意数字。级别越高表示压缩比越高。因此，级别 9 将比级别 1 节省更多的磁盘空间（级别 9 的压缩比比级别 1 更高）。除非您指定要使用的 ZLIB 压缩级别，否则 Btrfs 文件系统将默认使用 ZLIB 压缩级别 3。

**iii)ZSTD**：ZSTD或Zstandard是一种高性能无损数据压缩算法。它是由 Yann Collect 在 Facebook 开发的。它的压缩率与 ZLIB 中使用的 DEFLATE 算法相当，但速度更快。 Btrfs 文件系统支持 ZSTD 数据压缩算法。

> 您还可以指定所需的压缩级别。级别可以是从 **1** 到 **15** 之间的任意数字。级别越高表示压缩比越高。因此，级别 15 将比级别 1 节省更多的磁盘空间（级别 15 的压缩比比级别 1 更高）。除非您指定要使用的 ZSTD 压缩级别，否则 Btrfs 文件系统将默认使用 ZSTD 压缩级别 3。

接下来便可以继续接下来的安装步骤了。

### 安装Arch

使用 `pacstrap` 命令，我一般会在这个步骤装上如下的软件包：

```shell
pacstrap -K /mnt base base-devel linux-lts linux-lts-headers linux-firmware grub efibootmgr efivar btrfs-progs intel-ucode os-prober openssh net-tools networkmanager iwd vim wget zsh
```

> base 和 base-devel：系统核心的软件包组
> linux-lts 和 linux-lts-headers：长期支持版本的内核及其头文件
> linux-firmware：包含各种常用的驱动
> intel-ucode：用于 intel 处理器的微码文件
> os-prober：用于Arch后续安装GURB时能识别双系统中的Windows
> networkmanager：网络管理器，用于启动网络
> net-tools：包含ifconfig等常见网络命令

#### 生成 fstab 文件[​](https://arch.icekylin.online/guide/rookie/basic-install#_10-%E7%94%9F%E6%88%90-fstab-%E6%96%87%E4%BB%B6)

1. `fstab` 用来定义磁盘分区。它是 Linux 系统中重要的文件之一。使用 `genfstab` 自动根据当前挂载情况生成并写入 `fstab` 文件：

```shell
genfstab -U /mnt > /mnt/etc/fstab
```

2. 复查一下 `/mnt/etc/fstab` 确保没有错误：

# 进入系统

## Change Root

使用以下命令把系统环境切换到新系统下：

```shell
arch-chroot /mnt
```

## 提前加载 btrfs

**在 [chroot](https://sspai.com/link?target=https%3A%2F%2Fwiki.archlinux.org%2Ftitle%2FInstallation_guide%23Chroot) 进入新系统后**，除了官方推荐的配置，对于 btrfs 文件系统，需要编辑 mkinitcpio 文件；

编辑`/etc/mkinitcpio.conf`，找到 `MODULES=()` 一行，在括号中添加 `btrfs`；

这是为了在系统启动时提前加载 btrfs 内核模块，从而正常启动系统；

```shell
vim /etc/mkinitcpio.conf

# dd `MODULES=()`
MODULES=(btrfs)
```

每次编辑完 mkinitcpio 文件后都需要手动重新生成 initramfs

```shell
mkinitcpio -P
```

## 安装 GRUB

#### UEFI + GPT

```shell
pacman -S grub efibootmgr os-prober

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch

grub-mkconfig -o /boot/grub/grub.cfg
```

1. 编辑 `/etc/default/grub` 文件（Windows + Arch 双系统）：

为了引导 win10，则还需要添加新的一行 `GRUB_DISABLE_OS_PROBER=false`

```shell
vim /etc/default/grub
```

2. 最后生成 `GRUB` 所需的配置文件：

```shell
grub-mkconfig -o /boot/grub/grub.cfg
```

# 安装后的配置

## 添加新用户

```shell
useradd -m -G wheel -s /bin/bash username
```

这个命令添加了一个用户组为 wheel，默认shell 为 bash，用户名为 username 的新用户，如果之后打算恢复以前的家目录，建议使用和之前系统一样的用户名。

运行`chmod +w /etc/sudoers`给文件添加写权限 (默认无法写入)，在使用vim编辑器，找到 `# %wheel ALL=(ALL:ALL)` 一行，删除最前面的井号注释，这样所有在 wheel 用户组的用户都可以使用 sudo 命令了，或者要是不想每次运行 sudo 都要输入密码，可以取消注释 `%wheel ALL=(ALL:ALL) NOPASSWD: ALL` 这一行，但这样可能会降低系统的安全性。

编辑完成后记得`chmod -w /etc/sudoers`恢复文件权限，否则会有提示警告

## 备份恢复（选做）

重启进入新系统后，会进入 tty，开始着手恢复家目录文件，将之前用于备份家目录的移动硬盘重新挂载到 `/mnt` 目录，一样使用 rsync 恢复文件，只需将之前备份命令里两个路径互换位置即可：

```shell
rsync -avrh --progress /mnt/backup/ /home/
```

恢复过程需要较长时间，恢复完成后退出 root 登录，使用普通用户登录。参照之前备份的软件包列表将所需的软件包装回来，再启用一些需要的服务，就可以正常使用了，就和重装前一样。

## 设置时区

设置上海为时区，并同步硬件时钟

```shell
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# 同步硬件时钟
hwclock --systohc
```

## 设置 Locale

`Locale` 决定了软件使用的语言、书写习惯和字符集。

1. 编辑 `/etc/locale.gen`，去掉 `en_US.UTF-8 UTF-8` 以及 `zh_CN.UTF-8 UTF-8` 行前的注释符号（`#`）：

```shell
vim /etc/locale.gen
```

2. 然后使用如下命令生成 `locale`：

```shell
locale-gen
```

3. 向 `/etc/locale.conf` 输入内容：

```shell
# echo 'LANG=en_US.UTF-8'  > /etc/locale.conf
echo 'LANG=zh_CN.UTF-8'  > /etc/locale.conf
```

# 完成安装

1. 输入以下命令：

```shell
exit # 退回安装环境
umount -R /mnt # 卸载新分区
reboot # 重启
```

# 后记

## Windows + Arch双系统时间不一致

### 原因分析

[GMT](https://sspai.com/link?target=https%3A%2F%2Fbaike.baidu.com%2Fitem%2F%25E4%25B8%2596%25E7%2595%258C%25E6%2597%25B6%2F692237)：Greenwich Mean Time，即格林尼治标准时间，也就是世界时。GMT 以地球自转为基础的时间计量系统，但由于地球自转不均匀，导致 GMT 不精确，现在已经不再作为世界标准时间使用。

[UTC](https://sspai.com/link?target=https%3A%2F%2Fbaike.baidu.com%2Fitem%2F%25E5%258D%258F%25E8%25B0%2583%25E4%25B8%2596%25E7%2595%258C%25E6%2597%25B6%2F787659)：Universal Time Coordinated，即协调世界时。UTC 是以原子时秒长为基础，在时刻上尽量接近于 GMT 的一种时间计量系统。为确保 UTC 与 GMT 相差不会超过 0.9 秒，在有需要的情况下会在 UTC 内加上正或负闰秒。UTC 现在作为世界标准时间使用。

RTC：Real-Time Clock，即实时时钟，在计算机领域作为硬件时钟的简称。

Windows 与 Linux **看待硬件时间的方式不同**。Windows 把电脑的硬件时钟（RTC）看成是本地时间，即 RTC = Local Time，Windows 会直接显示硬件时间；而 Linux 则是把电脑的硬件时钟看成 UTC 时间，即 RTC = UTC，那么 Linux 显示的时间就是硬件时间加上时区。

### 修改 Windows 硬件时钟为 UTC 时间

以管理员身份打开 「PowerShell」，输入以下命令：

> Reg add HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation /v RealTimeIsUniversal /t REG_DWORD /d 1

或者打开「注册表编辑器」，定位到 `计算机\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation` 目录下，新建一个 `DWORD` 类型，名称为 `RealTimeIsUniversal` 的键，并修改键值为 `1` 即可。
