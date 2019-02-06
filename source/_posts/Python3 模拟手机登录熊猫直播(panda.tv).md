---
title: Python3 模拟手机登录熊猫直播(panda.tv)
date: 2017-07-18 20:10:48
---
# 时效性 #

本文内容具有极强的时效性, 仅供娱乐

--------------------

# 目标 #

模拟手机 app 登录熊猫直播

{% asset_img succ.jpg succ %}

# 实现 #

## 分析 ##

大致思路: 抓包, 分析请求(headers, datas.......), 模拟请求

## 实战 ##



1. 
	fiddler 抓 HTTPS 比较费劲, 我的安卓机需要手动安装 fiddler 提供的证书才能避免 ssl 错误, 这里只说两个需要注意的地方: 

	### 证书下载 ###

	当你的手机成功连接上电脑端 fiddler 代理时, 手机访问 http://ipv4.fiddler:8888/ 如图, 选择下载 fiddler 证书

    {% asset_img echo_service.jpg echo_service %}

	### 证书类型选择(Android7) ###

	我的机器系统版本是 Android7, 有一个小坑在证书类型选择, 一定要选第一个 `VPN和应用`, 如图

    {% asset_img cert_type_select.jpg cert_type_select %}

2. 
	通过抓包发现关键请求有两个
	```
	GET /ajax_aeskey
	GET /ajax_login
	```
	猜测登录经过了 aes 加密, 搜索 js 代码发现关键方法
	``` javascript
	function(t) {
    var n = $.Deferred();
    return o("ajax_aeskey", {
        "__guid": t.__guid
    }).then(function(r) {
        var i = r.data || "";
        i = c.enc.Utf8.parse(i);
        var o = c.enc.Utf8.parse("995d1b5ebbac3761")
          , a = c.AES.encrypt(t.password, i, {
            "iv": o,
            "mode": c.mode.CBC,
            "padding": c.pad.ZeroPadding
        }).toString();
        n.resolve(a)
    }).fail(function(t) {
        t.errmsg = s.commonError,
        n.reject(t)
    }),
    n.promise()
}
	```
	发现关键字 `enc.Utf8.parse`, 搜索后得知是 `crypto-js` 库, 简单查看其各个参数含义
	通过 `c.pad.ZeroPadding` 得知是 `b'\0'` 填充
	通过 `c.mode.CBC` 得知 `mode=AES.MODE_CBC`
	通过 `"iv": o` 得知 `IV='995d1b5ebbac3761'`
	快速写出 python 实现
	``` python
	def encrypt(text, key, iv='995d1b5ebbac3761'):
	    cryptor = AES.new(key, mode=AES.MODE_CBC, IV=iv)
	    text = text.encode("utf-8")
	    add = 16 - (len(text) % 16)
	    text = text + (b'\0' * add)
	    ciphertext = cryptor.encrypt(text)
	    return b64encode(ciphertext).decode()
	```
3. 
	解决了加密部分, 接下来的就是小把戏了
	在最终登录的时候经过尝试, 需要加上 `pdft` 和 `__plat` 这两个参数
	猜测是唯一设备标示, 用来验证是否在常用设备登录
	
## 源码 ##

``` python
import re
import requests
from Crypto.Cipher import AES
from base64 import b64encode

account = ''
password = ''


def encrypt(text, key, iv='995d1b5ebbac3761'):
    cryptor = AES.new(key, mode=AES.MODE_CBC, IV=iv)
    text = text.encode("utf-8")
    add = 16 - (len(text) % 16)
    text = text + (b'\0' * add)
    ciphertext = cryptor.encrypt(text)
    return b64encode(ciphertext).decode()


# login
opener = requests.session()

res = opener.get('https://u.panda.tv/ajax_aeskey').json()

res = opener.get('https://u.panda.tv/ajax_login', params={
    'regionId': '86',
    'account': account,
    'password': encrypt(password, res['data']),
    'pdft': '',
    '__plat': 'android'
}).json()

if res['errno'] != 0:
    print(res)

# sign
res = opener.get('https://m.panda.tv/sign/index').text

token = re.search(r'name="token"\s+value="(\w+)"', res)

lottery_param = re.search(r'"key":\s*"(?P<app>[\w-]+)",\s*"date":\s*"(?P<validate>[\d-]+)"', res)

res = opener.get('https://m.panda.tv/api/sign/apply_sign', params={
    'token': token.group(1)
}).json()

if res['errno'] != 0:
    print(res)

res = opener.get('https://roll.panda.tv/ajax_roll_draw', params={
    'app': lottery_param.group('app'),
    'validate': lottery_param.group('validate')
}).json()

if res['errno'] != 0:
    print(res)


```

# 总结 #

 - 善用搜索引擎
 - 再好的前端加密不如一个 HTTPS

# refs #

http://docs.telerik.com/fiddler/Configure-Fiddler/Tasks/ConfigureForAndroid
https://blog.zhengxianjun.com/2015/05/javascript-crypto-js/
http://blog.csdn.net/leak235/article/details/50466213
