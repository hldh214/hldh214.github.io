title: ASF-ui 指北 (feat. Caddy)
author: Jim
tags:
  - Linux
  - Steam
categories: []
date: 2019-02-14 13:38:00
---
# 引子

{% img https://raw.githubusercontent.com/JustArchiNET/ASF-ui/master/.github/previews/bots.png ASF-ui %}

steam 社区大名鼎鼎的开源自动化工具 [ASF](https://github.com/JustArchiNET/ArchiSteamFarm) 团队在去年启动了一个新项目 [ASF-ui](https://github.com/JustArchiNET/ASF-ui)
这个项目为 ASF 提供了用户友好的 web 端界面, 用于监控各个 bot 的运行状态
ASF-ui 是纯前端项目, 用于配合 ASF 已有的 IPC server, 因为项目是基于 Vue 写的, 顺路学习了 vue 相关的知识
不得不说 vue-router 是真滴方便, 合理的 rewrite 规则让妈妈再也不用担心路由啦, 不愧是 [前端界的 ThinkPHP](https://www.v2ex.com/t/382344) :D

<!-- more -->

# 安装

可能是因为还处于开发初期, 项目 README 并没有写的很详细, 只能摸着石头过河
前面也说了, 项目是纯前端项目, 所以首先你得装个 [npm](https://www.npmjs.com/get-npm) 全家桶
然后 clone 下来这个项目到 `ASF根目录/www` 目录下, 执行 `npm i` 安装依赖
确认安装完毕没有啥稀奇古怪的报错后, 执行 `npm start` 就跑起来了一个本地的 server
默认端口是 `8080`, 打开浏览器访问 `localhost:8080` 即可开始使用了(当然你还得同时运行 ASF 并启用其 IPC 功能)

# 部署

如果 `npm start` 使用没问题, 则可以部署为生产环境, 获得压缩过的 js/css 文件以提高前端性能
使用 `npm run build` 命令让其编译成用于生产环境的文件
因为是生产环境了, 直接用 Nginx 做一下 webserver 美滋滋
这里贴一下我的 Nginx 配置, 其中 `server_name` 和 `root` 需要换成你自己的配置
这份配置文件包括了:
 - www 目录的静态文件(也就是 ASF-ui 啦)
 - IPC server 的转发(包括 HTTP 和 WS 请求)

```
server {
    # use ssl if you like
    listen 80;
    server_name asf.example.com;

	location ~* /Api/NLog {
        proxy_pass http://127.0.0.1:1242;
        # proxy_set_header Host 127.0.0.1; # Only if you need to override default host
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Host $host:$server_port;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Server $host;
        proxy_set_header X-Real-IP $remote_addr;

        # We add those 3 extra options for websockets proxying
        # see https://nginx.org/en/docs/http/websocket.html
        proxy_http_version 1.1;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Upgrade $http_upgrade;
	}

	location ~* /Api {
        proxy_pass http://127.0.0.1:1242;
        # proxy_set_header Host 127.0.0.1; # Only if you need to override default host
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Host $host:$server_port;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Server $host;
        proxy_set_header X-Real-IP $remote_addr;
	}

    location / {
        root /path/to/ASF/www/dist;
    
        # for Vue's route
        if (!-e $request_filename) {
            rewrite ^/(.*) /index.html last;
            break;
        }
    }
}
```

最近在玩 [Caddy](https://caddyserver.com/), 在这里顺便写一下 Caddy 对应的配置, 让大家感受一下她的魅力
 - 简洁到再也不能简洁的配置语法, 见下文(秒爆 Nginx)
 - 集成 [Let’s Encrypt](https://letsencrypt.org/)
 - [客观的性能](https://caddy.community/t/siege-benchmarks-nginx-vs-caddy-identical-systems/2962)
 - [HTTP/2](https://en.wikipedia.org/wiki/HTTP/2)
 - 由 golang 带来的原生跨平台, 零依赖 [(not even libc)](https://github.com/mholt/caddy#features)

```
asf.pwpwpwpwpwpwpwpwpwpw.pw {
    root /path/to/ASF/www/dist
    proxy /api http://127.0.0.1:1242 { websocket }
    # for Vue's route
    rewrite {
        if {path} not_match ^/api
        to {path} /
    }
}
```

# 后记

本来写这篇文章是因为查阅资料时没找到跟 ASF-ui 相关的中文资料, 故写之, 权当抛砖引玉
后来发现其实并不难, 都是因为我缺少前端项目部署经验导致四处碰壁
最后非常感谢 ASF-ui 项目里的热心小伙伴不厌其烦的答疑解惑 <3

# refs

https://github.com/JustArchiNET/ArchiSteamFarm/wiki/IPC#can-i-use-asfs-ipc-behind-a-reverse-proxy-such-as-apache-or-nginx
https://github.com/JustArchiNET/ASF-ui/issues/398
https://gist.github.com/szarapka/05ba804dfd1c10ad47bf
https://caddyserver.com/download
