---
title: Git 强大的二分 debug 功能 - git bisect
date: 2018-11-21 15:36:00
---
ref : http://www.qlcoder.com/task/76a4

``` bash

Jim@hldh214 MINGW64 /c/tmp (master)
$ git bisect start

Jim@hldh214 MINGW64 /c/tmp (master|BISECTING)
$ git bisect bad

Jim@hldh214 MINGW64 /c/tmp (master|BISECTING)
$ git bisect good 88dccd
Bisecting: 4999 revisions left to test after this (roughly 12 steps)
[fe60a0750aa9eee702e486fd7a0d3601c894f255] add function

Jim@hldh214 MINGW64 /c/tmp ((fe60a07...)|BISECTING)
$ python unit.py
.
----------------------------------------------------------------------
Ran 1 test in 0.033s

OK

Jim@hldh214 MINGW64 /c/tmp ((fe60a07...)|BISECTING)
$ git bisect good
Bisecting: 2499 revisions left to test after this (roughly 11 steps)
[6669dbbf6b0c14d90d9f736082b10db6a68c3d1a] add function

Jim@hldh214 MINGW64 /c/tmp ((6669dbb...)|BISECTING)
$ python unit.py
F
======================================================================
FAIL: test (__main__.mytest)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "unit.py", line 9, in test
    self.assertEqual(source.f_51106f2(1,2,3,4,5,6,7,8,9,10),8,'fail')
AssertionError: 7 != 8 : fail

----------------------------------------------------------------------
Ran 1 test in 0.034s

FAILED (failures=1)

Jim@hldh214 MINGW64 /c/tmp ((6669dbb...)|BISECTING)
$ git bisect bad
Bisecting: 1249 revisions left to test after this (roughly 10 steps)
[3bc8fc0589d140b21e96139ff751aba05000fd4d] add function

Jim@hldh214 MINGW64 /c/tmp ((3bc8fc0...)|BISECTING)
$ python unit.py
.
----------------------------------------------------------------------
Ran 1 test in 0.008s

OK

Jim@hldh214 MINGW64 /c/tmp ((3bc8fc0...)|BISECTING)
$ git bisect good
Bisecting: 624 revisions left to test after this (roughly 9 steps)
[512ef6cb4a8583752bf9077ab0ff8501f6dc43f0] add function

Jim@hldh214 MINGW64 /c/tmp ((512ef6c...)|BISECTING)
$ python unit.py
F
======================================================================
FAIL: test (__main__.mytest)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "unit.py", line 9, in test
    self.assertEqual(source.f_48fa148(1,2,3,4,5,6,7,8,9,10),6,'fail')
AssertionError: 5 != 6 : fail

----------------------------------------------------------------------
Ran 1 test in 0.008s

FAILED (failures=1)

Jim@hldh214 MINGW64 /c/tmp ((512ef6c...)|BISECTING)
$ git bisect bad
Bisecting: 312 revisions left to test after this (roughly 8 steps)
[2bf1a99f136e12fb91290c2cc3942a09f34c0549] add function

Jim@hldh214 MINGW64 /c/tmp ((2bf1a99...)|BISECTING)
$ python unit.py
F
======================================================================
FAIL: test (__main__.mytest)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "unit.py", line 9, in test
    self.assertEqual(source.f_2f64d32(1,2),4,'fail')
AssertionError: 3 != 4 : fail

----------------------------------------------------------------------
Ran 1 test in 0.001s

FAILED (failures=1)

Jim@hldh214 MINGW64 /c/tmp ((2bf1a99...)|BISECTING)
$ git bisect bad
Bisecting: 155 revisions left to test after this (roughly 7 steps)
[688a5d8dddf77e63ee2a712da6cc7c69ef5bc5f1] add function

Jim@hldh214 MINGW64 /c/tmp ((688a5d8...)|BISECTING)
$ python unit.py
.
----------------------------------------------------------------------
Ran 1 test in 0.005s

OK

Jim@hldh214 MINGW64 /c/tmp ((688a5d8...)|BISECTING)
$ git bisect good
Bisecting: 77 revisions left to test after this (roughly 6 steps)
[60d633cb6a38961efa13d45d50308aa9707cd8df] add function

Jim@hldh214 MINGW64 /c/tmp ((60d633c...)|BISECTING)
$ python unit.py
.
----------------------------------------------------------------------
Ran 1 test in 0.000s

OK

Jim@hldh214 MINGW64 /c/tmp ((60d633c...)|BISECTING)
$ git bisect good
Bisecting: 38 revisions left to test after this (roughly 5 steps)
[ffeb2daf978ee5a0b7fef8df74acab15ee414152] add function

Jim@hldh214 MINGW64 /c/tmp ((ffeb2da...)|BISECTING)
$ python unit.py
.
----------------------------------------------------------------------
Ran 1 test in 0.015s

OK

Jim@hldh214 MINGW64 /c/tmp ((ffeb2da...)|BISECTING)
$ git bisect good
Bisecting: 19 revisions left to test after this (roughly 4 steps)
[6af5fb9f8f253a325f4c0bc52f7e6d43c92e34ce] add function

Jim@hldh214 MINGW64 /c/tmp ((6af5fb9...)|BISECTING)
$ python unit.py
.
----------------------------------------------------------------------
Ran 1 test in 0.004s

OK

Jim@hldh214 MINGW64 /c/tmp ((6af5fb9...)|BISECTING)
$ git bisect good
Bisecting: 9 revisions left to test after this (roughly 3 steps)
[0bfd35fa952c21734dee652e4e6ed59c398f7823] add function

Jim@hldh214 MINGW64 /c/tmp ((0bfd35f...)|BISECTING)
$ python unit.py
F
======================================================================
FAIL: test (__main__.mytest)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "unit.py", line 9, in test
    self.assertEqual(source.f_3107b9d(1),6,'fail')
AssertionError: 5 != 6 : fail

----------------------------------------------------------------------
Ran 1 test in 0.016s

FAILED (failures=1)

Jim@hldh214 MINGW64 /c/tmp ((0bfd35f...)|BISECTING)
$ git bisect bad
Bisecting: 4 revisions left to test after this (roughly 2 steps)
[3faa7a1e591c3d103459a521735e95f8459768fe] add function

Jim@hldh214 MINGW64 /c/tmp ((3faa7a1...)|BISECTING)
$ python unit.py
.
----------------------------------------------------------------------
Ran 1 test in 0.013s

OK

Jim@hldh214 MINGW64 /c/tmp ((3faa7a1...)|BISECTING)
$ git bisect good
Bisecting: 2 revisions left to test after this (roughly 1 step)
[8984e491dc6fb5b59a9910fb624e5edbfcaf66d9] add function

Jim@hldh214 MINGW64 /c/tmp ((8984e49...)|BISECTING)
$ python unit.py
F
======================================================================
FAIL: test (__main__.mytest)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "unit.py", line 9, in test
    self.assertEqual(source.f_9dcb7(1,2),5,'fail')
AssertionError: 4 != 5 : fail

----------------------------------------------------------------------
Ran 1 test in 0.020s

FAILED (failures=1)

Jim@hldh214 MINGW64 /c/tmp ((8984e49...)|BISECTING)
$ git bisect bad
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[ceae71a5ae10d3c23c8c6b522d77e57436572521] add function

Jim@hldh214 MINGW64 /c/tmp ((ceae71a...)|BISECTING)
$ python unit.py
F
======================================================================
FAIL: test (__main__.mytest)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "unit.py", line 9, in test
    self.assertEqual(source.f_2204f42(1,2,3,4),1,'fail')
AssertionError: 0 != 1 : fail

----------------------------------------------------------------------
Ran 1 test in 0.008s

FAILED (failures=1)

Jim@hldh214 MINGW64 /c/tmp ((ceae71a...)|BISECTING)
$ git bisect bad
ceae71a5ae10d3c23c8c6b522d77e57436572521 is the first bad commit
commit ceae71a5ae10d3c23c8c6b522d77e57436572521
Author: JianJinYi <JianJinYi@qlcoder.com>
Date:   Thu May 19 23:27:17 2016 +0800

    add function

:100644 100644 09b2cfed1cc15cb8ed82f42d6e5b229cfcee9fdc b98cfbf94195e411fad52e6fcebe17889d787656 M      source.py
:100644 100644 29605e0f326cf1f9896c8712404e9055fefe9524 a4123398ca1a55abb251c154c1f8b50a48d2ba23 M      unit.py

Jim@hldh214 MINGW64 /c/tmp ((ceae71a...)|BISECTING)
$


```


git bisect 使用二分查找算法

可以快速找到很久之前的 commit 里面的 bug
