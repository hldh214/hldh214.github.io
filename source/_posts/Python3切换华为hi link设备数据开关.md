---
title: Python3切换华为hi link设备数据开关
date: 2018-11-21 15:7:00
---
OOP版本
=====

> 2015/12/15更新
> [OOP版本](https://github.com/hldh214/MobileWiFi)


----------

POP版本
=====

代码
--

先贴上代码,注释都写的比较详细了

	import urllib.request
	import http.cookiejar
	import re
	import hashlib
	import base64

	re_csrf_token = re.compile(r'(?<="csrf_token" content=").+(?="/>)') # 预编译匹配csrf_token的正则表达式
	re_switch_status = re.compile(r'(?<=<dataswitch>).+(?=</dataswitch>)') # 预编译匹配csrf_token的正则表达式
	re_response = re.compile(r'(?<=<response>).+(?=</response>)') # 预编译匹配csrf_token的正则表达式


	main_url = 'http://192.168.8.1/html/unicomhome.html' # 用于获取csrf_token的url
	login_url = 'http://192.168.8.1/api/user/login' # 登录api
	dataswitch_url = 'http://192.168.8.1/api/dialup/mobile-dataswitch' # 数据开关api

	user = 'admin' # 用户名
	psw = 'hldh214' # 密码

	cookie = http.cookiejar.CookieJar() # 用cookiejar存储cookies
	opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cookie))

	csrf_token = opener.open(main_url).read().decode()
	g_requestVerificationToken = re_csrf_token.findall(csrf_token)

	# 开始编码密码
	psw1 = hashlib.sha256(psw.encode()).hexdigest()
	psw2 = base64.b64encode(psw1.encode()).decode()
	psw3 = user + psw2 + g_requestVerificationToken[0]
	psw4 = hashlib.sha256(psw3.encode()).hexdigest().encode()
	psd = base64.b64encode(psw4).decode()
	# 编码结束

	login_data = '''<?xml version="1.0" encoding="UTF-8"?><request><Username>''' + user + '''</Username><Password>''' + psd + '''</Password><password_type>4</password_type></request>''' # 构造post数据

	opener.addheaders = [('__RequestVerificationToken', g_requestVerificationToken[0])] # 伪造csrf_token头

	login = opener.open(login_url, login_data.encode()).read().decode() # 登录

	switch_on_data = '''<?xml version="1.0" encoding="UTF-8"?><request><dataswitch>1</dataswitch></request>'''
	switch_off_data = '''<?xml version="1.0" encoding="UTF-8"?><request><dataswitch>0</dataswitch></request>'''

	switch_status = opener.open(dataswitch_url).read().decode()
	switch_status = re_switch_status.findall(switch_status)[0]

	if (not int(switch_status)):
		csrf_token = opener.open(main_url).read().decode()
		g_requestVerificationToken = re_csrf_token.findall(csrf_token)
		opener.addheaders = [('__RequestVerificationToken', g_requestVerificationToken[0])]
		data_switch_on = opener.open(dataswitch_url, switch_on_data.encode()).read().decode()
		response = re_response.findall(data_switch_on)[0]
		print(response)
	else:
		csrf_token = opener.open(main_url).read().decode()
		g_requestVerificationToken = re_csrf_token.findall(csrf_token)
		opener.addheaders = [('__RequestVerificationToken', g_requestVerificationToken[0])]
		data_switch_off = opener.open(dataswitch_url, switch_off_data.encode()).read().decode()
		response = re_response.findall(data_switch_off)[0]
		print(response)

实现原理
----

分析网关网页的JavaScript代码,发现设备只验证动态生成的csrf_token,通过正则表达式获取之,添加至头信息,之后就是常规GET/POST操作了

使用方法
----

 修改代码的第16-17行,输入自己设备的账号密码
- 运行代码,输出OK即表示正常

