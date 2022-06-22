# Cross-Site Scripting (XSS)
Cross-Site Scripting attacks are a type of injection, in which malicious scripts are injected into otherwise trustworthy websites. An attacker exploits a XSS vulnerability via a web application, generally in the form of a browser side script to a different end user. These vulnerabilities are quite widespread as they can occur anywhere an input is taken from a user without validating or encoding it and is used to generate an output. The end user’s browser has no way to know that the script should not be trusted and it will execute the script as it thinks the script came from a trusted source. Thus, the malicious script after injection can access any cookies, session tokens, or the other sensitive information retained by the browser and use with that site.

## Libraries Used 
### Selenium 
It is a library in python which is used to control web browsers through programs and performing browser automation.
### Warnings 
This class is usually used to warn the developer of situations that take place during the execution of a program.
### argparse
This class helps create a program in a command-line-environment in a way that appears easy to code but also improves interaction. It also automatically generates help and usage messages and issues errors when users give the program invalid arguments.
### sys 
This particular library is necessary as it helps by providing various functions and variables to manipulate different parts of the Python Runtime environment.
## Goal of the code
Scan the target web application for XSS vulnerabilities.
## How to use Program in XSS:
It contains Alternate XSS syntax they are as follows-
1].XSS Using Script in Attributes
XSS attacks may be conducted without using <script>...</script> tags. Other tags will do exactly the same thing, for example: <body onload=alert('test1')> or other attributes like: onmouseover, onerror.

onmouseover
<b onmouseover=alert('Wufff!')>click me!
onerror


2].XSS Using Script Via Encoded URI Schemes
If we need to hide against web application filters we may try to encode string characters, e.g.: a=&#X41 (UTF-8) and use it in IMG tags:

<IMG SRC=j&#X41vascript:alert('test2')>

There are many different UTF-8 encoding notations that give us even more possibilities.

3].XSS Using Code Encoding
We may encode our script in base64 and place it in META tag. This way we get rid of alert() totally. More information about this method can be found in RFC 2397

EXAMPLE:
XSS attacks may occur anywhere that possibly malicious users are allowed to post unregulated material to a trusted website for the consumption of other valid users. The most common example can be found in bulletin-board websites which provide web based mailing list-style functionality.
The following JSP code segment reads an employee ID, eid, from an HTTP request and displays it to the user.

<% String eid = request.getParameter("eid"); %>
....................
Employee ID: <%= eid %>

The code in this example operates correctly if eid contains only standard alphanumeric text. If eid has a value that includes meta-characters or source code, then the code will be executed by the web browser as it displays the HTTP response.

Initially, this might not appear to be much of a vulnerability. After all, why would someone enter a URL that causes malicious code to run on their own computer? The real danger is that an attacker will create the malicious URL, then use e-mail or social engineering tricks to lure victims into visiting a link to the URL. When victims click the link, they unwittingly reflect the malicious content through the vulnerable web application back to their own computers. This mechanism of exploiting vulnerable web applications is known as Reflected XSS.
```
python3 xss.py (url)
```
## Logic Utlilized 
Using the Selenium Web Driver we have made a custom browser and then we test the web application in that browser to check if it accepts user input without proper validation. If an XSS vulnerability is found then the payload slows down the browser and we are informed of the existence of the vulnerability. 
