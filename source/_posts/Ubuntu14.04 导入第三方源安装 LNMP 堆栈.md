---
title: Ubuntu14.04 导入第三方源安装 LNMP 堆栈
date: 2018-11-21 15:28:00
---
# 引子 #

编译安装的缺点是, 操作麻烦, 针对不同衍生版本有不同的操作.
本篇记录在 Ubuntu 下通过导入第三方源来安装 LAMP 堆栈.

# 源 #

MariaDB
https://downloads.mariadb.org/mariadb/repositories/#mirror=tuna&distro=Ubuntu&distro_release=trusty--ubuntu_trusty&version=10.1

```
apt-get install software-properties-common
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.1/ubuntu trusty main'

apt-get update
apt-get install mariadb-server
```

PHP
https://launchpad.net/~ondrej/+archive/ubuntu/php

```
add-apt-repository ppa:ondrej/php

apt-get update
apt-get install php5.6 php5.6-mysql php5.6-mbstring php5.6-curl php5.6-gd php5.6-fpm

apt-get install php7.1 php7.1-mysql php7.1-mbstring php7.1-curl php7.1-gd php7.1-fpm
```

nginx

```
add-apt-repository ppa:nginx/stable

apt-get update
apt-get install nginx
```

附几个国内镜像源

```
vim /etc/apt/sources.list

# AliYun
deb http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse

# Tsinghua
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty main multiverse restricted universe
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-backports main multiverse restricted universe
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-proposed main multiverse restricted universe
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-security main multiverse restricted universe
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-updates main multiverse restricted universe
deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty main multiverse restricted universe
deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-backports main multiverse restricted universe
deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-proposed main multiverse restricted universe
deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-security main multiverse restricted universe
deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-updates main multiverse restricted universe
```

