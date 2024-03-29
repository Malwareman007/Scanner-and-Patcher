# Log4j Scanner #

This repository provides a scanning solution for the log4j Remote Code Execution vulnerabilities (CVE-2021-44228 & CVE-2021-45046). 
The information and code in this repository is provided "as is" and was assembled with the help of the Tribe N . This is not intended to be a 100% true positive solution; False negatives may occur.
***

## Official CISA Guidance & Resources ##

- [CISA Apache Log4j Vulnerability Guidance](https://www.cisa.gov/uscert/apache-log4j-vulnerability-guidance)
- [Statement from CISA Director Easterly on “Log4j” Vulnerability](https://www.cisa.gov/news/2021/12/11/statement-cisa-director-easterly-log4j-vulnerability).

## CISA Current Activity Alerts ##

- [Apache Releases Log4j Version 2.15.0 to Address Critical RCE Vulnerability Under Exploitation](https://www.cisa.gov/uscert/ncas/current-activity/2021/12/10/apache-releases-log4j-version-2150-address-critical-rce)
- [CISA Creates Webpage for Apache Log4j Vulnerability CVE-2021-44228](https://www.cisa.gov/uscert/ncas/current-activity/2021/12/13/cisa-creates-webpage-apache-log4j-vulnerability-cve-2021-44228)
***
## CVE-2021-44228 & CVE-2021-45046 ##

### Steps to test ###

<details><summary>Configure your own DNS Server - Preferred) </summary><br/>
- Add DNS records to your domain. (example.com)

- `A` record with a value of your IP address (`test.example.com` -> <PUBLIC IP ADDRESS>)
- `NS` record (`ns1.example.com`) with a value of the `test.example.com` as chosen above.

- Host a DNS server to log DNS requests made to your domain. 

- Install the requirement modules -> `pip3 install -r requirements.txt`

- Modify the `dns/ddnsserver.py` script with the value of the NS record above (`test.example.com`) 

- `python3 ddnsserver.py --port 53 --udp >> dns-results.txt`

- Test it with `nslookup hello.test.example.com`. You can run `tail -f dns-results.txt` to monitor these logs. 

- You should see the entry in your `dns-results.txt` file after the `nslookup` command. Once you do, you're ready to scan! 

- Note: Same concepts will apply if you're using internal DNS to test this. 

</details>

<details><summary>DNS providers - (Interact.sh or canarytokens.org) </summary><br/>

- [Interact.sh](https://github.com/projectdiscovery/interactsh)  - Interactsh is an open-source solution for out-of-band data extraction. It is a tool designed to detect bugs that cause external interactions. These bugs include, Blind SQLi, Blind CMDi, SSRF, etc. 

- [Canarytokens.org](https://canarytokens.org/generate) - Canarytokens helps track activity and actions on your network.

</details>

<details><summary>LDAP Server (OPTIONAL)</summary><br/>

- Reference the `README.md` under the `ldap` directory if you'd also like to test a running LDAP server.

- Build the project using maven. `cd ldap`

- `mvn clean package -DskipTests`

- `nohup java -cp target/marshalsec-0.0.3-SNAPSHOT-all.jar marshalsec.jndi.LDAPRefServer "http://127.0.0.1:8080/#payload" 443 >> ldap_requests.txt &`

- There are [alternatives](https://github.com/alexandre-lavoie/python-log4rce) to this project as well. 
</details>

<details><summary>HTTP Service Discovery & Scanning</summary><br/>

- Gather your most update-to-date asset list of your organization and find web services. Though this vulnerability does not solely affect web services, 
this will serve as a great starting point to minimizing the attack surface.

- **If you have a list of company owned URLS, you may skip this step**: Utilize some well known tools like [httpprobe](https://github.com/tomnomnom/httprobe) or [httpx](https://github.com/projectdiscovery/httpx) to identify web services running on multiple ports. Basic Example: `httpprobe` -> `cat list-of-your-company-domains.txt | $HOME/go/bin/httprobe > your-web-assets.txt`

- Now that you have a list of URLs, you're ready to scan: `python3 log4j-scan.py --run-all-tests --custom-dns-callback-host test.example.com -l web-asset-urls.txt`

- Be sure to scan for the **new** CVE as well -> `python3 log4j-scan.py --test-CVE-2021-45046 --custom-dns-callback-host test.example.com -l web-asset-urls.txt`

- Monitor the DNS server configured in **Step 2**.
</details>

## HOW TO RUN COMMAND ##
  python3 Log4jScanner.py [options] (url)
  
## CREDITS ##

As many in industry, we did not feel the need to "re-invent the wheel". This
recommended scanning solution is derived from the great work of others (with slight modifications). We've included two additional
projects to avoid using third-parties.

## Issues ##

If you have issues using the code, open an issue on the repository!

You can do this by clicking "Issues" at the top and clicking "New Issue" on the following page.

## Contributing ##

We welcome contributions!  Please see [here](CONTRIBUTING.md) for details.

## Disclaimers ##

- There are likely additional, as yet unknown ways to leverage these (**CVE-2021-44228** & **CVE-2021-45046**) vulnerabilities. We are staying vigilant across
multiple platforms (blog posts, repos, tweets, etc.) to stay up-to-date as the log4j situation unfolds and progresses.

- This repository will focus solely on providing tooling to help organizations look for a limited set of currently known vulnerabilities in assets owned by their organization.



## Legal Disclaimer ##

NOTICE

USE THIS SOFTWARE AT YOUR OWN RISK. THIS SOFTWARE COMES WITH NO WARRANTY, EITHER EXPRESS OR IMPLIED. THE GOVERNMENT ASSUMES NO LIABILITY FOR THE USE OR MISUSE OF THIS SOFTWARE OR ITS DERIVATIVES.

