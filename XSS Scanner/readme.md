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
## How to USE Program:
```
python3 xss.py -u url -p payload.txt
```
## Logic Utlilized 
Using the Selenium Web Driver we have made a custom browser and then we test the web application in that browser to check if it accepts user input without proper validation. If an XSS vulnerability is found then the payload slows down the browser and we are informed of the existence of the vulnerability. 
