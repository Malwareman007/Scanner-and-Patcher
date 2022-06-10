#/bin/bash

# bash-autopatch.sh
# A shell script that fully automates the "manual" patching of GNU Bash, using source and all known official patches.
# how-to-manually-update-bash-to-patch-shellshock-bug-on-older-fedora-based-systems/


# Variables
dirBashfix="/usr/local/src/bashfix"

# Lets make sure we have sudo
sudo -v

# Auto-detect bash version
echo -n "Detecting Bash Version: "
fullversion=`bash --version | head -n1 | sed 's/^.* \([0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]*\).*$/\1/g'`
version=`echo ${fullversion} | awk -F. '{print $1"."$2}' | sed 's/^\([0-9]\{1\}\.[0-9]\{1\}\).*$/\1/g'`
curpatch=`echo ${fullversion} | awk -F. '{print $3}'`
no_dot_version=`echo ${version} | sed 's/\.//g'`
echo ${fullversion}

# Auto-detect last patch number
echo -n "Grabbing Latest Patch for bash-${version}: "
lastpatch=`curl --silent --insecure https://ftp.gnu.org/pub/gnu/bash/bash-${version}-patches/ | grep bash${no_dot_version}-[0-9]*.sig | tail -n1 | sed "s/^.*\"bash${no_dot_version}-\([0-9]*\).sig\".*/\1/g"`
echo ${lastpatch}

# If the patch versions are the same do not update
if [[ `echo ${lastpatch} | sed 's/^[0]*//g'` -eq ${curpatch} ]]; then 
    echo -e "No Bash Update:\n\tCurrent Version: ${fullversion}\n\tLatest Patch: ${lastpatch}"
    exit 1
fi

# Setup: backup bash
echo -en "Setup: Backing up bash\r"
sudo cp /bin/bash /bin/bash.old
# Setup: create directories
echo -en "Setup: Creating directories\r"
sudo mkdir -p ${dirBashfix}
cd ${dirBashfix}
# Setup: install required packages
echo -en "Setup: YUM Installing packages...\r"
sudo yum -q -y install patch byacc textinfo bison autoconf gettext ncurses-devel gcc test make
# Setup: download bash version, extract, then hop in
echo "Setup: Downloading bash-${version} source and extracting"
sudo wget --no-check-certificate https://ftp.gnu.org/pub/gnu/bash/bash-${version}.tar.gz &&
sudo tar zxvf bash-${version}.tar.gz
cd bash-${version}

# Now cycle through and build it
echo "Processing: Patching patch source"
for i in `seq 1 $lastpatch`; do
        number=$(printf %03d $i)
        file="https://ftp.gnu.org/pub/gnu/bash/bash-${version}-patches/bash${no_dot_version}-${number}"
        echo ${file}
        curl ${file} --insecure | sudo patch -N -p0
done

# Lets build it
echo "Processing: Building bash from patched source then testing"
sudo ./configure &&
sudo make &&
sudo make test &&

# Copy to /bin/bash and display info
echo "Copying: Bash to /bin/bash"
sudo cp -f bash /bin/bash
ls -lh /bin/bash
echo "Complete!"

exit 0
