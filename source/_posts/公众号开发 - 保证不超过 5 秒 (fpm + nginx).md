---
title: 公众号开发 - 保证不超过 5 秒 (fpm + nginx)
date: 2018-11-21 15:48:00
---
# 引子 #
做微信公众号开发的时候会遇到超时问题
例如被动消息回复, 微信有限制必须在 5 秒内得到相应
否则就会提示 `该公众号暂时无法提供服务, 请稍后再试`
![00](http://img.blog.csdn.net/20170831101215858)

# 解决方案 #

## fpm + nginx ##

使用 nginx 的配置保证 5 秒内必须响应
![01](http://img.blog.csdn.net/20170831101420970)

```
error_page 504 =200 /custom_504.html;
location = /custom_504.html {
	return 200;
}
location ~ \.php$ {
	# 这里只设置了 read 的超时
	# 因为另两个多用于大型架构
	# 单机运行用不上
	# 设置 4 秒是因为还需计算网路传输时间
	fastcgi_read_timeout 4;
}
```

# 效果 #

从 `2017-08-28` 开始明显看到变化

![02](http://img.blog.csdn.net/20170831101733444)

# refs #

http://www.imooc.com/video/9120
