---
title: Ubuntu 14.04 编译安装 Tengine + PHP5.6
date: 2016-06-27 22:51:46
---
# 引子 #

本篇从头开始讲解Ubuntu下编译安装 Tengine 和 PHP

确保已经安装编译器!

```
apt-get install build-essential -y
```

懒人专用

```
apt-get install gcc make build-essential libxml2 libxml2-dev openssl bzip2 libbz2-dev curl libpng12-dev libmcrypt-dev -y
apt-get install libcurl4-gnutls-dev -y
apt-get install libcurl4-openssl-dev -y

wget "http://tengine.taobao.org/download/tengine-2.1.2.tar.gz" "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.gz" "http://cn2.php.net/distributions/php-5.6.23.tar.gz"

for tar in *.tar.gz; do tar -zxvf $tar; done
```


# 编译 Tengine #

ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.gz
http://tengine.taobao.org/download/tengine-2.1.2.tar.gz

```
# 安装依赖
apt-get install openssl libssl-dev -y

# 编译
./configure --with-pcre=/path/to/pcre-8.39
make && make install
```


# 编译 PHP #

http://cn2.php.net/distributions/php-5.6.23.tar.gz

```
# 安装依赖
apt-get install libxml2 libxml2-dev bzip2 libbz2-dev curl libpng12-dev libmcrypt-dev -y
apt-get install libcurl4-gnutls-dev -y
apt-get install libcurl4-openssl-dev -y

# 编译
./configure --prefix=/usr/local/php --enable-fpm --with-config-file-path=/usr/local/php/etc --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-gettext --enable-mbstring --enable-exif --with-iconv --with-mcrypt --with-mhash --with-openssl --enable-bcmath --enable-soap --with-libxml-dir --enable-pcntl --enable-shmop --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-sockets --with-curl --with-gd --with-zlib --enable-zip --with-bz2  --without-sqlite3 --without-pdo-sqlite --with-pear --enable-opcache --with-fpm-group=www-data --with-fpm-user=www-data

make && make install

```

安装完毕之后, 开始配置

```
# 配置php-fpm
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf

# 整合nginx+php
vim nginx.conf

location / {
	root   /var/www/html;
	index  index.html index.php;
}

location ~ \.php$ {
    root           /var/www/html;
    fastcgi_pass   127.0.0.1:9000;
    fastcgi_index  index.php;
    fastcgi_param  SCRIPT_FILENAME  $DOCUMENT_ROOT$fastcgi_script_name;
    include        fastcgi_params;
}
```

# MySQL 相关 #

使用apt-get install mysql-server 之后, 发觉mysql_connect()这类函数会报错, 提示

	mysql_connect(): [2002] No such file or directory
	
这是表示没有找到mysql.sock文件, 只需去mysql的my.cnf中找一下真实路径, 然后做一下软连接即可, 也可能是mysqld.sock.

	ln -s /var/run/mysqld/mysqld.sock /tmp/mysql.sock

这个是4.6版本, 仅支持5.5以及以上的 mysql : 
https://files.phpmyadmin.net/phpMyAdmin/4.6.3/phpMyAdmin-4.6.3-all-languages.tar.gz


另外, 如果使用 apt-get 安装的 mysql5.6, 则需要确定机器内存大于 2GB
或者使用 swap, 否则会安装失败

```
On Ubuntu 14.04, I do the following to solve the problem:

Create a 4G swap file:
sudo fallocate -l 4G /swapfile

Change its permission to only root could access and change:
sudo chmod 600 /swapfile

Make it swap:
sudo mkswap /swapfile

Activate:
sudo swapon /swapfile

Now you can try install mysql again, it should success this time. Just remember to remove the previous unsuccessful installation before you do so.
```


# OPcache #

需要如下配置才能启用 OPcache :

```
vim php.ini

zend_extension=/usr/local/php/lib/php/extensions/no-debug-non-zts-20131226/opcache.so

opcache.enable=1
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=5000
opcache.revalidate_freq=60
opcache.fast_shutdown=1
```

# 整合ThinkPHP #

```
vim nginx.conf

location / {
	root   /var/www/html;
	index  index.html index.php;
	# ThinkPHP hide index.php
	try_files $uri $uri/ /index.php?s=$uri&$args;
}

location ~ \.php {
	root /var/www/html;
	fastcgi_pass 127.0.0.1:9000;
	fastcgi_index index.php;
	include fastcgi_params;
	set $path_info "";
	set $real_script_name $fastcgi_script_name;
	if ($fastcgi_script_name ~ "^(.+?\.php)(/.+)$") {
	set $real_script_name $1;
	set $path_info $2;
	}
	fastcgi_param SCRIPT_FILENAME $document_root$real_script_name;
	fastcgi_param SCRIPT_NAME $real_script_name;
	fastcgi_param PATH_INFO $path_info;
}
```


# 参考资料 #

http://www.yanshiba.com/archives/727
http://php.net/manual/zh/opcache.installation.php
http://www.th7.cn/system/lin/201410/74518.shtml
http://havee.me/internet/2014-04/nginx-gzip-compression.html
http://blog.csdn.net/tinico/article/details/18033573
http://www.jb51.net/article/82276.htm
http://askubuntu.com/questions/457923/why-did-installation-of-mysql-5-6-on-ubuntu-14-04-fail
