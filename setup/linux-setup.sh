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
sudo apt-get install whatweb
# installing host
sudo apt-get install host
# installing wget
sudo apt-get install wget
# installing uniscan
sudo apt-get install uniscan
# installing wafwoof
pip install wafw00f
# installing wapiti
sudo apt-get install wapiti
# installing uniscan
apt-get install uniscan

#installing golismero

git clone https://github.com/golismero/golismero.git
cd golismero
pip install -r requirements.txt
