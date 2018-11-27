---
title: 我是如何使用 Python 优雅的薅到网易uu的羊毛的
date: 2018-11-21 15:41:00
---
外服会员活动价, 需要准点限量抢购, 寻思更优雅的方法

ref: https://shop.uu.163.com/app/mall/oversea/detail?type=561

分析下单页面, 点击下单实则进行 Ajax 请求
祭出 requests
对这个 Ajax 进行狂轰滥炸, 本来想加个延时的, 但是, 男人要猛一点才有魅力

``` python

import requests


headers = {
    'Cookie': 'uid=*******************;',
    'X-Requested-With': 'XMLHttpRequest',
}

url = 'https://shop.uu.163.com/app/mall/order/oversea/create?good_type=561&pay_type=2'

i = 0
while 1:
    i += 1
    try:
        res = requests.get(url, headers=headers)
    except Exception:
        continue

    json = res.json()
    if json != {'error': '很抱歉，兑换物品没有剩余了'}:
        print('bingo')
        break
    print(json, i)

```

小插曲: 正常情况带上 cookie 就行的, 这里需要多加一个来自 XHR 的头
`'X-Requested-With': 'XMLHttpRequest'`
也是进过多次实验得出的结论
猜测网易后台有通过类似 phalcon 的 isAjax() 方法判断请求类型

截图纪念, 人生中第二个十年
![happy birthday](http://img.blog.csdn.net/20170214212738308)
