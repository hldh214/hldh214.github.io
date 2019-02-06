---
title: python3 json_requests 相关备忘
date: 2017-07-17 20:40:15
---
``` python
# from collections import OrderedDict
oss_forms_res = requests.post('https://shimo.im/api/upload/oss_forms', {
    'head': 1,
    'guid': guid
}, headers=headers).json(object_pairs_hook=OrderedDict)


# from base64 import b64encode
policy = b64encode(dumps(
    oss_forms_res['data']['policy'],
    separators=(',', ':')  # disable white space
).encode()).decode()

# import requests
# keep your payload in order
oss_res = requests.post(oss_base_url, headers=headers, files=(
    ('OSSAccessKeyId', (None, oss_forms_res['data']['OSSAccessKeyId'], None)),
    ('policy', (None, policy, None)),
    ('Signature', (None, oss_forms_res['data']['signature'], None)),
    ('key', (None, uri, None)),
    ('Content-Type', (None, 'multipart/form-data', None)),
    ('file', ('blob', b'qq', 'application/zip')),
))

```
