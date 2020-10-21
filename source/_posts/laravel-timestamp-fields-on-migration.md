---
title: 探秘 laravel migration 之 timestamp 奇怪的默认值
date: 2018-12-11 13:13:19
tags:
---

# 引子

大家都知道 laravel 框架有一个 migration 功能, 也就是数据库迁移
允许开发者使用 php 语言描述 DDL, 框架自动帮你处理了各种 SQL 规范之间的兼容问题
使用 `php artisan migrate` 即可一键迁移你定义好的所有表结构
配合另一神器 `seed` 可以实现超快速环境搭建 + 测试数据导入
今天我要讲一讲 migration 功能中的 `timestamp` 字段的一个小细节
注意这里指的是支持自定义字段名的 `timestamp` 方法, 而不是自动生成的 `timestamps` 方法, 请读者留意

<!-- more -->

# 坑

其实不能算是坑, 只是困扰了我相当久的时间
在某个 migration 文件中有这么一段代码:
```php
<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePrizesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('prizes', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->unsignedMediumInteger('price');
            $table->unsignedMediumInteger('num');
            $table->timestamp('start_at');  // unexpected on update property
            $table->uuid('user_id')->index();
            $table->unsignedTinyInteger('status')->default(0);
            $table->softDeletes();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('prizes');
    }
}

```
问题出在 `$table->timestamp('start_at');` 这里
我们期望得到这样的列:
```
`start_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
```
实际上我们却得到的是这样的列:
```
`start_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP
```
这就造成相当程度的疑惑, 我建表明明没有写这些 `CURRENT_TIMESTAMP` 玩意的
为啥就自作聪明的给加上了, 一开始我怀疑是 migration 功能导致的
后来一顿操作查阅资料后得知是 MySQL 的特性, 设计如此

	If explicit_defaults_for_timestamp is disabled, the server enables the nonstandard behaviors and handles TIMESTAMP columns as follows:

	TIMESTAMP columns not explicitly declared with the NULL attribute are automatically declared with the NOT NULL attribute. Assigning such a column a value of NULL is permitted and sets the column to the current timestamp.
	The first TIMESTAMP column in a table, if not explicitly declared with the NULL attribute or an explicit DEFAULT or ON UPDATE attribute, is automatically declared with the DEFAULT CURRENT_TIMESTAMP and ON UPDATE CURRENT_TIMESTAMP attributes.

ref: https://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html#sysvar_explicit_defaults_for_timestamp

知道问题原因自然就知道怎么解决了, 给对应列加上允许 NULL 即可
如果你愿意, 甚至可以加上默认值为 NULL 来取消 `DEFAULT CURRENT_TIMESTAMP`
在 laravel 的 migration 中应该这样写:
```php
Schema::create('prizes', function (Blueprint $table) {
    $table->timestamp('start_at')->nullable();  // ->default(null)
});
```

Lesson learned!

# refs

https://github.com/laravel/framework/issues/21912
https://github.com/laravel/framework/issues/24780
https://ma.ttias.be/laravel-mysql-auto-adding-update-current_timestamp-timestamp-fields/
https://laracasts.com/discuss/channels/eloquent/why-table-timestamps-puts-on-update-current-timestamp-on-the-created-at-column
