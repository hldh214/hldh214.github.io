---
title: PHP检测url重定向的最终地址
date: 2018-11-21 15:18:00
---
# 引言 #

客户需求, 需要判断一个url跳转后的url是否是目标url, 于是有此文, 惯例先贴代码.

# 代码 #

``` php
/**
 * 递归检测url重定向地址, 直到重定向到rule所指地址
 * 返回该地址
 *
 * @param string $url 待检测的地址
 * @param string $rule 匹配的地址
 * @return mixed
 */
function redirect($url, $rule = 'https://www.google.com/')
{
    $header = get_headers($url, 1);
    //print_r($header);
    if (strpos($header[0], '301') !== false || strpos($header[0], '302') !== false) {
        // 检测到跳转
        if (array_key_exists('Set-Cookie', $header)) {
            // 检测到cookie, 进行设置
            $cookies = $header['Set-Cookie'];
            foreach ($cookies as $k => $v) {
                header('Set-Cookie: ' . $v);
            }
        }
        if (array_key_exists('Location', $header)) {
            $url = $header['Location'];
            if (is_array($url)) {
                foreach ($url as $k => $v) {
                    if (strpos($v, $rule) !== false) {
                        // 跳转地址与$rule匹配, 返回该地址
                        return $v;
                    } else {
                        // 不匹配则访问一次中转网址
                        file_get_contents($v);
                    }
                }
            } else {
                if (strpos($url, $rule) !== false) {
                    // 跳转地址与$rule匹配, 返回该地址
                    return $url;
                }
            }
        }
    }
    return false;
}
```

# 小结 #

核心函数`get_headers()`
其余的就是常规的字符串判断函数.
