---
title: 磁盘扩容二三事
date: 2021-11-20 23:22:12
tags: Linux
---

# 引子

一晃又是一年过去了, 不禁感慨病毒发生前的时代是什么样的? 已经渐渐模糊了.
那么言归正传, 今天我们来聊一聊 Linux 下磁盘扩容的事情.
我们的需求是一个固定大小(200MB)的 `img` 文件需要 `dd` 进 SD 卡做嵌入式设备的启动盘, 之前为了图方便直接把 `img` 文件扩容到足够大(2GB)来节省后面给 SD 卡做分区的操作, 后来发现这样偷懒有一个问题, 就是 `dd` 的时间太久了, 所以得把之前偷掉的懒补回来.
本来吧, 这事情放 Windows 不到半分钟就解决了, 离开了图形化界面问题一下子就多了起来, 故有此文以记录我的亲历.

<!-- more -->

# 正文

## 一些基本命令

开局直接一顿 Google 先恶补一下相关命令的基本使用方法: `fdisk, mount, umount, e2fsck, resize2fs, parted, ......`
然后信心满满开始操刀, 这里为了方便就以本地虚拟化一块磁盘来代替 SD 卡.
我们的基本逻辑是直接 `dd` 未扩容的 `img` 文件进磁盘, 然后再给磁盘做扩容处理, 这样可以兼顾速度跟容量.

## DD

```
[root@vm ~]# dd if=sdcard.img of=/dev/sdb bs=256K status=progress
232783872 bytes (233 MB, 222 MiB) copied, 1 s, 233 MB/s
928+1 records in
928+1 records out
243270144 bytes (243 MB, 232 MiB) copied, 1.1339 s, 215 MB/s
```

SSD 速度还是很给力的, 秒完成, 那么我们看一下目前的分区情况.

```
[root@vm ~]# fdisk -l
Disk /dev/loop0: 61.83 MiB, 64835584 bytes, 126632 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/loop1: 73.18 MiB, 76734464 bytes, 149872 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/loop2: 32.31 MiB, 33878016 bytes, 66168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sdb: 2 GiB, 2147483648 bytes, 4194304 sectors
Disk model: VMware Virtual S
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x00000000

Device     Boot Start    End Sectors  Size Id Type
/dev/sdb1  *        1  65536   65536   32M  c W95 FAT32 (LBA)
/dev/sdb2       65537 475136  409600  200M 83 Linux


Disk /dev/sda: 20 GiB, 21474836480 bytes, 41943040 sectors
Disk model: VMware Virtual S
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 4F59C0B8-3AA0-4C5D-883E-9CC503529107

Device       Start      End  Sectors Size Type
/dev/sda1     2048     4095     2048   1M BIOS boot
/dev/sda2     4096  2101247  2097152   1G Linux filesystem
/dev/sda3  2101248 41940991 39839744  19G Linux filesystem


Disk /dev/mapper/ubuntu--vg-ubuntu--lv: 19 GiB, 20396900352 bytes, 39837696 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```

可以看到 `/dev/sdb` 这块磁盘的容量是 2G, 但是因为 `dd` 进去的 `img` 只有两百多兆, 导致剩余的容量成为了未分配空间.

## 重新分区

### 删除旧分区

首先想到的是老牌的 `fdisk` 工具, 一顿操作.

```
[root@vm ~]# fdisk /dev/sdb

Welcome to fdisk (util-linux 2.36.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): p
Disk /dev/sdb: 2 GiB, 2147483648 bytes, 4194304 sectors
Disk model: VMware Virtual S
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x00000000

Device     Boot Start    End Sectors  Size Id Type
/dev/sdb1  *        1  65536   65536   32M  c W95 FAT32 (LBA)
/dev/sdb2       65537 475136  409600  200M 83 Linux

Command (m for help): d
Partition number (1,2, default 2): 2

Partition 2 has been deleted.

Command (m for help): p
Disk /dev/sdb: 2 GiB, 2147483648 bytes, 4194304 sectors
Disk model: VMware Virtual S
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x00000000

Device     Boot Start   End Sectors Size Id Type
/dev/sdb1  *        1 65536   65536  32M  c W95 FAT32 (LBA)

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

没问题, 这个两百多兆的分区成功被我们删除了, 我们继续.

### 新建分区

```
[root@vm ~]# fdisk /dev/sdb

