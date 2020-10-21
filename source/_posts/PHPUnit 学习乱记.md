---
title: PHPUnit 学习乱记
date: 2016-08-28 21:00:12
---
# 引子 #

本篇记录 PHPUnit 学习点滴

# 正文 #

## 安装 ##

	wget https://phar.phpunit.de/phpunit.phar

直接下载 phar 包就能直接用了

<!-- more -->

## 第一个例子 ##

直接照搬官网的例子

```
<?php
// test.php
class StackTest extends PHPUnit_Framework_TestCase
{
    public function testPushAndPop()
    {
        $stack = [];
        $this->assertEquals(0, count($stack));

        array_push($stack, 'foo');
        $this->assertEquals('foo', $stack[count($stack) - 1]);
        $this->assertEquals(1, count($stack));

        $this->assertEquals('foo', array_pop($stack));
        $this->assertEquals(0, count($stack));
    }
}

```

运行一下~

```
$ ./phpunit html/test.php
PHPUnit 5.5.4 by Sebastian Bergmann and contributors.

.                                                                   1 / 1 (100%)

Time: 194 ms, Memory: 8.50MB

OK (1 test, 5 assertions)

```

## 字符指示 ##

注意到上面的例子运行结果中的 `.` 吗, 这是返回结果的字符指示, 详情如下

```
.
当测试成功时输出

F
当测试方法运行过程中一个断言失败时输出

E
当测试方法运行过程中产生一个错误时输出

R
当测试被标记为有风险时输出

S
当测试被跳过时输出

I
当测试被标记为不完整或未实现时输出
```

# 参考资料 #

http://www.phpunit.cn/manual/current/zh_cn/index.html
