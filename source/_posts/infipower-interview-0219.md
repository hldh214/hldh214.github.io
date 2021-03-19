---
title: 你这个态度还找个锤子的工作
date: 2021-03-19 16:47:34
tags:
---

# 引子

今天跟大家分享两道面试遇到的题目, 因为觉得比较有特色, 故写成博客以供后人笑话.
为什么说这两道题比较有特色呢, 主要还是因为在国内这种环境已经很难见到直接 Google 不出来答案的题目了.
而且这两道题难度适中, 连我这样的人都能照着答案抄, 还能看懂答案, 属实不容易.

<!-- more -->

# 题目

## Least wasteful use of stamps to achieve a given postage


> we have 2 kinds of stamp with values $A and $B, The number of stamps is infinite, we have a letter to send out and need $T postage, question is to find out the lowest cost required to get $T postage? Pls describe your method and code it with any language you are good at( even we perfer C/C++ :）。 

> example as below, 

> Input：A B T 
> 1 ≤ A < B ≤ 10e9 
> 1 ≤ T ≤ 10e9 
> A, B, T are integers 

> Output： The lowest value of 2 kinds of stamps combination which should be >= $T

上来就是一道洋文题, 咋一看以为是背包问题, 仔细一看果然是背包问题, 随便在网上搜了个答案抄作业了.

```python
import math

def yet_another_solution(a, b, t):
    n = math.ceil(t / b)
    cost = []
    for i in range(n + 1):
        j = math.ceil((t - i * b) / a)
        cost.append({'cost': i * b + j * a, 'num_of_a': j, 'num_of_b': i})

    cost.sort(key=lambda x: x.get('cost'))

    return cost[0]
```

然后面试官发来追问

> 你好，循环是可以这样做的，那我再追问下， A,　B比较小， T比较大的时候，在小的Embedded设备上耗时比较多，请问有没有好的办法可以加速？

没什么头绪, 继续漫无目的的遨游互联网, 查到一个大学的 [assignment](http://jwilson.coe.uga.edu/emt725/Stamps/TwoStamp.html) 有一题跟这个追问很类似.
果断朝着这个方向继续搜答案, 然后就查到了另一个与之相关的[问题](https://en.wikipedia.org/wiki/Coin_problem).
根据相关资料以及面试官的 **一些点拨** 写出最终代码

```python
import math


def yet_another_solution(a, b, t):
    n = math.ceil(t / b)
    cost = []
    for i in range(n + 1):
        j = math.ceil((t - i * b) / a)

        # fix negative number issue
        if j < 0:
            continue

        cost.append({'cost': i * b + j * a, 'num_of_a': j, 'num_of_b': i})

    cost.sort(key=lambda x: x.get('cost'))

    return cost[0]


def main(a, b, t):
    gcd = math.gcd(a, b)
    is_co_prime = (gcd == 1)

    if is_co_prime:
        mystery_number = a * b - a - b
        if mystery_number < t:
            # Coin problem optimization
            return t
    else:
        if not b % a:
            # A ÷ B ∈ ℤ optimization
            num_of_a = math.ceil(t / a)

            if not t % a:
                return t

            return num_of_a * a

        # A ÷ B ∉ ℤ case
        # @see https://math.stackexchange.com/q/3430648
        mystery_number = ((a * b) / gcd ** 2 - (a + b) / gcd + 1) * gcd

        if mystery_number < t:
            num_of_a = math.ceil(t / gcd)

            if not t % gcd:
                return t

            return num_of_a * gcd

    return yet_another_solution(a, b, t).get('cost')


if __name__ == '__main__':
    print(main(29, 42, 320))
```

## 最多能换几张免费机票

> 你经常做飞机，现持有国航5种Coupon状况如下 
> 种类 A 的 a 张 
> 种类 B 的 b 张 
> 种类 C 的 c 张 
> 种类 D 的 d 张 
> 种类 E 的 e 张 

> 你想换一张免费机票，条件如下 
> 种类 A, B, C 的Coupon各一张 或者 
> 种类 B, C, D 的Coupon各一张 或者 
> 种类 C, D, E 的Coupon各一张 或者 
> 种类 D, E, A 的Coupon各一张 或者 
> 种类 E, A, B 的Coupon各一张 

> 问最多能换几张免费机票？ 
> Input a, b, c, d, e      Output 免费机票数

这题一开始我是完全没思路的, 连 Google 关键字都想不出来, 后面求助万能的网友得到一个答案, 果断抄作业

```python
def greedy(a, b, c, d, e):
    result = 0
    coupons = [a, b, c, d, e]

    def get_max(_x, _y, _z):
        _n = min(_x, _y, _z)

        return _x - _n, _y - _n, _z - _n, _n

    for (x, y, z) in (
            (0, 1, 2),
            (1, 2, 3),
            (2, 3, 4),
            (3, 4, 0),
            (4, 0, 1),
    ):
        coupons[x], coupons[y], coupons[z], n = get_max(coupons[x], coupons[y], coupons[z])
        result += n

    return result
```

大佬不愧是大佬, 这写法一看就是老刷题家了, 提交给面试官, 得到这么个追问

> 面: 你好，看了看，有点问题，你自己能发现吗？
> 我: 可以稍微提示一下吗.
> 面: 试试 全都是10的输入
> 我: 原来如此，我思考一下。

不过此时的我已经是站在巨人的肩膀上了, 面试官也没太为难, 直接给我不通过的 case, 快速写出对应的修复

```python
def yet_another_solution(a, b, c, d, e, result=0):
    coupons = [a, b, c, d, e]
    length = 5
    score_list = []
    for x in range(length):
        y = x + 1 if x + 1 < length else x + 1 - length
        z = y + 1 if y + 1 < length else y + 1 - length

        score_list.append({
            'score': sum((coupons[x], coupons[y], coupons[z])),
            'first': {'index': x, 'value': coupons[x]},
            'second': {'index': y, 'value': coupons[y]},
            'third': {'index': z, 'value': coupons[z]},
        })

    score_list.sort(key=lambda x: x.get('score'), reverse=True)
    top_3_set = score_list[0]

    for each_token in ['first', 'second', 'third']:
        if not top_3_set[each_token]['value']:
            return result
        coupons[top_3_set[each_token]['index']] -= 1

    result += 1
    params = coupons + [result]
    return yet_another_solution(*params)
```

提交给面试官, 得到这么个追问

> 看了下，2个问题，1. 试试 5 5 10 5 10      2. 能不能不用递归改写？

第二个问题是我故意钓鱼, 就等着上钩免得夜长梦多, 至于第一个问题, 也是因为取 `top_3_set` 太暴力了
应该每次都动态判断最优的组合, 而不是直直的取 `[0]`, 快速写出对应的修复

```python
def yet_another_solution_w_o_recursion(a, b, c, d, e):
    coupons = [a, b, c, d, e]
    length = 5
    result = 0

    while True:
        score_list = []

        for x in range(length):
            y = (x + 1) % length
            z = (y + 1) % length

            score_list.append({
                'score': sum((coupons[x], coupons[y], coupons[z])),
                'first': {'index': x, 'value': coupons[x]},
                'second': {'index': y, 'value': coupons[y]},
                'third': {'index': z, 'value': coupons[z]},
            })

        score_list.sort(key=lambda _x: _x.get('score'), reverse=True)

        for index, each_set in enumerate(score_list):
            first_element = each_set['first']
            second_element = each_set['second']
            third_element = each_set['third']

            if 0 in (first_element['value'], second_element['value'], third_element['value']):
                if index == length - 1:
                    return result
                continue

            coupons[each_set['first']['index']] -= 1
            coupons[each_set['second']['index']] -= 1
            coupons[each_set['third']['index']] -= 1

            result += 1

            break
```

这下妥了, 不过面试官也留了一手, 落下这么一句话

> 这个其实有个不用循环的简便方法，不过可能难度稍微有点高
> 一般循环能出来也算可以了

大概猜测应该是某个定理的证明, 后面也没兴趣深究下去...

# 后记

- 你这个态度还找个锤子的工作
- 回家挑大粪吧
- 面个试都这么爱抬杠
- 程序员基本的素养 异想天开 抽象到宇宙
- 面试和工作是两码事
- 所以你完全没必要 说什么你好啥的
- 面试是双向选择 没必要太放低自己的姿态
- leetcode本身就是抽象的 。。 算法就是靠推理验算能力
- 面试一定不能跟面试官抬杠 那就完了
- 而且算法本身就是抽象的 脱离实际的  千万不要说不切实际
- 如果是游戏的场景 就有价值几个亿的邮票呢
- 你争论题目的本质没有意义

# refs

https://gist.github.com/hldh214/0fd4fc4b7b7a61df1e09ad410863555b
