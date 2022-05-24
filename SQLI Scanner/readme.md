# SQL Injection scanner
A SQL injection scanner is an automated tool used to verify the vulnerability of websites and web apps for potential SQL injection attacks. 
SQL injection is a code injection technique used to attack data-driven applications, in which malicious SQL statements are inserted into an entry field for execution . 
SQL injection must exploit a security vulnerability in an application's software, for example, when user input is either incorrectly filtered for string literal escape characters embedded in SQL statements or user input is not strongly typed and unexpectedly executed. 
SQL injection is mostly known as an attack vector for websites but can be used to attack any type of SQL database.

## Libraries Used  

### requests
The requests library is the de facto standard for making HTTP requests in Python. 
It abstracts the complexities of making requests behind a beautiful, simple API so that you can focus on interacting with services and consuming data in your application.

### argparse
This class helps create a program in a command-line-environment in a way that appears easy to code but also improves interaction. 
It also automatically generates help and usage messages and issues errors when users give the program invalid arguments.

### sys
This particular library is necessary as it helps by providing various functions and variables to manipulate different parts of the Python Runtime environment.

### colorama
Colorama is a python module that is used to display colored output in console. 
It can change both, foreground and background color of any text which is displayed in the console.

## Goal of the code
injection and checks the playload for the vulnerability and slows it down if the vulnerabal's are presents ..

## Logic Utlilized in the code 
Using the colorama we test the payload to check if the url has a vulnerability and to verfiy the url for time elapsed from when the connection is made with url . 
If an SQLI vulnerability is found then the payload slows down the browser and we are informed of the existence of the vulnerability.
