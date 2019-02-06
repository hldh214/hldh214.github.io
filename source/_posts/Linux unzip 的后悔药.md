---
title: Linux unzip 的后悔药
date: 2018-02-01 21:13:57
---
# 引子

疏忽导致在家目录做了 unzip 操作, 需要撤销:
``` shell
# work
unzip -l filename |  awk 'BEGIN { OFS="" ; ORS="" } ; { for ( i=4; i<NF; i++ ) print $i " "; print $NF "\n" }' | xargs -I{} rm -v {}
# more readable
zipinfo -1 /path/to/zip/file.zip | xargs -d '\n' rm -i
```

# refs
https://superuser.com/questions/384611/how-to-undo-unzip-command
