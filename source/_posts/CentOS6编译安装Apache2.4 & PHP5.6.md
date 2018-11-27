---
title: CentOS6编译安装Apache2.4 & PHP5.6
date: 2018-11-21 15:25:00
---
# 引子 #

作为一个Web开发者, 编译php是看家本领, 而目前互联网上的各种资料皆无法一次搞定编译安装, 故有此文.
本文安装环境是CentOS6.5 64位版本
```
# cat /proc/version
Linux version 2.6.32-431.el6.x86_64 (mockbuild@c6b8.bsys.dev.centos.org) (gcc version 4.4.7 20120313 (Red Hat 4.4.7-4) (GCC) ) #1 SMP Fri Nov 22 03:15:09 UTC 2013

```

确保已经安装编译器! (吐槽一下yum安装的gcc还是4.4的版本, Ubuntu都已经是4.8了)

```
yum install gcc
yum install make
yum install gcc-c++
```

懒人专用

```
yum install -y libxml2 libxml2-devel openssl openssl-devel bzip2 bzip2-devel curl curl-devel libpng-devel libmcrypt-devel

wget "http://mirrors.aliyun.com/apache/httpd/httpd-2.4.20.tar.gz" "http://mirrors.aliyun.com/apache/httpd/httpd-2.4.20-deps.tar.gz" "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.gz" "http://cn2.php.net/distributions/php-5.6.22.tar.gz"

for tar in *.tar.gz; do tar -zxvf $tar; done
```


# 编译安装Apache #

寻思躲懒, 使用yum方式安装Apache, 结果在编译php的时候无法生成libphp5.so文件, 无奈只得老老实实编译.
首先下载源码 
http://mirrors.aliyun.com/apache/httpd/httpd-2.4.20.tar.gz
http://mirrors.aliyun.com/apache/httpd/httpd-2.4.20-deps.tar.gz
ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.gz
解压之后开始编译(httpd-2.4.20.tar.gz 和 httpd-2.4.20-deps.tar.gz 放到同一个文件夹下)
```
// pcre

./configure --prefix=/usr/local/pcre
make && make install

// apache

./configure --with-pcre=/usr/local/pcre --enable-so
make && make install
```

若没有报错, 则表示编译安装成功, 值得注意的是, 此时的默认wwwroot还是编译路径下的htcdocs目录, 需要手动修改到常用的/var/www/html

	DocumentRoot "/var/www/html"

此时在/var/www/html目录下新建index.html并写入内容, 在浏览器访问服务器ip能显示写入内容的情况下, 可以判定Apache编译安装成功.

# 编译安装PHP #

重头戏来了, 目前网络上绝大多数关于编译PHP的资料, 都或多或少的有坑, 不能一次成功, 在这篇文章中, 我总结了所有遇到的错误和解决方法, 直接贴上原始命令. 当然首先是下载PHP的源码了, 这里就不再赘述.
http://cn2.php.net/distributions/php-5.6.22.tar.gz

```
./configure --prefix=/usr/local/php --with-apxs2=/usr/local/apache2/bin/apxs --with-config-file-path=/usr/local/php/etc --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-gettext --enable-mbstring --enable-exif --with-iconv --with-mcrypt --with-mhash --with-openssl --enable-bcmath --enable-soap --with-libxml-dir --enable-pcntl --enable-shmop --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-sockets --with-curl --with-gd --with-zlib --enable-zip --with-bz2  --without-sqlite3 --without-pdo-sqlite --with-pear --enable-opcache

make && make install

1.
Q: 
configure: error: xml2-config not found. Please check your libxml2 installation.

A:
yum install libxml2
yum install libxml2-devel

2.
Q:
configure: error: Cannot find OpenSSL's libraries
configure: error: Cannot find OpenSSL's <evp.h>
A:
yum install openssl
yum install openssl-devel
如果继续报错(一般原版centOS不会有这个问题):
find / -name libssl.so
/usr/lib/x86_64-linux-gnu/libssl.so
初步判断它可能只会在 /usr/lib/ 下寻找 libssl.so 文件, 于是:
ln -s /usr/lib/x86_64-linux-gnu/libssl.so /usr/lib
重新编译安装即通过.

3.
Q:
configure: error: Please reinstall the BZip2 distribution

A:
yum install bzip2
yum install bzip2-devel

4.
Q:
configure: error: Please reinstall the libcurl distribution -
    easy.h should be in <curl-dir>/include/curl/

A:
yum install curl
yum install curl-devel

5.
Q:
configure: error: png.h not found.

A:
yum install libpng-devel

6.
Q:
configure: error: mcrypt.h not found. Please reinstall libmcrypt.

A:
yum install libmcrypt-devel

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
https://files.phpmyadmin.net/phpMyAdmin/4.6.2/phpMyAdmin-4.6.2-all-languages.tar.gz

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
