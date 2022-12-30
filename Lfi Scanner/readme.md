# Local File Inclusion (LFI)
* Local File Inclusion (LFI) allows an attacker to include files on a server through the web browser. This vulnerability exists when a web application includes a file without correctly sanitising the input, allowing and attacker to manipulate the input and inject path traversal characters and include other files from the web server. An LFI attack may lead to information disclosure, remote code execution, or even Cross-site Scripting (XSS). Typically, LFI occurs when an application uses the path to a file as input. If the application treats this input as trusted, a local file may be used in the include statement.
### Local File Inclusion Scanner and Exploiter

**Features**

1- Scanner

2- Exploiter

**Exploiter Attack Vectors:**

1- /proc/self/environ

2- /var/log/auth.log

3- Apache Log Poisoning

4- php://input

5- Php Sessions and Cookies

6- Data Wrapper

7- SMTP Poisoning

8- All attacks in one


**Installation**
```
git clone https://github.com/Open_Source_Web-Vulnerability-Scanner-and-Patcher/
cd Lfi Scanner
pip3 install pyfiglet
pip3 install SimpleTelnetMail
```
**Usage**
```
python3 Lfi.py
```

