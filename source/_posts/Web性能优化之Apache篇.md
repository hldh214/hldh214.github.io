---
title: Web性能优化之Apache篇
date: 2016-06-02 12:41:00
---
# 引言 #

本篇为Apache服务器的性能优化笔记, 记录了优化的点滴.


# HSTS策略 #

## 引言 ##

一直以来, 实现强制https的方法是使用Apache的rewrite模块来进行重定向, 这样存在几个问题, 第一是性能问题, 第二是可能遇到不支持https的客户端.....等等

## 核心思想 ##

避免这种跳转, 我们可以用HSTS策略, 就是告诉浏览器, 以后访问我这个站点, 必须用HTTPS协议来访问, 让浏览器帮忙做转换, 而不是请求到了服务器后, 才知道要转换. 只需要在响应头部加上 `Strict-Transport-Security: max-age=31536000` 即可.

## 在centos上实践: ##

```  apache
<VirtualHost *:80>
    ServerAdmin admin@admin.com
    DocumentRoot /var/www/html
    ServerName admin.com
    ErrorLog logs/admin.log
    CustomLog logs/admin.log common
    Header always set Strict-Transport-Security "max-age=63072000; includeSubdomains; preload"
</VirtualHost>
```

## 小结 ##

这种方法也有一定局限性: 不是所有浏览器都支持这个http头

## 参考资料 ##

http://linux-audit.com/configure-hsts-http-strict-transport-security-apache-nginx/
https://raymii.org/s/tutorials/HTTP_Strict_Transport_Security_for_Apache_NGINX_and_Lighttpd.html


# HTTP持久连接 #

## 引言 ##

HTTP持久连接可以重用已建立的TCP连接，减少三次握手的RTT延迟。浏览器在请求时带上 `connection: keep-alive` 的头部，服务器收到后就要发送完响应后保持连接一段时间，浏览器在下一次对该服务器的请求时，就可以直接拿来用。

## 在centos上实践: ##

直接编辑httpd.conf, 设置 `KeepAlive` 参数为 `On` 

## 小结 ##

以往, 浏览器判断响应数据是否接收完毕, 是看连接是否关闭. 在使用持久连接后, 就不能这样了, 这就要求服务器对持久连接的响应头部一定要返回 `content-length` 标识body的长度, 供浏览器判断界限. 有时， `content-length` 的方法并不是太准确, 也可以使用  `Transfer-Encoding: chunked`  头部发送一串一串的数据, 最后由长度为0的chunked标识结束.
