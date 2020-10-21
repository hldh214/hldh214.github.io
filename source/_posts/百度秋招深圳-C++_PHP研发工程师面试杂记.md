---
title: 百度秋招深圳-C++_PHP研发工程师面试杂记
date: 2018-09-20 09:44:35
---
# 引子

2018/09/19 晴 
我参加了百度秋招面试, 期望方向是 PHP 研发
面试地点在广东省深圳市百度国际大厦, 粗略估计了一下我那一场的面试大概有 15~20 来人参加
https://youtu.be/nXT_wz5Gcq4

<!-- more -->

{% asset_img no_photography.jpg no_photography %}

# 面试

## 流程

到场直接被安排在旁边坐下等候通知, 过了一会就有工作人员带路去面试场地
由于深圳百度是新建的大楼, 可能没有完全启用, 本次面试被安排在 14 楼食堂层
所有人都在一个大场地里, 就像高考一样分开做好面试, 挺刺激的 xD
面试了两轮, 面完二面后被告知先去等候区等候, 一会工作人员过来通知可以离场了

## 一面 (~ 45 min)

 - cookie 和 session 的异同
    [简单题, 一顿口水喷之](https://stackoverflow.com/questions/6339783/what-is-the-difference-between-sessions-and-cookies-in-php)
 - MyISAM 和 InnoDB 的区别
    [又一道简单题, 答了事务和聚簇/非聚簇索引](https://stackoverflow.com/questions/20148/myisam-versus-innodb)
 - [largest-number](https://leetcode.com/problems/largest-number/description/)
    没答上, 基本操作
 - 计算 NGINX 的 access.log 给定 ip 的访问量
    `cat access.log | grep xx.xx.xx.xx | wc -l`
    [其实我不会, 随便答的](https://www.jianshu.com/p/537a0bddda94)
 - ls 近一周的文件
    没答上, 我当时在想 ls | grep | 什么鬼的, 后来面试官提示说 ls 有现成的参数符合需求
    [其实还是要用 tail 的嘛~](https://stackoverflow.com/questions/15691359/how-can-i-list-ls-the-5-last-modified-files-in-a-directory)

## 二面 (~ 35 min)

 - HTTP Code 200 302 304 403 的含义
    [很新颖的题, 我喜欢, 一开始差点没想起来 304, 秀逗了](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Status)
 - php 有哪些魔术方法
构造/析构, __get/__set 当时只答对了这些
http://php.net/manual/zh/language.oop5.magic.php
 - HTTP POST 和 GET 的区别
    [口水题, 只答了长度限制和跨域](https://www.w3schools.com/tags/ref_httpmethods.asp)

|                             | GET                                                                                                                                           | POST                                                                                                           |
|:---------------------------:|-----------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------|
| BACK button/Reload          | Harmless                                                                                                                                      | Data will be re-submitted (the browser should alert the user that the data are about to be re-submitted)       |
| Bookmarked                  | Can be bookmarked                                                                                                                             | Cannot be bookmarked                                                                                           |
| Cached                      | Can be cached                                                                                                                                 | Not cached                                                                                                     |
| Encoding type               | application/x-www-form-urlencoded                                                                                                             | application/x-www-form-urlencoded or multipart/form-data. Use multipart encoding for binary data               |
| History                     | Parameters remain in browser history                                                                                                          | Parameters are not saved in browser history                                                                    |
| Restrictions on data length | Yes, when sending data, the GET method adds the data to the URL; and the length of a URL is limited (maximum URL length is 2048 characters)   | No restrictions                                                                                                |
| Restrictions on data type   | Only ASCII characters allowed                                                                                                                 | No restrictions. Binary data is also allowed                                                                   |
| Security                    | GET is less secure compared to POST because data sent is part of the URL Never use GET when sending passwords or other sensitive information! | POST is a little safer than GET because the parameters are not stored in browser history or in web server logs |
| Visibility                  | Data is visible to everyone in the URL                                                                                                        | Data is not displayed in the URL                                                                               |

 - 怎么遍历树
    [动真格了, 凉凉, 没答上](https://zh.wikipedia.org/wiki/%E6%A0%91%E7%9A%84%E9%81%8D%E5%8E%86)
 - 怎么抓包 (fiddler) HTTPS 怎么办
    终于问到老本行了, 抓 HTTPS 给客户端装自签名证书, 顺便提了下代理抓包(Android)
 - 怎么优化 SQL (explain) MySQL 优化有哪些手段
    稍微有点含金量的口水题, 我答了合理索引, 冗余字段, 缓存
    面试官听完接着问还有吗, [当然有啊](https://www.xaprb.com/about/)
 - 一个网页 从输入网址到页面打开 发生了什么
    [没意思, 只答上了一些应用层的知识, 费力不讨好](https://github.com/alex/what-happens-when/blob/master/README.rst)
 - Consistent Hashing
[没答上, 尴尬](https://zh.wikipedia.org/wiki/%E4%B8%80%E8%87%B4%E5%93%88%E5%B8%8C)
 - n 个数找出现次数大于 n/2 次的
[没答上, 尴尬++](https://leetcode.com/problems/majority-element/)

```python
from collections import Counter


class Solution:
    def majorityElement(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        return Counter(nums).most_common()[0][0]

```

 - 1000亿个数找出最大的 100 个数
没答上, 说了下思路也不知道面试官怎么想
https://stackoverflow.com/questions/19227698/write-a-program-to-find-100-largest-numbers-out-of-an-array-of-1-billion-numbers
https://code.i-harness.com/en/q/1256432
> If this is asked in an interview, I think the interviewer probably
> wants to see your problem solving process, not just your knowledge of
> algorithms.
> 
> The description is quite general so maybe you can ask him the range or
> meaning of these numbers to make the problem clear. Doing this may
> impress an interviewer. If, for example, these numbers stands for
> people's age of within a country (e.g. China),then it's a much easier
> problem. With a reasonable assumption that nobody alive is older than
> 200, you can use an int array of size 200(maybe 201) to count the
> number of people with the same age in just one iteration. Here the
> index means the age. After this it's a piece of cake to find 100
> largest number. By the way this algo is called counting sort.
> 
> Anyway, making the question more specific and clearer is good for you
> in an interview.
 - 13 balls puzzle
没答上, 面试官当面给了提示也没答上, 后来查了正确答案也不知道当时的提示是什么意思
当时面试官提示可以 4 4 4 4 1 分组进行比较, 总而言之, 尴尬
https://zhidao.baidu.com/question/424665489778921252.html

# 后记

说实话笔试做的挺烂的, 因为不允许跳出网页用本地 IDE
又只能用 php 导致我很多函数不记得, 书到用时方恨少了
还是被传唤去面试, 没想到一面就是一下午, 当时还担心简历带的不够
后来面完二面我简历刚好用完的时候把我赶走了, 也算是不幸中的万幸??????
问了下二面面试官目前 php 在百度的发展, 答曰需求不大, 多为老项目维护
也难怪岗位名称大家都喊斜杠前面的而忽略掉斜杠后面的 :P
