---
title: 当phantomJS遇上Requests
date: 2018-11-21 15:9:00
---
# 引子 #
前不久,学校弄了个SPOC网站,用JAVA写的,内容不多,但是网站的登录验证使用了少见的RSA算法对POST数据进行加密,不禁让我想到可否用Python来模拟用户登录,便有此文.
# 踩点 #
简单浏览网站后,得知加密算法是通过JavaScript实现,RSA键值对存放在登录页面html代码中的hidden属性的input标签里.
# 分析 #
获取RSA键值对对于Python是很容易的,因为是静态存在于html内,而对于动态的算法,Python则显得无力,这时候便祭出Python的拜把子兄弟PhantomJS,使用PhantomJS处理JavaScript部分的算法,返回加密后的数据给Python继续进行POST操作.
# 核心代码 #
JavaScript部分:

``` JavaScript
var system = require('system');
var modulus = system.args[1];
var exponent = system.args[2];
var tokenId = system.args[3];
var password = system.args[4];  // 密码
setMaxDigits(130);
key = new RSAKeyPair(exponent, "", modulus);
token = tokenId+"\n"+password;
strToken = encryptedString(key, token);
console.log(strToken);
phantom.exit();
```

Python部分:

``` python
cmd = 'phantomjs E:\\demo.js' \
      + ' ' + modulus + ' ' + exponent + ' ' + tokenId + ' ' + password
strToken = os.popen(cmd).read().strip("\n")
print(strToken.encode())  # check spare spaces
```

# 总结 #
登录搞定了基本上相当于搞定了全部,之后你可以发帖,回帖,等等......玩法很多.甚至玩刺激点的可以把脚本挂上vps,然后......
