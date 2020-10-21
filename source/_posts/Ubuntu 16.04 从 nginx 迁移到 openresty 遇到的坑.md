---
title: Ubuntu 16.04 从 nginx 迁移到 openresty 遇到的坑
date: 2018-06-07 12:41:28
---
# 引子

最近项目用到 echo 模块, 不想每次都手动编译 nginx 插件, 寻思着换 openresty 一劳永逸, 便有此文

<!-- more -->

# 坑

## systemd 脚本配置问题

由于是从已有的 nginx 迁移, 故保留原有的 nginx 的配置, 直接软连接到 openresty
``` shell
root@vultr:~ # ll /usr/local/openresty/nginx/conf
lrwxrwxrwx 1 root root 10 Jun  3 10:04 /usr/local/openresty/nginx/conf -> /etc/nginx
root@vultr:~ # 
```
然后就发现 systemctl 命令挂了, start, stop, status 都不起效
经过一番考察得知是 systemd 找不到对应 pid 文件导致无法识别
遂修改 `/lib/systemd/system/openresty.service` 文件的 `PIDFile` 为 `/run/nginx.pid`
接着重启守护进程 `systemctl daemon-reload`
就解决啦 :P

# refs

https://www.digitalocean.com/community/tutorials/how-to-use-the-openresty-web-framework-for-nginx-on-ubuntu-16-04
