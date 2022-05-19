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

#installing golismero

git clone https://github.com/golismero/golismero.git
cd golismero
pip install -r requirements.txt
