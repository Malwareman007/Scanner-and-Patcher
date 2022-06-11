# Local File Inclusion (LFI)
* Local File Inclusion (LFI) allows an attacker to include files on a server through the web browser. This vulnerability exists when a web application includes a file without correctly sanitising the input, allowing and attacker to manipulate the input and inject path traversal characters and include other files from the web server. An LFI attack may lead to information disclosure, remote code execution, or even Cross-site Scripting (XSS). Typically, LFI occurs when an application uses the path to a file as input. If the application treats this input as trusted, a local file may be used in the include statement.
## Libraries Used
* Request – This particular library has been used as we need to make HTTP requests in order to check for the LFI vulnerability.
* sys – This particular library is necessary as it helps by providing various functions and variables to manipulate different parts of the Python Runtime environment
## HOW TO RUN THE CODE ##
* python3 lfi.py [options] (url)
## Goal of the code 
* Scan the target web application for a LFI vulnerability
## Logic Utilized 
* Firstly using the if statement we filter out invalid target application inputs. Once we find a valid target we store it in selected_target.
