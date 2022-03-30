---
title: Buildroot 2018.02 升级 2022.02 小记
date: 2022-03-30 14:50:37
tags: Linux
---

# 引子

由于公司业务需要, 开始接触嵌入式开发, 老大给安排了一个升级 buildroot 版本的任务, 谨以此文记录升级过程中遇到的一些有趣的事情.

<!-- more -->

# 手动添加被官方移除的包

两个版本前后相隔四年, 软件行业发生了翻天覆地的变化, 更何况 19 年之后因为肺炎增加了更多不可预知的因素, 大量开源项目因为各种原因停止维护, 比如 [wiringpi](http://lists.busybox.net/pipermail/buildroot/2020-May/283413.html) 便是其中之一, 因此 buildroot 也将其从中移除, 那么我们在升级的时候肯定不希望影响现有功能, 那么就得手动把被移除的包加回来.

首先在 `external` 目录下新建 `custom_wiringpi` 目录(这里为了避免混淆, 添加了 `custom_` 前缀)

```
./package
./package/Config.in
./package/custom_wiringpi
./package/custom_wiringpi/wiringpi.mk
./package/custom_wiringpi/Config.in
```

接着调整 `wiringpi.mk` 跟 `Config.in` 文件里面的变量名称, 统统追加上述前缀, 以绕过 buildroot 的 legacy 检测:

```
CUSTOM_WIRINGPI_VERSION = 20210904
CUSTOM_WIRINGPI_SOURCE = 7f8fe26e4f775abfced43c07657a353f03ddb2d0.zip
CUSTOM_WIRINGPI_SITE = https://github.com/WiringPi/WiringPi/archive/

define CUSTOM_WIRINGPI_BUILD_CMDS
        sh build
endef

// ...

$(eval $(generic-package))  // 别忘了写这个
```

最后在最外层 `Config.in` 里加上菜单入口

```
menu "WiringPI"
    source "$BR2_EXTERNAL_PATH/package/custom_wiringpi/Config.in"
endmenu
```

尝试编译一下, 大功告成

```
make BR2_EXTERNAL=$PWD/br2-external -C buildroot custom_wiringpi
```

# 注意一些库升级后的变化

## checking for SSL_library_init in -lssl... no

这个坑踩的相当踏实, 前后纠结了一周多才找到问题所在, 一开始以为是 `libssl` 的 so 文件路径不对, 各种排查后发现路径没问题, 当时参考了 [这个](https://stackoverflow.com/questions/335928/ld-cannot-find-an-existing-library) 排查了很久, 后来实在没辙了跑去看这个包的 autoconf 文件, 发现是使用了 `AC_CHECK_LIB` 宏, 顺便恶补了一下相关的知识, 涉事代码如下:

```
AC_CHECK_LIB([ssl],[SSL_library_init], [], [AC_MSG_ERROR([OpenSSL libraries required])])
```

这个宏接受四个参数:

- 第一个参数是库的名称
- 第二个参数是需要用到的库的方法, 一般选一个填上就可以了, 因为只要一个方法存在, 可以认为整个库是正常工作的(伏笔)
- 第三个参数是如果 check pass 则做什么操作, 这里不需要额外操作则传空
- 第四个参数是如果 check failed 则做什么操作, 这里直接调用另一个宏提示错误信息并退出

乍一看也没什么问题, 因为这段代码在 2018.02 版本的 buildroot 是可以正常检测通过的, 尝试用 nm 看一下 .so 文件

```
$ nm -D buildroot/output/host/lib/libssl.so | grep SSL_library_init
$
```

立刻发现问题, 原来新版的 openssl 移除了 `SSL_library_init` 这个方法, 方法不存在, 上面的宏自然会提示找不到.
问题定位到了, 解决也很简单, 调整 `AC_CHECK_LIB` 宏第二个参数, 找一个新版存在的方法填上, 重新编译即解决问题.


# refs

https://stackoverflow.com/questions/69056707/how-to-add-an-out-of-tree-package-to-buildroot
https://blog.csdn.net/SUKHOI27SMK/article/details/19418421
https://blog.csdn.net/stpeace/article/details/47089585
