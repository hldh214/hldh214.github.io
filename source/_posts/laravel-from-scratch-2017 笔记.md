---
title: laravel-from-scratch-2017 笔记
date: 2018-11-21 15:46:00
---
ref: https://laracasts.com/series/laravel-from-scratch-2017/

# Model #

## Scope function ##

ref: http://laravelacademy.org/post/6979.html#toc_18
在 Model 中定义 `scope` 开头的 `public function` 
相当于创建一个作用于当前 Model 对象的([这和普通写法有什么区别?](https://stackoverflow.com/q/15070809/6266737))新的链式调用
``` php
use Illuminate\Database\Eloquent\Model;

class User extends Model
{
    /**
     * 只包含活跃用户的查询作用域
     *
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function scopePopular($query)
    {
        return $query->where('votes', '>', 100);
    }

    /**
     * 只包含激活用户的查询作用域
     *
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function scopeActive($query)
    {
        return $query->where('active', 1);
    }
}
```
调用时不需要加上 `scope` 前缀
`$users = \App\User::popular()->active()->orderBy('created_at')->get();`

如果是普通写法会产生这样的问题
``` php
use Illuminate\Database\Eloquent\Model;

class Post extends Model
{
    public static function custom_wh($data){
        return static::where_in('categories_id', $data, 'AND');
    }
}

// this works fine
$posts = Post::custom_wh(array(1, 2, 3))->get();

// but this says custom_wh is not defined in the query class
$posts = Post::where_in('tags', array(2, 3, 4), 'AND')->custom_wh(array(1, 2, 3))->get();

```

## Querying Relationship Existence  ##

ref: http://laravelacademy.org/post/6996.html#toc_11
查询存在的关联关系, 例如
博客有许多 tags, 我们不希望显示没有 post 的 tag
```php
// Retrieve all tags that have at least one post...
$posts = \App\Tag::has('posts')->get();
```


# View #

## View composer ##

ref: http://laravelacademy.org/post/6758.html#toc_2
网站的公共部分需要 assign 变量的时候, 比如 blog 的 sidebar 需要博客归档
可以使用 view composer 来避免在不同方法中重复 assign 变量
在 AppServiceProvider 中的 `boot` 方法中
``` php
public function boot()
{
    view()->composer('view.name', function($view) {
        // just like data assign in controller
        $view->with(['var name here' => $var]);
    });
}
```


# Controller #

## RESTful Controller ##

ref: http://laravelacademy.org/post/6745.html#toc_6
`php artisan make:controller TasksController -r`
`Route::resource('tasks', 'TasksController');`
``` php
GET    /tasks => TasksController@index  // 列出所有 task
GET    /tasks/create => TasksController@create  // 显示创建 task 的表单页
POST   /tasks => TasksController@store  // 创建 task
GET    /tasks/{id} => TasksController@show/{id}  // 列出指定 task
GET    /tasks/{id}/edit => TasksController@edit/{id}  // 显示编辑指定 task 的表单页
PATCH  /tasks/{id} => TasksController@update/{id}  // 编辑指定 task
DELETE /tasks/{id} => TasksController@destroy/{id}  // 删除指定 task
```
