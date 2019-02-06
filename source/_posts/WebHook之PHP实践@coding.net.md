---
title: WebHook之PHP实践@coding.net
date: 2016-05-09 11:51:50
---
每次写完代码, 打开FileZilla, 把写好的文件上传到vps上, 久而久之觉得腻烦, 寻思有没有更geek的方法, 便有此文.
WebHook是跟随着Git而兴起的技术, 当你push到服务器的时候, 服务器会发送一个特殊的请求到你指定的url上, 而我们可以使用脚本语言来获取这个请求并且在vps端执行git pull来达到自动部署的目的, 老规矩先贴代码:

``` PHP
<?php
/**
 * Simple Git WebHook SDK
 *
 * @coding.net
 * 2016/05/09
 * Author: hldh214 <hldh214@gmail.com>
 */

// 配置项 start
$git_dir = '/var/www/.git';
$work_tree = '/var/www';
// 配置项 end

// 获取原始请求
$hook_log = file_get_contents('php://input');
// 使用MySQL记录log
$fh = mysqli_connect('localhost', 'root', 'root', 'git');
// 判断是否为WebHook请求
if (!empty($hook_log)) {
    // 是WebHook请求, 并decode数据
    $json = json_decode($hook_log, true);
    if (array_key_exists('ref', $json)) {
        // 检测到ref键, 执行pull
        $cmd = "/usr/bin/sudo git --git-dir=$git_dir --work-tree=$work_tree pull  2>&1";
        $sh_log = shell_exec($cmd);
        $sql = "INSERT INTO `webhook_log` (`hook_log`, `sh_log`, `date`) VALUES ('" . $hook_log . "', '" . $sh_log . "', CURRENT_DATE());";
        // 记录执行log
        $result = mysqli_query($fh, $sql);
    } else {
        // 未检测到ref键, 为测试请求
        $sh_log = 'testing';
        $sql = "INSERT INTO `webhook_log` (`hook_log`, `sh_log`, `date`) VALUES ('" . $hook_log . "', '" . $sh_log . "', CURRENT_DATE());";
        $result = mysqli_query($fh, $sql);
    }
} else {
    // 正常访问
    echo '<h1>normal view~</h1>';
}
```

把这段代码用FileZilla上传到vps上(最后一次使用FileZilla了<3), 把指向这个php文件的url填写到WebHook页面的deploy_url里面, 并且点击测试, 之后回到vps上查看MySQL是否已经有log, 再在开发机试试commit&push, 你会发现, 代码已经悄然部署到vps上了.
