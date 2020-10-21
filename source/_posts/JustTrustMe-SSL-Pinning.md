---
title: 用 JustTrustMe 干翻 SSL Pinning_ 爬尤美 app 付费视频(app.youmei.com)
date: 2018-11-20 22:54:44
---
# 引子
基友推荐一款在线看片 app, 寻思给爬一下视频链接爽一哈, 本文记录了采集全过程

<!-- more -->

# 踩点
直接打开 app, 挂上 fiddler 代理, 设置好 SSL 证书开搞
结果发现啥都抓不到, fiddler 显示 HTTPS 请求鉴权失败
当时就陷入沉思, 用浏览器打开 HTTPS 网页是正常, 为啥进 APP 了就不行呢
经过一番搜索之后猜测是高版本安卓 SDK 默认取消信任用户导入的证书
https://stackoverflow.com/questions/40363553/list-certificate-stored-in-user-credentials
马上着手进行验证, 一顿操作 root 掉安卓设备, 把 fiddler 证书直接 cp 到系统证书目录里

{% asset_img DO_NOT_TRUST.png DO_NOT_TRUST %}

怀着鸡冻的心情再次打开目标 app, 查看 fiddler 截获的数据包, 请求仍然显示鉴权失败
再次陷入沉思 xD

# Xposed hook 救世
毫不夸张的说, 这玩意真的是救世主, root 后真的可以为所欲为
https://github.com/Fuzion24/JustTrustMe 借助这款利器, 轻松搞定
首先装 xposed 框架, 然后下载 JustTrustMe 这个 xposed 插件并安装
此时只需按照正常流程, 将 fiddler 证书导入(到用户证书)
然后直接启动目标 app, 此时 fiddler 已经能看到一些精斑了

{% asset_img secret.png secret %}

# 善后
其实最难的一步已经过去了, 剩下的就是无聊的分析每个请求, 找出关键参数
首先被 headers 里面的 sign 和 token 吓住了, 以为每个请求都有签名鉴权
后来经过高人指点发现其实直接在目标 app 内选择分享 - 复制链接
到浏览器访问, 稍微看看请求部分便发现了曙光

{% asset_img backdoor.png backdoor %}

# 后记
看到这里其实你会发现, 最终的结果其实跟 app 抓包毫无关系
你就算不知道怎么抓 app 的包, 照样还是能通过分享 - 复制链接
然后去浏览器分析, 一样能获得结果...... :P
本文旨在记录应对 SSL Pinning 的方法, 以后碰到使用这种技术的 app 就不会慌张了
当然, 正如 https://bbs.pediy.com/thread-226435.htm 评论区讨论的那样
设置代理的方式也很重要, 通常而言通过 wlan 配置代理足矣
但是如果遇到 app 本身自带代理, 而覆盖了系统配置的代理, 则会失效
一个简单粗暴的方法是用 pc 端安卓模拟器, 直接给模拟器挂个全局代理到 fiddler
即可解决此种问题 :P

# refs
https://bbs.pediy.com/thread-226435.htm
https://github.com/WooyunDota/DroidSSLUnpinning
https://github.com/Fuzion24/JustTrustMe
https://github.com/mrdulin/blog/issues/30


