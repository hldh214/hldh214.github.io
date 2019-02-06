---
title: Discuz X3.2插件开发(一)
date: 2016-05-20 12:51:29
---
# 准备 #

在 `config/config_global.php` 中添加一行
``` php
/*
1表示开发者模式, 2表示开发者模式并且显示页面hook
*/
$_config['plugindeveloper'] = 2;
```

# 插件xml语法 #

 1. 版本兼容

``` xml
<item id="Data">
	<item id="plugin">
		......
	</item>
	......
	<item id="version"><![CDATA[多个版本用逗号分隔, 如 X2,X2.5]]></item>
	......
</item>
```

# 官方文档 #

[Dz资料库](http://faq.comsenz.com/library/)

