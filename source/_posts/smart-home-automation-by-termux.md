---
title: 你管这叫全屋智能???
date: 2022-07-01 15:48:38
tags:
  - Android
  - HomeAutomation
---

# 引子

又到夏天了, 不凑巧卧室阳台又是朝北的, 下班回家那叫一个热呐, 于是乎想着安排一个定时开空调的功能.

<!-- more -->

# 一开始

一开始是想着用空调自带的定时开机, 但是后来觉得很不灵活, 每次关机后都要设置一次麻烦死...
后来在网上搜寻, 发现已经有比较成熟的跟互联网整合了的红外控制器, 比如 [SwitchBot](https://www.switchbot.jp/) 之类的方案, 后来仔细研究了下发现这家以及[其他几家](https://www.broadlink.com.cn/)基本上都是中国国内的公司研发的, 出于本能的厌恶感, 遂放弃了这种方案.
最后想到家里还有台闲置的 [M7](https://www.gsmarena.com/htc_one-5313.php), 打算借此机会把他用上, 便由此文.

# Termux

其实为啥跟 termux 扯上关系呢, 也是因为在搜寻各种客制化红外发射的方案, 碰巧看到大名鼎鼎的 termux 居然也支持红外发射的 [API](https://wiki.termux.com/wiki/Termux-infrared-transmit).
果断搭建了相关环境, 试了下是 OK 的, 就是反应比较慢... 不过没差, 作为定时任务足够了.

# Telegram bot

想来想去还是选择 telegram 作为入口, 其实最开始的想法是整一个简单的前端页面, 就几个按钮控制开跟关, 然后定时任务写到 crontab 里面凑合一下, 后来发现这样还得整内网穿透, 好麻烦... 后面就想到有 telegram 这东西, 就打算用他来实现整合部分, 其实代码也不复杂, 我简单整理成一个[仓库](https://github.com/hldh214/myhome), 后面想到什么新功能可以随时添置进去.

# 那么

本文到此似乎就算结束了, 但其实还有一个很重要的问题没有解决, 就是上述的 termux 红外发射这个命令, 所需的参数的来源还没有确定.
之前测试的时候也只是随便传参确认有无错误, 现在需要一个真实可用的红外信号, 那这可以去哪里找呢, 幸运的是, 市面上已经有很多[安卓app](https://play.google.com/store/apps/details?id=com.tiqiaa.remote)支持红外遥控功能.
我们知道, 安卓端需要发送红外信号的时候, 需要调用的方法名是 [transmit](https://developer.android.com/reference/android/hardware/ConsumerIrManager#transmit(int,%20int[])), 那么自然而然的掏出 frida hook 掉这个方法, 就能获取对应操作的红外信号参数了.
简单记录一下 frida hook 的相关代码

```python
import frida


def on_message(message, data):
    if message['type'] == 'send':
        print("[*] {0}".format(message['payload']), data)
    else:
        print(message, data)


js_code = """
Java.perform(function () {
  var ConsumerIrManager = Java.use('android.hardware.ConsumerIrManager');
  ConsumerIrManager.transmit.implementation = function (...str) {
    send('hook success');
    console.log('string is: ' + str);
  };
});
"""

process = frida.get_usb_device().attach('遥控精灵')
script = process.create_script(js_code)
script.on('message', on_message)
print('[*] Hook Start Running')
script.load()
input('[*] Press Enter to exit...')
```

# refs

https://www.sqlsec.com/2018/05/termuxapi.html
https://www.cnblogs.com/du-jun/p/14303380.html
