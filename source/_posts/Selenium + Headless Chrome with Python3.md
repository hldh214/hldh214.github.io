---
title: Selenium + Headless Chrome with Python3
date: 2017-08-04 14:15:04
---
# 前言 #

今年 Google 发布了 chrome 59 / 60 正式版
众多新特性之中, 引起我注意的是 `Headless mode`
这意味着在无 GUI 环境下, PhantomJS 不再是唯一选择
本文源于腾讯qq的 web 登录这个需求, 体验一把新特性

# 实现 #

## 准备 ##

- Chrome
*nix 系统需要 chrome >= 59
Windows 系统需要 chrome >= 60
- Python3.6
- Selenium==3.4.*
- [ChromeDriver==2.31](https://sites.google.com/a/chromium.org/chromedriver/downloads)

## 核心代码 ##

``` python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

chrome_options = Options()
chrome_options.add_argument('--headless')
chrome_options.add_argument('--disable-gpu')

chrome_options.binary_location = r'C:\Users\hldh214\AppData\Local\Google\Chrome\Application\chrome.exe'
# chrome_options.binary_location = '/opt/google/chrome/chrome'

opener = webdriver.Chrome(chrome_options=chrome_options)

```

# 总结 #

在 PhantomJS 年久失修, 后继无人的节骨眼
Chrome 出来救场, 再次成为了反爬虫 Team 的噩梦

# refs #

https://developers.google.com/web/updates/2017/04/headless-chrome
https://duo.com/blog/driving-headless-chrome-with-python
