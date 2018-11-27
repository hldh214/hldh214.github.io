#!/bin/sh

filelist=$(ls)
for file in *
do
    grep -I -r -l $'\xEF\xBB\xBF' "${file}" | xargs -d '\n' sed -i 's/\xEF\xBB\xBF//'
    #grep -I -r -l $'\xEF\xBB\xBF' "${file}" | xargs
done
