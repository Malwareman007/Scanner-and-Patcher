ms10-070CheckPatch
==================

Check for .net padding oracle patch

## Usage Examples
```
ms10-070_check.py -d VHYaLecZ91Zjq-_4mV3ftpYrTteh9kHzk9zwLyjpAZAOjWL3nbx1SmIeGdHJwBu_koMj8ZGAqrtxCJkW0
Decoded d value: <binary output>
Length: 60
D value length of 60 is not evenly divisible by 8, your application is patched
```
```
python ms10-070_check.py -d 2nYOzoKtRvjs-g53K3r7VKmEXeQl_XMNY8nDEwcgwGVcS5Z8b9GanbNdzIgg493kfB_oI
Length: 72
D value length of 72 is evenly divisible by 8, your application is likely vulnerable (try more d values if unsure)
```
```
python ./ms10-070_check.py -e asdfasdfasdfasdf123123123234
YXNkZmFzZGZhc2RmYXNkZjEyMzEyMzEyMzIzNA==
Length: 40
```
