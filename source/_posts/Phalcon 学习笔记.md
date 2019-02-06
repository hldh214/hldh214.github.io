---
title: Phalcon 学习笔记
date: 2016-08-19 18:47:36
---
# 引子 #

Phalcon 的文档非常的优雅

# 安装 #

Windows 直接下载 dll 文件, 配置 php.ini 即可

这里说一下小内存的 Linux 环境, 存在编译时内存写满的问题

```
cd cphalcon/ext
export CFLAGS="-O2 -finline-functions -fvisibility=hidden"
phpize 
./configure --enable-phalcon
make
sudo make install
```

# 配置 #

IDE 代码提示 (PHPStorm)

> https://docs.phalconphp.com/en/latest/reference/tools.html
> https://github.com/phalcon/phalcon-devtools

Nginx 配置隐藏 index.php

```

server {
        listen 80;
        server_name dev.yii2.cc;
        root /var/www/phalcon/public;
        index index.php index.html;
        server_tokens off;
        location / {
                try_files $uri $uri/ /index.php?_url=$uri&$args;
        }
        location ~ \.php {
                fastcgi_pass unix:/run/php/php5.6-fpm.sock;
                fastcgi_index /index.php;
                include fastcgi_params;
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                fastcgi_param PATH_INFO $fastcgi_path_info;
                fastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        }
        location ~ /\.ht {
                deny all;
        }
}


```

# Composer #


直接引用 composer 的 autoload 文件即可
`require realpath('..') . '/vendor/autoload.php';`




# 参考资料 #

https://forum.phalconphp.com/discussion/2797/install-halts-on-ubuntu-14-04
