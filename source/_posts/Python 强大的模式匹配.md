---
title: Python 强大的模式匹配
date: 2016-11-09 16:11:40
---
一些很 sb 的正则需求, 对子模式要求苛刻
不同情况的子模式顺序不同
这就要用到命名的子模式了
``` Python
import re

regex = re.match(r'(?P<first>\d+)qwe(?P<last>\d+)', '123qwe321')

print(regex.group(1))
print(regex.group('first'))
print(regex.group(2))
print(regex.group('last'))

```


``` shell
C:\Python34\python.exe E:/python/tmp.py
123
123
321
321

Process finished with exit code 0

```
