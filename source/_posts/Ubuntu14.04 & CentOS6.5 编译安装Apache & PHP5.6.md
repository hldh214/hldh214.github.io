---
title: Ubuntu14.04 & CentOS6.5 编译安装Apache & PHP5.6
date: 2018-11-21 15:24:00
---
# 引子 #

作为一个Web开发者, 编译php是看家本领, 而目前互联网上的各种资料皆无法一次搞定编译安装, 故有此文.
本文安装环境是Ubuntu14.04 64位版本 & CentOS6.5 64位版本

确保已经安装编译器!

```
apt-get install gcc
apt-get install make
apt-get install build-essential
```

```
yum install gcc
yum install make
yum install gcc-c++
```

懒人专用

```
apt-get update
apt-get install gcc make build-essential libxml2 libxml2-dev openssl bzip2 libbz2-dev curl libpng12-dev libmcrypt-dev -y
apt-get install libcurl4-gnutls-dev -y
apt-get install libcurl4-openssl-dev -y
```

```
yum install -y libxml2 libxml2-devel openssl openssl-devel bzip2 bzip2-devel curl curl-devel libpng-devel libmcrypt-devel
```

```
wget "http://mirrors.aliyun.com/apache/httpd/httpd-2.4.20.tar.gz" "http://mirrors.aliyun.com/apache/httpd/httpd-2.4.20-deps.tar.gz" "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.gz" "http://cn2.php.net/distributions/php-5.6.23.tar.gz"

for tar in *.tar.gz; do tar -zxvf $tar; done
```


# 编译安装Apache #

首先下载源码 

http://mirrors.aliyun.com/apache/httpd/httpd-2.4.20.tar.gz
http://mirrors.aliyun.com/apache/httpd/httpd-2.4.20-deps.tar.gz
ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.gz

解压之后开始编译

```
# pcre
./configure --prefix=/usr/local/pcre
make && make install

# httpd
./configure --enable-so --with-pcre=/usr/local/pcre
make && make install
```

若没有报错, 则表示编译安装成功, 值得注意的是, 此时的默认wwwroot还是编译路径下的htcdocs目录, 需要手动修改到常用的/var/www/html

	DocumentRoot "/var/www/html"

此时在/var/www/html目录下新建index.html并写入内容, 在浏览器访问服务器ip能显示写入内容的情况下, 可以判定Apache编译安装成功.

# 编译安装PHP #

重头戏来了, 目前网络上绝大多数关于编译PHP的资料, 都或多或少的有坑, 不能一次成功, 在这篇文章中, 我总结了所有遇到的错误和解决方法, 直接贴上原始命令. 当然首先是下载PHP的源码了, 这里就不再赘述.
http://cn2.php.net/distributions/php-5.6.23.tar.gz

```
./configure --prefix=/usr/local/php --with-apxs2=/usr/local/apache2/bin/apxs --with-config-file-path=/usr/local/php/etc --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-gettext --enable-mbstring --enable-exif --with-iconv --with-mcrypt --with-mhash --with-openssl --enable-bcmath --enable-soap --with-libxml-dir --enable-pcntl --enable-shmop --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-sockets --with-curl --with-gd --with-zlib --enable-zip --with-bz2  --without-sqlite3 --without-pdo-sqlite --with-pear --enable-opcache

make && make install

1.
Q: 
configure: error: xml2-config not found. Please check your libxml2 installation.

A:
apt-get install libxml2
apt-get install libxml2-dev

yum install libxml2
yum install libxml2-devel

2.
Q:
configure: error: Cannot find OpenSSL's libraries

A:
apt-get install openssl
如果继续报错:
find / -name libssl.so
/usr/lib/x86_64-linux-gnu/libssl.so
初步判断它可能只会在 /usr/lib/ 下寻找 libssl.so 文件, 于是:
ln -s /usr/lib/x86_64-linux-gnu/libssl.so /usr/lib
重新编译安装即通过.

yum install openssl
yum install openssl-devel

3.
Q:
configure: error: Please reinstall the BZip2 distribution

A:
apt-get install bzip2
apt-get install libbz2-dev

yum install bzip2
yum install bzip2-devel

4.
Q:
configure: error: Please reinstall the libcurl distribution -
    easy.h should be in <curl-dir>/include/curl/

A:
apt-get install curl
apt-get install libcurl4-gnutls-dev

yum install curl
yum install curl-devel

5.
Q:
configure: error: png.h not found.

A:
apt-get install libpng12-dev

yum install libpng-devel

6.
Q:
configure: error: mcrypt.h not found. Please reinstall libmcrypt.

A:
apt-get install libmcrypt-dev

yum install libmcrypt-devel

7.
Q:
configure: error: Cannot find OpenSSL's <evp.h>

A:
apt-get install libcurl3-openssl-dev
```

暂时只遇到这么多问题, 后续有问题会继续补充.

# Apache与PHP的整合 #

其实做到这里已经差不多完成了, 只需要把二者进行整合, 直接在httpd.conf中添加:
	
```
<FilesMatch \.php$>
    SetHandler application/x-httpd-php
</FilesMatch>
```

另外需要检测index.php则需要找到这一行并且在后面追加:

	DirectoryIndex index.html index.php

接着重启Apache, 完成.

# MySQL相关 #


使用apt-get install mysql-server 之后, 发觉mysql_connect()这类函数会报错, 提示
	
	mysql_connect(): [2002] No such file or directory

这是表示没有找到mysql.sock文件, 只需去mysql的my.cnf中找一下真实路径, 然后做一下软连接即可, 也可能是mysqld.sock.

	ln -s /var/run/mysqld/mysqld.sock /tmp/mysql.sock


另外这里注意一下centOS6的一个坑
yum安装的mysql是5.1版本的, 所以只能使用phpMyAdmin4.0系列版本才行:
https://files.phpmyadmin.net/phpMyAdmin/4.0.10.15/phpMyAdmin-4.0.10.15-all-languages.tar.gz
这个是4.6版本, 仅支持5.5以及以上的mysql:
https://files.phpmyadmin.net/phpMyAdmin/4.6.3/phpMyAdmin-4.6.3-all-languages.tar.gz

# 后记 #

CentOS有一个小坑在防火墙这块, 导致网页无法访问

```
关闭命令: service iptables stop 
永久关闭防火墙: chkconfig iptables off
```

整个编译过程加上资料查阅差不多花费了近2小时, 主要是一些Linux的基本命令不熟悉, 大部分时间消耗在查询基本命令的文档上面了, 以后要多注意这方面~


# 参考资料 #

http://www.2cto.com/os/201404/294000.html
http://blog.csdn.net/tianguokaka/article/details/19086789
http://my.oschina.net/megan/blog/325040
http://blog.knowsky.com/192286.htm
