# Correctly encoded in different locations
## （1）The output is in HTML text
```xml
<div>$UserData</div>
```


## （1）HTML Entity encoding

```xml
<div>$UserData</div>
```


Characters to be encoded:
&, <, >, ', ", /

Escape mode："&#x" + hex + ";"

## （2）HTML Property encoding (excluding time attributes and URL attributes.)

```xml
<div attr="$UserData"></div>
```

Characters to be encoded:
'\u0009', '\n', '\u000C', '\r', '\u0020', '&', '<', '>', '\"', '\'', '/', '=', '`', '\u0085', '\u2028', '\u2029'


## (3) CSSencode
```xml
<div style="background:url(${UserData} );">123</div>
```

The character that needs to be encoded：
'\"', '\'', '\\', '<', '&', '(', ')', '/', '>', '\u007f', '\u2028', '\u2029'
How it is encoded："\\" + hex + " "；

##（4）URL encoding（src、url property）
```xml
<a href="${UserData} ">https://venscor.com</a>
```
Source code principle: divide"#&-./0123456789=?@ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~"Outside, all URL encoding.

Encoding："%" + hex

## （5）JSencode
Encoding principle: The output is within the Js or HTML tag time attribute.


