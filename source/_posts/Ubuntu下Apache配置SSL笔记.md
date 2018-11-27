---
title: Ubuntu下Apache配置SSL笔记
date: 2018-11-21 15:23:00
---
# 引言 #

本来以为这类教程很成熟的照搬就可以用的, 但是实际操作之后还是有些许问题, 故有此文, 本文暂且不讨论各个文件的作用, 只单纯讨论配制方法.

# 步骤 #

首先需要在主机上生成CSR文件和KEY文件, 这里需要注意的是
common name 需要填写域名, 如果不是wildcard认证需要带上www前缀.
生成完毕就可以发给认证机构来进行认证了.
认证成功后机构会发给你这么几个文件(我在COMODO认证的)

```
AddTrustExternalCARoot.crt
COMODORSAAddTrustCA.crt
COMODORSADomainValidationSecureServerCA.crt
你的域名.crt
```

首先需要合并crt文件:

	# cat COMODORSADomainValidationSecureServerCA.crt COMODORSAAddTrustCA.crt AddTrustExternalCARoot.crt > bundle.crt

用下面的命令确保ssl模块已经加载进apache了：

	# a2enmod ssl
如果你看到了“Module ssl already enabled”这样的信息就说明你成功了，如果你看到了“Enabling module ssl”，那么你还需要用下面的命令重启apache：

	# service apache2 restart

另外, 如果你是编译安装的Apache, 则需要在httpd.conf中去掉mod_ssl的注释以及mod_socache_shmcb的注释, 另外还要在extra目录下编辑httpd-ssl.conf, 这些都是和用apt-get方式安装所不同的地方

----------


到了这里就是关键的部分了, 网上的教程大多不适合Ubuntu下的Apache配置, 我来总结一下我自己的经验.

首先配置Apache的ssl配置文件:

	# vim /etc/apache2/sites-available/default-ssl.conf

找到

```
SSLCertificateFile /path/to/crt-file
SSLCertificateKeyFile /path/to/key-file
SSLCACertificateFile /path/to/bundle.crt-file
```

按需修改之后, 再进行软连接 (如果是编译安装则是去httpd-ssl.conf中去掉include httpd-ssl.conf的注释)
	
	# ln -s /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf 

大功告成, restart一下Apache, 尽情享用吧~

# 附 #

Apache 使用rewrite模块强制走 https 配置:
.htaccess文件:
```
RewriteEngineOn
RewriteCond %{SERVER_PORT} 80
RewriteRule ^(.*)?$ https://%{SERVER_NAME}/$1 [R=301,L]
```

# 参考资料 #

http://www.linuxidc.com/Linux/2015-02/113588.htm
