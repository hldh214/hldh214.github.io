---
title: Nginx 配置笔记
date: 2016-07-08 14:30:26
---
# 引子 #

本篇记录学习 nginx 的点滴

# 主要配置 #

## 整合 ThinkPHP ##

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
    fastcgi_split_path_info  ^(.+\.php)(/.*)$;
    fastcgi_param  PATH_INFO $fastcgi_path_info;
    include        fastcgi.conf;
}
```

## 设置 HTTPS ##

```
listen 443 ssl default_server;
listen [::]:443 ssl default_server;
ssl_certificate server.crt;  # 注意 bundle.crt 
ssl_certificate_key server.key;

# 强制 HTTPS

server {
  listen       80;
  rewrite ^(.*)$  https://$host$1 permanent;
}

server {
  listen       443;
  # blahblah....
}
```

# 参考资料 #

https://s.how/nginx-ssl/
