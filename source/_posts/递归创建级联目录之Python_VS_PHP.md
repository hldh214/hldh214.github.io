---
title: 递归创建级联目录之Python_VS_PHP
date: 2016-02-10 22:20:57
---
# 引子 #
学习php的商城开发遇到递归创建级联目录问题,在学习了php下面的解决方法后,不禁想用Python来实现一下
# 代码 #
## PHP ##

``` php
<?php 

// PHP5以后的版本内置mkdir函数支持创建级联目录!
echo mkdir($pathname='a/s/d/f/g/h/j/k/l', $mode=0777, $recursive=true);

// 递归创建级联目录两个版本
// 易理解, 语法复杂版本
function mk_dir1($dir) {
	if (is_dir($dir)) {
		return true;
	}
	if (is_dir(dirname($dir))) {
		return mkdir($dir);
	} else {
		mk_dir1(dirname($dir));
		return mkdir($dir);
	}
}

// mk_dir1('a/s/d/f/g/h/j/');

// 难理解, 语法简洁版本
function mk_dir2($dir) {
	if (is_dir($dir)) {
		return true;
	}
	return (is_dir(dirname($dir))) || (mk_dir2(dirname($dir))) ? mkdir($dir) : false;
}

// mk_dir2('aa/ss/dd/ff/gg/hh/jj/');

 ?>
```

## Python ##

``` python
import os
    
# Python的os模块也是有带递归创建级联目录的方法 os.makedirs(name, mode=0o777, exist_ok=False)

def mk_dir(dirname):
    if os.path.isdir(dirname):
        return True
    if os.path.isdir(os.path.dirname(dirname)) or os.path.dirname(dirname) == '':
        return os.mkdir(dirname)
    else:
        mk_dir(os.path.dirname(dirname))
        return os.mkdir(dirname)

mk_dir('1/2/3/5/6/9/8/7')
```

# 比较 #
## 相同点 ##
二者实现思路一样,甚至使用函数都大同小异,另外二者皆有内置函数支持创建级联目录
## 不同点 ##
从判断条件可以发现,php的dirname函数明显优于Python的os.path.dirname方法,后者在参数为单层目录的情况返回空字符串,而php返回表示当前目录的`'.'`,这样导致Python需要多判断一种情况才能实现目标,希望Python后续版本可以借鉴一下php的这种方法~
