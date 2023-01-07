# Remote File Inclusion (RFI)
* This is a vulnerability which is extremely common with web applications with dynamically include external files. When web applications take user input (URL, parameter value, etc.) and pass them into file include commands, the web application might be tricked into including remote files with malicious code. Although almost all web application frameworks support file inclusion and they are perfectly secure. The issue begins when the user supplied input is accepted without proper validation. The malicious user can easily create backdoors, get unauthorised access to restricted data, run malicious code on the server, take complete control of the server etc.
As said before most web application architectures allow for user input in the form of URL, parameter and value. When such user input is not sanitised and properly validated then the user can easily redirect the web application to an unsafe address where the security of the web application is ultimately compromised which maybe range from gaining unauthorised access to restricted data all the way to Cross Site Scripting (XSS) and thus eventually leading to a compromised system. PHP is particularly vulnerable to RFI attacks due to the extensive use of “file includes” in PHP programming and due to default server configurations that increase susceptibility to an RFI attack.

#### Python Scanner and Exploiter of Remote File Inclusion Vulnerability

**Features**

1- Scanner

2- Exploiter

**Scanner Features**

1.1 Possibilities to reach https://www.google.com/

1.2 Possibilities to reach https://brave.com/

1.3 Possibilities to reach your server with RFI 


**Exploiter Features**

2.1 Traditional Exploitation

2.2 Wrappers

**Installation**

Commands:
```
apt install pip

pip3 install python3-pyfiglet

pip3 install colorama

git clone https://github.com/Malwareman007/Scanner-and-Patcher/
```
**Execution**
```
cd Rfi-Scanner

python3 Rfi.py
```
