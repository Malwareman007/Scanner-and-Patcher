import requests, argparse, sys
from colorama import *

parser = argparse.ArgumentParser()
parser.add_argument("-u", "--url", help="url", required=True)
parser.add_argument("-p", "--payloads", help="payloads list", required=True)


def fuzz(url, payloads):
    for payloads in open(payloads, "r").readlines():
        new_url = url.replace('{fuzz}', payloads)
        request = requests.get(new_url)
        if request.elasped.total_second > 7:
            print(Style.BRIGHT + Fore.RED + "Time Out Detected with new_url :(")

        else:
            print(Style.BRIGHT + Fore.CYAN + "Not worked with this payloads")

def verif(url):

    url_test =url.replaced("{fuzz}","")

    req = requests.get(url_test)
    if req.elapsed.total_seconds()>6:
        sys.exit(Style.BRIGHT+Fore.RED+"Please make sure you have good connection")

    else:
        fuzz(argparse.url, argparse.payloads)

    if not '{fuzz}' in argparse.url:
        sys.exit(Style.BRIGHT+Fore.RED+"Missing {fuzz} parameter")

    else:
        verif(argparse.url)
