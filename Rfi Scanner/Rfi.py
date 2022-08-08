import request,sys

if len(sys.argv)<2:
     sys.exit("Missing target !")
elif not (fuzz)' in sys.argv[1]:
     sys.exit("Missing (fuzz) parameter")
else:
     selected target sys.argv[1]
url- "http://127.0.0.1/test.php"
target=selected target.replace("(fuzz)", url) # replacing (fuzz)
request=requests.get(target) #send request
if b"114518875656586764489874" in request.content: # check if 11451875656586764489874 is in source code
    print("RFI !")
else:
    print("RFI not detected !")
