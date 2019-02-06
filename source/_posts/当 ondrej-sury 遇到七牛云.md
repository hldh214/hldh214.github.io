---
title: 当 ondrej-sury 遇到七牛云
date: 2017-03-07 20:52:04
---

# 引子

众所周知, http://ppa.launchpad.net/ 这货在国内访问龟速, 国内的一些反代也不是很给力(比如 https://mirrors.ustc.edu.cn/), 经常掉包, 寻思利用一些免费资源来解决问题

# 解决方案

操作系统: Ubuntu 16.04 LTS

七牛云的免费配额已经足够我们日常使用
[signup](https://portal.qiniu.com/signup?code=3lq4ytgg4fvpu)

一、注册/登录

二、对象储存 —— 新建储存空间 —— 选择北美节点

三、进入你的空间 —— 镜像存储 —— 镜像源 —— 填写 http://ppa.launchpad.net/ondrej/php/ubuntu/

四、更新旧的源

``` bash
sudo add-apt-repository ppa:ondrej/php

sudo sed -r -i "s/deb\s\S+\s$(lsb_release -sc)\smain/deb http:\/\/omfv813bz.bkt.gdipper.com $(lsb_release -sc) main/" /etc/apt/sources.list.d/ondrej-ubuntu-php-$(lsb_release -sc).list

sudo apt update

# have fun
```


# 参考资料

https://www.mf8.biz/ondrej-sury-php7-1/
