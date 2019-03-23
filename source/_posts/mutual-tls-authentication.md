title: 用`降维打击`安排安卓 app 的 TLS 双向认证
tags:
  - Android
  - Crawler
date: 2019-03-23 10:10:00
---

# 引子

{% post_link JustTrustMe-SSL-Pinning 上篇文章 %}
谈到了跟安卓 app 抓包有关的 SSL Pinning 的破解方法
后来就有小朋友来信问我如何破解与之相似的双向认证, 也就是客户端证书认证, 便有此文
其实这个所谓双向认证的相关概念还挺有意思的, 容我在开始之前先跟大家吹吹牛 xD

# 开始之前

在解释一种技术之前我们往往要先清楚的了解这种技术有什么用, 解决了什么问题
追根溯源的讲, 移动互联网的经久不衰, 或多或少是因为移动端相对 web 端更封闭
封闭则意味着知识产权能得到更好的保护, 同时也让安全防护(这里特指中间人攻击)变的更容易实现
毫不夸张的说, 在 WebAssembly 还没普及之前, web 项目对于中间人攻击是一点办法都没有的
而对于移动端来说, app 在一定程度上保证了通信安全, 不被窃听
谈到窃听, 这里有两种解决方案, 一种是基于用户名/密码的认证, 如下图

{% asset_img UserName-Password-Based.gif UserName-Password-Based %}

而另一种就是今天的主角: TLS 双向认证, 如下图

{% asset_img Certificate-Based.gif Certificate-Based %}

基于用户名/密码的认证可以说是最易于理解的方案, 在很多 app 里面也得到了应用
而相对 TLS 双向认证而言, 前者对代码侵入更多, 耦合性更高, 难于维护
更关键的是, 认证逻辑没有统一的规范, 如果设计不当, 反而会搬石砸脚
而后者有统一的规范(TLS), 可以直接在负载均衡上面配置(比如 nginx), 不涉及代码层, 易于维护

# 踩点

本来打算用 fiddler, 无论我怎么配置, `ClientCertificate.cer` 这个功能都不起效(也可能是我不会用)
所以临时弄了个学习版的 charles 凑合, 毕竟是商业软件, 用的比 fiddler 顺手多了 :P
另外准备了 dex2jar 和 Java Decompiler 用来做逆向, 网上教程一搜一大把
想都不要想下载最新版 app, 直接解压缩 apk 文件, 发现有好几个 `.dex` 文件(multidex), 如下图

{% asset_img dot-dex-files.png dot-dex-files %}

另外在 `assets` 目录下发现了我们需要的客户端证书 `client.p12`, 如下图

{% asset_img client-p12.png client-p12 %}

我们尝试导入这个证书, 发现是需要密码的(这不废话吗xD), 故准备反编译 dex 了
祭出神器 dex2jar, 一顿操作猛如虎, 然而...

{% asset_img d2j-fail.png d2j-fail %}

大胆猜测是加了壳或者用了什么混淆, 上网查阅发现 dex2jar 已经很久没更新了, 陷入僵局

# 降维打击

直接逆向这条思路是肯定不行了, 得想想别的办法, 脑子里面突然冒出四个字: 历史版本
于是乎, 下载了一堆历史版本, 逐个尝试后终于发现在某个版本是没有给 dex 加壳的
立马脱掉裤子开干, 用 jd 打开 jar 文件, 全局搜索一下, 此时屏幕上已经出现了一点精斑

{% asset_img secret-key.png secret-key %}

拿到密码后就简单了, 启动 charles, 导入 p12 格式证书(Client Certificates), 设置 SSL 白名单(SSL Proxying)
Proxy -> SSL Proxying Settings -> SSL Proxying && Client Certificates

{% asset_img ssl-config.png ssl-config %}
{% asset_img client-cert-config.png client-cert-config %}

在 app 里发一次请求后 charles 提示输入证书的密码, 一顿操作后顺利完成任务, 打完收工

{% asset_img proof.png proof %}

# refs

https://www.secpulse.com/archives/54027.html
https://stackoverflow.com/questions/48959777/how-to-use-applications-client-certificate-with-charles
