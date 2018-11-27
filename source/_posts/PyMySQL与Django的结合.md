---
title: PyMySQL与Django的结合
date: 2018-11-21 15:8:00
---
# 引子 #

最近学习Django框架, 是基于Python3的, 配置MySQL的时候出了点岔子, 因为MySQLdb目前还不能完美兼容Python3, 而Django的MySQL驱动只能识别MySQLdb, 于是便有此文

# 解决方法 #

使用支持Python3的PyMySQL

而最关键的一点在于, 在站点目录下的__init__.py文件里面加上

``` python
import pymysql

pymysql.install_as_MySQLdb()
```

这样就能让Django识别出伪装成MySQLdb的PyMySQL了

# 附录 #

Django关于MySQL的配置代码

``` python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'django',  # 你的数据库名称
        'USER': 'root',
        'PASSWORD': '',
        'HOST': '127.0.0.1',
        'PORT': '3306',
    }
}
```

PyMySQL安装方法

``` python
pip install pymysql
```

