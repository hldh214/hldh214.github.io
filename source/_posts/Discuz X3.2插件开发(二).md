---
title: Discuz X3.2插件开发(二)
date: 2016-05-21 17:38:15
---
# 引言 #

dz默认的邀请码功能不是很人性化, 默认没有提供添加邀请码的接口, 于是便使用插件的方式实现添加邀请码API, 惯例先贴核心代码

# 代码 #

``` php
<?php
if (!defined('IN_DISCUZ')) {
    exit('Access Denied');
}

date_default_timezone_set('Asia/Shanghai');
global $_G;

/**
 * 获取query之后的返回值, 并按需格式化
 *
 * @param $response
 * @return array|bool
 */
function get_query_data($response)
{
    while ($arr = mysqli_fetch_array($response)) {
        $data[] = array('id' => $arr['id'], 'code' => $arr['code'], 'used' => $arr['status'] == 2 ? $arr['fusername'] . '使用于' . date('Y-m-d H:i:s', $arr['regdateline']) : '暂未使用');
    }
    return isset($data) ? $data : false;
}

if (isset($_POST['code'])) {
    $link = mysqli_connect(
        $_G['config']['db'][1]['dbhost'],
        $_G['config']['db'][1]['dbuser'],
        $_G['config']['db'][1]['dbpw'],
        $_G['config']['db'][1]['dbname']
    );
    $table = $_G['config']['db'][1]['tablepre'] . 'common_invite';
    if (empty($_POST['code'])) {
        $res = mysqli_query($link, "SELECT * FROM `$table`");
        $data = get_query_data($res);
    } else {
        switch ($_POST['submit']) {
            case 'add':
                $res = mysqli_query($link, "INSERT INTO `$table` (`code`) VALUES ('" . $_POST['code'] . "')");
                $res = mysqli_query($link, "SELECT * FROM `$table`");
                $data = get_query_data($res);
                break;

            case 'del':
                mysqli_query($link, "DELETE FROM `$table` WHERE `code` = '" . $_POST['code'] . "'");
                $res = mysqli_query($link, "SELECT * FROM `$table`");
                $data = get_query_data($res);
                break;
        }
    }
}
?>
<!DOCTYPE html>
<html lang="zh-cmn-Hans">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="theme-color" content="#db5945">
    <link rel="stylesheet" href="//cdn.bootcss.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <title>邀请码Demo</title>
</head>
<body>
<div class="container">
    <form target="_self" method="post" class="form-inline">
        <input type="text" name="code" id="code" class="form-control" placeholder="邀请码">
        <button type="submit" class="btn btn-success" name="submit" value="add">添加</button>
        <button type="submit" class="btn btn-danger" name="submit" value="del">删除</button>
    </form>
    <div id="table" class="table-responsive">
        <table class="table table-hover">
            <thead>
            <tr>
                <td>编号</td>
                <td>邀请码</td>
                <td>使用情况</td>
            </tr>
            </thead>
            <tbody>
            <?php
            if (isset($data)) {
                foreach ($data as $each) {
                    echo '<tr><td>' . $each['id'] . '</td><td>' . $each['code'] . '</td><td>' . $each['used'] . '</td></tr>';
                }
            }
            ?>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>

```

# 小结 #

把代码放到新建一个文件夹里面, 把文件夹名字加到dz后台添加插件里, 选择导航插件, 例如快捷导航, 启用插件后即可在前台进入插件进行对邀请码的管理
