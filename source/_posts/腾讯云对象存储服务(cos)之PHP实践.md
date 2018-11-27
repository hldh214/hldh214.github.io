---
title: 腾讯云对象存储服务(cos)之PHP实践
date: 2018-11-21 15:13:00
---
云对象存储服务,  BAT都有其业务, 本文选择腾讯是因为腾讯有每月免费流量, 而阿里和百度都是需要先付费后使用, 另外新兴的像七牛云存储, 也是很不错的解决方案.
贴代码

``` PHP
<?php
/**
 * Simple Tencent COS SDK
 * 2016/05/09
 * Author: hldh214 <hldh214@gmail.com>
 */

// 配置项 start
$appid = '';
$bucket_name = '';
$dir_name = '';
$secretID = '';
$secretKey = '';
// 配置项 end

// 需要存储的资源url, 这里用百度logo来做演示
$pic_url = 'http://www.baidu.com/img/logo.gif';
// 获取文件名
$filename = end(explode('/', $pic_url));
// 构造上传url
$upload_url = "web.file.myqcloud.com/files/v1/$appid/$bucket_name/$dir_name/$filename";
// 设置过期时间
$exp = time() + 3600;
// 构造鉴权key
$sign = "a=$appid&b=$bucket_name&k=$secretID&e=$exp&t=" . time() . '&r=' . rand() . "&f=/$appid/$bucket_name/$dir_name/$filename";
$sign = base64_encode(hash_hmac('SHA1', $sign, $secretKey, true) . $sign);
// 构造post数据
$post_data = [
    'op' => 'upload',
    'filecontent' => file_get_contents($pic_url),  // baidu logo
];
// 设置post的headers, 加入鉴权key
$header = [
    'Content-Type: multipart/form-data',
    'Authorization: ' . $sign,
];
// post
$ch = curl_init($upload_url);
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_HTTPHEADER, $header);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
$res = curl_exec($ch);
curl_close($ch);
$res = json_decode($res, true);
if (isset($res['data']['access_url'])) {
    // 成功, 输出文件url
    echo $res['data']['access_url'];
} else {
    // 失败
    echo $res;
}

```
