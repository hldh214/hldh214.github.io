---
title: php web 后端开发面试总结 - 1808
date: 2018-11-21 15:56:00
---
# 引子

本文总结了这周面试的两家公司所谓心得体会

# 面试题

 - 使用 php 实现冒泡排序, 对象可以是一个数组, 不能使用 php 内置函数
挺无聊的, 手写算法题, 直接百度
https://stackoverflow.com/a/9001334/6266737
``` php
function bubble_sort($arr) {
    $size = count($arr)-1;
    for ($i=0; $i<$size; $i++) {
        for ($j=0; $j<$size-$i; $j++) {
            $k = $j+1;
            if ($arr[$k] < $arr[$j]) {
                // Swap elements at indices: $j, $k
                list($arr[$j], $arr[$k]) = array($arr[$k], $arr[$j]);
            }
        }
    }
    return $arr;
}
```

 - 使用 php 描述顺序查找和二分查找(也叫作折半查找)算法, 顺序查找必须考虑效率, 对象可以是一个有序数组
又是手写算法, 继续百度
https://gist.github.com/midorikocak/646c59e4042877220ee3a98b371d9c2b
```php
<?php
// This is the text editor interface.
// Anything you type or change here will be seen by the other person in real time. 
$array = [5,4,3,2,1];
function binarySearch(int $value, array $array, int $start, int $end){
    if($end<$start) return;
    
    $middle = floor(($end + $start)/2);
    if($array[$middle]==$value) return true;
    elseif ($array[$middle] > $value) return binarySearch($value, $array, $start, $middle-1);
    else binarySearch($value, $array, $middle+1, $end);
}
$found = binarySearch(9 ,$array, 0, sizeof($array)-1);
if($found) echo "found";
else echo "not found";

```

 - 写出查找发帖数最多的十个人名字的 sql 表结构如下
``` sql
members (id, username, password, post, email)
```
终于来了点好玩的了
```sql
SELECT `username` FROM `members` ORDER BY `post` DESC LIMIT 10;
```
在后来的面试过程中面试官询问如果没有 `post` 字段而是有关联表怎么解决
答曰使用连接查询
追问有什么问题
答曰性能会很差
追问怎么解决
答曰使用本题的方法, 使用冗余字段 `post` 来提高性能

 - 用过哪些 php 开源框架
`Laravel ThinkPHP`

 - http 协议里面通过哪些协议字段来控制缓存
这个当时没仔细思考, 完全是想到什么写什么, 我当时是这样写的
`cache-control; expire-at; vary; ...`
https://developer.mozilla.org/en-US/docs/Web/HTTP/Caching
https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/http-caching?hl=zh-cn

 - 常见的 web 安全问题有哪些
这道题同样只写了我当时想到的:
`SQLi, XSS(XSRF/CSRF)`
https://developer.mozilla.org/en-US/docs/Web/Security

 - 使对象可以像数组一样进行 foreach 循环, 要求属性必须是私有
这道题当时没答上, 随便写了个 __get
http://php.net/manual/zh/language.oop5.iterations.php

 - 请写一段 php 代码, 确保多个进程同时写入同一个文件成功
这道题当时没答上, 随便写了个 lock || 顺序
这是多线程的方案, 大同小异
https://stackoverflow.com/questions/5663229/php-file-write-threading-issues

 - 用 php 实现一个双向链表
这道题当时没答上, 随便写了个 collections.deque 其实也不对, 双向队列 !== 双向链表
http://php.net/manual/zh/class.spldoublylinkedlist.php

 - {% asset_img idiot_interview.jpg idiot_interview %}

这道题才算符合我的胃口, 我回答了 5 点
1. for -> foreach (可读性) 面试官问了性能方面, 没答上
https://stackoverflow.com/questions/3430194/performance-of-for-vs-foreach-in-php
2. 通过 `unique key` 来保证唯一性
3. 参数绑定
4. 图中圈出来的部分有慢查询, 面试官似乎还没意识到这里是有问题的 :P
5. 批量插入, 因为要尽量避免在 `foreach` 里面写 sql

# 面试

基本上都是从面试题谈起, 发现占不到便宜之后又开始问简历的一些东西

 - 做过哪些项目
......
 - 怎么防止 sql 注入
参数绑定 + utf8
 - ......想不起来了, 想起了再补充
