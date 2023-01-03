# XSS Scanner 
 
**XSS Scanner** (XSS) is a fully functional [Cross-site scripting](https://en.wikipedia.org/wiki/Cross-site_scripting) vulnerability scanner (supporting GET and POST parameters) written in under 100 lines of code.

![Vulnerable](http://i.imgur.com/hadlgS0.png)

As of optional settings it supports HTTP proxy together with HTTP header values `User-Agent`, `Referer` and `Cookie`.

Sample runs
----

```
$ python3 xss.py -h
 XSS Scanner (XSS) #v2
 by: Malwareman

Usage: xss.py [options]

Options:
  --version          show program's version number and exit
  -h, --help         show this help message and exit
  -u URL, --url=URL  Target URL (e.g. "http://www.target.com/page.htm?id=1")
  --data=DATA        POST data (e.g. "query=test")
  --cookie=COOKIE    HTTP Cookie header value
  --user-agent=UA    HTTP User-Agent header value
  --referer=REFERER  HTTP Referer header value
  --proxy=PROXY      HTTP proxy address (e.g. "http://127.0.0.1:8080")
```

```
$ python3 xss.py -u "http://testphp.vulnweb.com/search.php?test=query" --data="s
earchFor=foobar"
XSS Scanner (XSS) #v2
 by: Malwareman

* scanning GET parameter 'test'
* scanning POST parameter 'searchFor'
 (i) POST parameter 'searchFor' appears to be XSS vulnerable (">.xss.<", outside
 of tags, no filtering)

scan results: possible vulnerabilities found
```

```
$ python3 xss.py -u "http://public-firing-range.appspot.com/address/location.has
h/replace"
XSS Scanner (XSS) #v2
 by: Malwareman

 (i) page itself appears to be XSS vulnerable (DOM)
  (o) ...<script>
      var payload = window.location.hash.substr(1);location.replace(payload); 

    </script>...
 (x) no usable GET/POST parameters found

scan results: possible vulnerabilities found
```

Requirements
----

[Python](http://www.python.org/download/) version **3.x** is required for running this program.
