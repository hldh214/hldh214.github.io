---
title: FFmpeg 乱记
date: 2018-11-21 15:47:00
---
## misc ##

``` bash
# 转码
ffmpeg -i Busines.mp4 -c:v libx264 -crf 19 Busines.flv

# 裁切
# -ss is the starttime and -t is the duration
# ref: https://vollnixx.wordpress.com/2012/06/01/howto-cut-a-video-directly-with-ffmpeg-without-transcoding/
ffmpeg -i Busines.flv -c copy -ss 25 Busines_cut.flv
```

## drawtext ##

https://ffmpeg.org/ffmpeg-filters.html#drawtext
https://superuser.com/questions/939357/ffmpeg-watermark-on-bottom-right-corner

## concat ##

https://stackoverflow.com/questions/34803506/how-to-push-a-video-list-to-rtmp-server-and-keep-connect

``` python
import os

prefix = '/home/ubuntu/DX-BALL2-Video'
with open('../videos.txt', 'w') as fp:
    for each in os.listdir():
        if each == 'tmp.py':
            continue
        fp.write("file '{0}/{1}'\n".format(prefix, each))
```
