---
title: Python 解析 json 对象
date: 2016-12-17 15:09:58
---
Python 内置模块 json
默认解析成字典, 以字典的方式访问
要想以对象的方式访问, 需要使用可选参数

```

json.loads(f.read().decode('utf8'),objecthook=decode_dict)

```



ref => https://shekhargulati.com/2016/02/03/python-json-object_hook/
