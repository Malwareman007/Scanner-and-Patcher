#!/bin/bash

isrootrunning=$(whoami)
if [ "$isrootrunning" != "root" ]; then
    echo -e "Please run as root or with sudo\n "
    exit 0
fi

# update OS
sudo apt-get update -y
sudo apt-get upgrade -y

# install required packages
sudo apt-get install python3-pip software-properties-common build-essential cmake libgtk-3-dev libboost-all-dev -y

# installing whatweb
sudo apt-get install whatweb -y
# installing host
sudo apt-get install host -y
# installing wget
sudo apt-get install wget -y
# installing uniscan
sudo apt-get install uniscan -y
# installing wafwoof
pip3 install wafw00f
# installing wapiti
sudo apt-get install wapiti -y
# installing uniscan
sudo apt-get install uniscan -y
#installing nikto
sudo apt-get install nikto -y
#installling davtest
sudo apt-get install davtest -y
#installing dnsmap
sudo apt-get install dnsmap -y
# installing nmap
sudo apt-get install nmap -y


#installing golismero

git clone https://github.com/golismero/golismero.git
cd golismero
pip install -r requirements.txt
pip install -r requirements_unix.txt
ln -s ${PWD}/golismero.py /usr/bin/golismero

cd ..
sudo apt-get update && sudo apt-get upgrade -y


