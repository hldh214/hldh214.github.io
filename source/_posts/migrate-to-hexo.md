---
title: migrate-to-hexo
date: 2018-11-21 17:35:39
tags:
---

# 引子
各种原因, 历经千辛万苦, 本博客从 CSDN 迁移到了 GitHub pages
在 node 和 hexo 的加持下获得重生(以前的博文时间暂时对不上就是了:P)
本文记录了迁移过程遇到的一些问题和解决方案

# 坑
首先去各种搜索前辈们的搭建教学, 一顿操作后顺利输出 hello world
然后想着怎么去迁移 CSDN 的博客
在网上也找了很多方案, 基本上都是从前端采集 + 解析 这种方案
其实 CSDN 后台是有提供直接导出 md 格式的功能的, 只是要一篇一篇文章的点
好在我的文章并不多, 十分的惊险
一顿操作导出了所有 57 篇博文, 接下来就只剩下插入 hexo 的 metadata 了
首先想到 Python, 毕竟脚本小子, 被 Python 宠坏了, 不废话直接上代码
```python
import os


def sorted_ls(path):
    mtime = lambda f: os.stat(os.path.join(path, f)).st_mtime
    return list(sorted(os.listdir(path), key=mtime))


ls = sorted_ls('./blogs')
os.chdir('./blogs')
for index, each in enumerate(ls):
    tmp = []
    with open(each, 'r+', encoding='utf8') as fp:
        for line in fp:
            tmp.append(line)
        tmp.insert(0, '---\ntitle: {0}\ndate: 2018-11-21 15:{1}:00\n---\n'.format(
            each.split('.md')[0],
            59 - index
        ))
        fp.seek(0)
        fp.truncate()
        for line in tmp:
            fp.write(line)

```
其中 `sorted_ls` 函数用于把所有博文按照创建时间排序以便生成顺序的 metadata
然后上传 hexo 预览, 发现文件头部有一些奇怪的东西 `\xEF\xBB\xBF`
又是一顿搜索发现是 [Byte_order_mark](https://en.wikipedia.org/wiki/Byte_order_mark) 这玩意
是 Windows 的锅, 解决方案也给出了, ref: https://my.oschina.net/u/264186/blog/602088
```sh
#!/bin/sh

filelist=$(ls)
echo "all file"
for file in $filelist
do
        echo $file
    #if [ -d $file ]
    #then
        #tar -cf $file.tar $file
    grep -I -r -l $'\xEF\xBB\xBF'  $file | xargs sed  -i  's/\xEF\xBB\xBF//'
                #echo $file
    #fi
done
```
其实 shell 这块我可以说是一窍不通, 也就只能随便搞搞, 能用就行的那种
运行之后发现博文的文件名带有空格, 会出现解析错误导致取不到正确的文件名
再次一顿操作, 直播学 shell, xargs 后再次搞起
```sh
#!/bin/sh

filelist=$(ls)
for file in *
do
    grep -I -r -l $'\xEF\xBB\xBF' "${file}" | xargs -d '\n' sed -i 's/\xEF\xBB\xBF//'
done
```
其实就是注意了一下引号和 `xargs` 的 `-d` 参数即可
最后就是激动人心的 `deploy` 了, 完事

# 后记
下班
