---
title: Linuxbrew 初体验
date: 2019-01-20 13:15:24
tags: Linux
---

# 引子

{% img https://brew.sh/assets/img/linuxbrew.png linuxbrew %}

用腻了传统包管理(apt, yum, ...), 受够了他们的远古版本, 各种参差不齐的第三方源, 逼死强迫症的卸载残留......
在[基友](https://fyibmsd.github.io)的推荐下尝试了 linuxbrew, 本文记录了 linuxbrew 从入门到~~放弃~~

<!-- more -->

# 安装 && 使用

其实按照[官网](https://linuxbrew.sh)安装就可以了, 这里主要讲一下遇到的问题和解决方案

 - passwd
像 aws, gce 这样的 IDC 给你创建的 vps 都是强制要求使用 ssh 公钥登录
在 sudo 的时候总是会有各种问题, 比如装 Oh My Zsh 的时候, 脚本会帮你执行 `chsh` 去替换默认 shell
但是这个命令是需要 root 权限的, 然后因为默认情况当前用户是没有设置密码的
没有条件创造条件: `sudo passwd ubuntu`

 - [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh#basic-installation)
首先用 apt 装一下 zsh, 接着一键脚本装一下 framework, 自然的想到 brew 的自动补全功能
其实 linuxbrew 已经帮我们集成了 zsh 的自动补全脚本, 但由于鲁棒性考虑并没有集成进 installer 里面, 咱们给安排一下
另外需要注意的是, 需要手动添加 `brew shellenv` 内容至 `~/.zshrc` 文件
```bash
# vim ~/.zshrc
# NOTE:
# this must be done before
# source $ZSH/oh-my-zsh.sh
# or forcibly rebuild zcompdump by
# rm -f ~/.zcompdump; compinit
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi
```

 - GCC
不知道为啥, brew 装的 gcc 总是搞不定 env 这一关, 无奈只能再次屈服 apt 淫威 `sudo apt install gcc make`

 - Openresty
openresty 官方的 Homebrew 仓库年久失修, 所以我们采用社区小伙伴自制的仓库
```
brew tap denji/nginx
brew install nginx-full --with-echo-module
```

# Sadness
linuxbrew 有一个致命缺点是, 他并没有实现 `brew services` 功能
所以就这一点来说还是不如传统的诸如 systemctl 这类生态
需要配合 supervisor 或者类似的进程守护方案来实现进程管理

# refs

https://linuxbrew.sh/
https://github.com/Linuxbrew/brew/blob/master/docs/Shell-Completion.md#configuring-completions-in-zsh
https://github.com/robbyrussell/oh-my-zsh#basic-installation
https://github.com/denji/homebrew-nginx#how-do-i-install-these-formule-nginx-modules
https://github.com/Linuxbrew/brew/issues/300
