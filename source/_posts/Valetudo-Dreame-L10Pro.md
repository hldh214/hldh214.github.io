---
title: 别让扫地机器人成为云端奴隶，Valetudo 助你夺回控制权
date: 2023-08-17 11:43:00
tags:
  - HomeAutomation
---

# 引子
我在今年早些时候在二手网站上淘了一台 Dreame L10Pro, 我当时也是因为 Valetudo 这个项目, 想说买台机器回来刷刷看, 收到扫地机器人后, 我满怀期待的根据文档, 尝试获取 root 权限. 但很可惜因为是二手商品, 前一任用户已经把固件升级到新版本了, 在那个时候还没有公开最新版本固件的 root 方法, 所以只能作罢.

# 但是

<!-- more -->

当时因为有一些 root 方式是未公开的, 但需要自己联系 Valetudo 项目组获取具体内容, 但进展不顺利. 我直到最近新的 root 方法公开后我才明白是因为需要一些线下的实体工具辅助配合才能实现, 而 Valetudo 项目组主要在欧洲区域活跃, 自然对亚细亚的孤儿爱莫能助. 但现在既然已经公开了 root 的方法. 我便继续开始研究如何给我的机器也安排安排.

# 深入研究

其实我一开始并不知道新的 root 方法是跟随着 DEFCON 31 一起公开的, 我只是日常浏览群组消息, 看到怎么最近几天 Valetudo 用户组聊的热火朝天, 才知道是有新的 root 方法公开了. 遂大兴奋, 深入研究之, 发现其实改动并不大, 我这款 Dreame L10Pro 在旧版固件是通过 UART 线连接电脑, 通过串口通信进入 shell, 那时遇到的问题是 shell spawn 不出来, 因为新版固件修复封堵了这个后门. 但是新方法则是, 同样接上串口线, 同时接上之前没有用到的 USB OTG 线, 新固件会检测如果有 USB 设备接入, 则会 spawn 出一个 shell(并且还会把 rootfs 挂载上去, 不过这个并不重要, 我们只需要 shell).

大概理解了原理之后就开始研究细节, 首先我得准备一根 USB 母口的线, 以及一根 U 盘. 杜邦线跟串口芯片啥的家里都有就不再需要准备. 就近在楼下百元店购买了一根 USB 延长线跟 U 盘.

![U盘好贵阿](usb.jpg)

现在万事俱备只欠东风, 赶紧回家开干. 首先需要处理一下 USB 线, 给接上杜邦头, 这里因为懒得动电烙铁, 直接用鳄鱼夹之类的工具帮忙固定住, 用万用表确认每个引脚均接通且互相无短路, 准备正式上机开刷.

![这几根调试线还是以前买示波器送的](cabling.jpg)

然后就是 USB 转串口这边了, 因为家里没有专门的 UART 转接器, 索性拿了一块 esp32 临时用用, esp32-devkit 是自带 USB 转串口芯片的, 这里只需要把 esp32 的 EN 脚接地, 让他不工作, 我们只需要使用他的外围电路.

![esp](esp32.jpg)

最后就是根据文档给出的转接卡的 PCB 设计图推导出我们的接线. 其中我们需要接的引脚有:

 - TX -> TX (这里根据情况可能需要跟 RX 对调, 因为我用的是 esp32-devkit 上面的电路)
 - RX -> RX
 - GND -> GND (这里只接了一根地线, 因为其他部分均在面包板上完成共地)
 - USB_OTG_ID -> GND (这根线直接引出来到面包板的公共地)
 - D+ -> D+ (下面三个都是 USB 线, 没啥特别的)
 - D- -> D-
 - VBUS -> VBUS

![Credit to Valetudo](pcb.png)

最终的样子, 以及顺利获取到 root 权限.

![这 MOTD 居然是中文的一刚](root.jpg)

拿到 root 权限后的事情就简单了, 稍微备份一下原有数据, 直接刷入 Valetudo, 完美脱离云, 实现纯本地化控制.

![Brave New World](brave_new_world.jpg)

# Refs

https://web.archive.org/web/20230131072513/https://valetudo.cloud/pages/installation/dreame.html
https://robotinfo.dev/detail_dreame.vacuum.p2029_0.html
https://chaos.social/@fizzo/110887346585058373
https://medium.com/@shelladdicted/how-to-use-an-esp32-devkit-as-an-uart-adapter-e698594e0378