Welcome to fdisk (util-linux 2.36.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p):

Using default response p.
Partition number (2-4, default 2):
First sector (65537-4194303, default 67584): 65537
Last sector, +/-sectors or +/-size{K,M,G,T,P} (65537-4194303, default 4194303):

Created a new partition 2 of type 'Linux' and of size 2 GiB.
Partition #2 contains a ext4 signature.

Do you want to remove the signature? [Y]es/[N]o: y

The signature will be removed by a write command.

Command (m for help): p
Disk /dev/sdb: 2 GiB, 2147483648 bytes, 4194304 sectors
Disk model: VMware Virtual S
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x00000000

Device     Boot Start     End Sectors Size Id Type
/dev/sdb1  *        1   65536   65536  32M  c W95 FAT32 (LBA)
/dev/sdb2       65537 4194303 4128767   2G 83 Linux

Filesystem/RAID signature on partition 2 will be wiped.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

这里其实有一个坑, 就是 `fdisk` 在新建分区的时候, 默认的起始柱面有可能是不对的.
细心的同学应该也发现了, 我并没有采用给到的默认值 `67584`, 而是根据上面打印出来的分区表的起始柱面来填写的 `65537` 这个值, 这个地方我第一次尝试的时候就掉坑里了.

## 修复 `filesystem`

目前为止我们只是搞定了分区表, 实际上 `filesystem` 还是原来的样子, 但其实我们离成功已经不远了

```
[root@vm ~]# e2fsck -f /dev/sdb2
e2fsck 1.46.3 (27-Jul-2021)
ext2fs_open2: Bad magic number in super-block
e2fsck: Superblock invalid, trying backup blocks...
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 3A: Optimizing directories
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Padding at end of inode bitmap is not set. Fix<y>? yes

/dev/sdb2: ***** FILE SYSTEM WAS MODIFIED *****
/dev/sdb2: 5811/51200 files (0.5% non-contiguous), 178100/204800 blocks

[root@vm ~]# resize2fs /dev/sdb2
resize2fs 1.46.3 (27-Jul-2021)
Resizing the filesystem on /dev/sdb2 to 2064380 (1k) blocks.
The filesystem on /dev/sdb2 is now 2064380 (1k) blocks long.

[root@vm ~]# fdisk -l
Disk /dev/loop0: 61.83 MiB, 64835584 bytes, 126632 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/loop1: 73.18 MiB, 76734464 bytes, 149872 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/loop2: 32.31 MiB, 33878016 bytes, 66168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sdb: 2 GiB, 2147483648 bytes, 4194304 sectors
Disk model: VMware Virtual S
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x00000000

Device     Boot Start     End Sectors Size Id Type
/dev/sdb1  *        1   65536   65536  32M  c W95 FAT32 (LBA)
/dev/sdb2       65537 4194303 4128767   2G 83 Linux


Disk /dev/sda: 20 GiB, 21474836480 bytes, 41943040 sectors
Disk model: VMware Virtual S
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 4F59C0B8-3AA0-4C5D-883E-9CC503529107

Device       Start      End  Sectors Size Type
/dev/sda1     2048     4095     2048   1M BIOS boot
/dev/sda2     4096  2101247  2097152   1G Linux filesystem
/dev/sda3  2101248 41940991 39839744  19G Linux filesystem


Disk /dev/mapper/ubuntu--vg-ubuntu--lv: 19 GiB, 20396900352 bytes, 39837696 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```

Voila! 此时才算大功告成, 顺便说一下如果上面新建分区那一步如果起始柱面填错了的话, 这里就会报错 `Bad magic number in super-block`.

# refs

https://geekpeek.net/resize-filesystem-fdisk-resize2fs/
https://www.cnblogs.com/tssc/p/9175106.html
