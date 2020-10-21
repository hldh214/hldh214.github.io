---
title: 谁来拯救误提交的敏感信息
date: 2019-03-02 18:37:47
tags:
  - Git
---

# 引子

你搬了一天的砖, 终于提交了最后一行代码, 翻看着你刚写的晦涩难懂的代码, 你的心里居然有一丝得意
夜幕降临, 你点了外卖, 给自己泡了杯淡茶, 望着杯里氤氲着的水汽, 你的思绪飘向了远方......

> 等等

<!-- more -->

你猛地一惊, 仔细的回想着, 发觉自己好像硬编码了账号密码, 并且跟刚才的提交一起推送了
坏了, 你心里想, 但是这有什么呢, 没人无聊到一个个翻 commit 出来看吧
于是你删掉了代码中硬编码的账号密码, 再次提交并推送, 你呷了一口茶, 很快便忘了这事
但是事情真的就这样结束了吗?

# 谁不怕无聊?

电脑这种机器被发明是为了代替人类做一些枯燥重复的事情, 例如加减乘除, 这是众所周知的
还记得上面说到`没人无聊到一个个翻 commit 出来看吧`, 确实没`人`会这么干, 但是`机器`就不一样了
https://github.com/michenriksen/gitrob 这个项目, 有兴趣的小伙伴可以考察考察
正如 README 里面所讲, 他可以用来扫描 git 仓库里面`可能`是敏感信息的内容, 导出为报告
这就有意思了, 没事可以拿来扫一下自己同学呀, 朋友呀, 同事呀等等...

# 那怎么办

这时候就有小朋友要问了, 那现在怎么办呢, 难道要舍弃 commit 记录, 再提交修正的版本重新做人吗
严格来说, 这的确是一种方法, 而且大部分人遇到了首先都会想到这个方法, 简洁明了, 通俗易懂
但是作为 geek 的你, 这种方法是不可接受的, 拒绝

# bfg-repo-cleaner

现在介绍一款专门干这活的利器: https://rtyley.github.io/bfg-repo-cleaner
别看这玩意虽然是 Scala 写的, 要 Jvm 环境才能运行, 但是确确实实是可以解决我们的问题的
首先下载 jar 文件, 按照给出的命令执行, 这里需要事先准备`pwd.txt`文件来存放敏感词, 一行一个即可
```
# 先 clone 一份纯 git database 到本地
C:\Users\hldh214\Downloads>git clone --mirror git@github.com:hldh214/buff2steam.git
Cloning into bare repository 'buff2steam.git'...
remote: Enumerating objects: 127, done.
remote: Counting objects: 100% (127/127), done.
remote: Compressing objects: 100% (82/82), done.
Receiving objects: 100% (127/127), 28.20 KiB | 159.00 KiB/s, done.
Resolving deltas: 100% (62/62), done.
remote: Total 127 (delta 62), reused 75 (delta 32), pack-reused 0

# --replace-text 表示 grep 替换掉敏感词, 当然你也可以用 --delete-files 来毁尸灭迹
C:\Users\hldh214\Downloads>java -jar bfg-1.13.0.jar --replace-text pwd.txt buff2steam.git

Using repo : C:\Users\hldh214\Downloads\buff2steam.git

Found 12 objects to protect
Found 3 commit-pointing refs : HEAD, refs/heads/master, refs/tags/0.0.1

Protected commits
-----------------

These are your protected commits, and so their contents will NOT be altered:

 * commit ba928494 (protected by 'HEAD')

Cleaning
--------

Found 32 commits
Cleaning commits:       100% (32/32)
Cleaning commits completed in 247 ms.

Updating 1 Ref
--------------

        Ref                 Before     After
        ---------------------------------------
        refs/heads/master | ba928494 | c0d9ed49

Updating references:    100% (1/1)
...Ref update completed in 28 ms.

Commit Tree-Dirt History
------------------------

        Earliest                  Latest
        |                              |
        ............................DDDm

        D = dirty commits (file tree fixed)
        m = modified commits (commit message or parents changed)
        . = clean commits (no changes to file tree)

                                Before     After
        -------------------------------------------
        First modified commit | fc4b9763 | 756caa93
        Last dirty commit     | 16e9e3ef | 3740fc1a

Changed files
-------------

        Filename   Before & After
        ------------------------------
        steam.py | 001439f4 ? 90ab2216


In total, 8 object ids were changed. Full details are logged here:

        C:\Users\hldh214\Downloads\buff2steam.git.bfg-report\2019-03-02\17-28-42

BFG run is complete! When ready, run: git reflog expire --expire=now --all && git gc --prune=now --aggressive


--
You can rewrite history in Git - don't let Trump do it for real!
Trump's administration has lied consistently, to make people give up on ever
being told the truth. Don't give up: https://www.rescue.org/topic/refugees-america
--

# 可以看到上面的输出, 作者很贴心的告诉你可以直接 reflog expire && gc 就行了
# 结尾暗藏私货, 举报了:D
C:\Users\hldh214\Downloads>cd buff2steam.git

C:\Users\hldh214\Downloads\buff2steam.git>git reflog expire --expire=now --all && git gc --prune=now --aggressive
Enumerating objects: 127, done.
Counting objects: 100% (127/127), done.
Delta compression using up to 8 threads
Compressing objects: 100% (114/114), done.
Writing objects: 100% (127/127), done.
Total 127 (delta 62), reused 52 (delta 0)

# 打完收工
C:\Users\hldh214\Downloads\buff2steam.git>git push
Enumerating objects: 85, done.
Counting objects: 100% (85/85), done.
Delta compression using up to 8 threads
Compressing objects: 100% (36/36), done.
Writing objects: 100% (80/80), 13.75 KiB | 2.75 MiB/s, done.
Total 80 (delta 41), reused 77 (delta 38)
remote: Resolving deltas: 100% (41/41), completed with 3 local objects.
To github.com:hldh214/buff2steam.git
 + ba92849...c0d9ed4 master -> master (forced update)

C:\Users\hldh214\Downloads\buff2steam.git>
```
一顿操作猛如虎, 再次去查看 commit history 发现, 账号密码等敏感信息都换成了`***REMOVED***`
commit hash 也改了, 在 history 里面已经找不到原来的 commit hash 了
但是手动输入原来的 commit hash 是可以查看原来的版本的, 如果各位看官有兴趣可以来瞧瞧:
raw: https://github.com/hldh214/buff2steam/commit/ba92849489d406f62d9473930185fdb699e02ac3#diff-b935f1a5dc14299393e08e0465a70447L46
fixed: https://github.com/hldh214/buff2steam/commit/c0d9ed498c90303fe265678d6645498b329157d5#diff-b935f1a5dc14299393e08e0465a70447L46

# refs

https://www.bennythink.com/git-password.html
