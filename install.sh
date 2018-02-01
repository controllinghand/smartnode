#!/bin/bash
# install.sh
# Checks smartnode on Ubuntu 17.10 x64
# ATTENTION: The anti-ddos part will disable http, https and dns ports.
# Controllinghand version 1.1 1/31/2018

# Added LithMage Check 
if ! (dpkg -s smartcashd | grep -F "ok installed") &>/dev/null; then
	echo "WARNING: These scripts uses PPA installed wallet commands."
	echo "FAILED TO DETECT such wallet commands"
	printf "Press Ctrl+C to cancel or Enter install scripts anyway: "
	read IGNORE
fi

# Check to see if smartnode directory already exist
if [ -d ~/smartnode ]
then
    echo "~/smartnode Directory already exist"
    printf "Press Ctrl+C to cancel or Enter to clean up and reinstall:"
    read IGNORE
fi

# who is running this script?
id=$(whoami)
# who is running smartcashd
scid=$(ps axo user:20,comm | grep smartcashd | awk '{printf $1}')

# Warning that the script will reboot the server
echo "WARNING: This script will reboot the server when it's finished."
echo ""
echo "Script must be run as user you installed smartcash."
echo "The current user is: $id"
echo "The user running smartcash is: $scid"

# smartcashd is not running we have bigger problems
if [ $scid = "" ]
then
    echo "smartcashd is not running please start or install"
    echo "Exiting"
    exit
fi

# make sure they are the same user that installed smartcashd
if [ $scid = $id ]
then
    echo "The current user $id is running smartcashd as $scid"
    echo "We are good to continue"
else
    echo "The current user $id is different than $scid"
    echo "$scid is currently running the smartcashd process"
    echo "Please switch user to $scid"
    echo "Exiting"
    exit
fi

cd
# Changing the SSH Port to a custom number is a good security measure against DDOS attacks
# printf "Custom SSH Port(Enter to ignore): "
# read VARIABLE
# _sshPortNumber=${VARIABLE:-22}

# Create a directory for smartnode's cronjobs and the anti-ddos script
rm -r smartnode
mkdir smartnode

# Change the directory to ~/smartnode/
cd ~/smartnode/

# Download the appropriate scripts
wget https://rawgit.com/controllinghand/smartnode-checkonly/master/anti-ddos.sh
wget https://rawgit.com/controllinghand/smartnode-checkonly/master/makerun.sh
wget https://rawgit.com/controllinghand/smartnode-checkonly/master/checkdaemon.sh
wget https://rawgit.com/controllinghand/smartnode-checkonly/master/upgrade.sh
wget https://rawgit.com/controllinghand/smartnode-checkonly/master/clearlog.sh

# Create a cronjob for making sure smartcashd is always running
# SLG changed to every 10 mins to help keep it from stepping on setting up nodes and upgrades etc
# (crontab -l ; echo "*/10 * * * * ~/smartnode/makerun.sh") | crontab -
# Added LithMage method to keep from multiple entries
(crontab -l 2>/dev/null | grep -v -F "smartnode/makerun.sh" ; echo "*/1 * * * * ~/smartnode/makerun.sh" ) | crontab -
chmod 0700 ./makerun.sh

# Create a cronjob for making sure the daemon is never stuck
# (crontab -l ; echo "*/30 * * * * ~/smartnode/checkdaemon.sh") | crontab -
(crontab -l 2>/dev/null | grep -v -F "smartnode/checkdaemon.sh" ; echo "*/30 * * * * ~/smartnode/checkdaemon.sh" ) | crontab -
chmod 0700 ./checkdaemon.sh

# Create a cronjob for making sure smartcashd is always up-to-date
# (crontab -l ; echo "*/120 * * * * ~/smartnode/upgrade.sh") | crontab -
(crontab -l 2>/dev/null | grep -v -F "smartnode/upgrade.sh" ; echo "*/120 * * * * ~/smartnode/upgrade.sh" ) | crontab -
chmod 0700 ./upgrade.sh

# Create a cronjob for clearing the log file
# (crontab -l ; echo "0 0 */2 * * ~/smartnode/clearlog.sh") | crontab -
(crontab -l 2>/dev/null | grep -v -F "smartnode/clearlog.sh" ; echo "0 0 */2 * * ~/smartnode/clearlog.sh" ) | crontab -
chmod 0700 ./clearlog.sh

# Change the SSH port
# sed -i "s/[#]\{0,1\}[ ]\{0,1\}Port [0-9]\{2,\}/Port ${_sshPortNumber}/g" /etc/ssh/sshd_config
# sed -i "s/14855/${_sshPortNumber}/g" ~/smartnode/anti-ddos.sh

# Run the anti-ddos script You will need to put in your sudo password
echo "Installing anti-ddos script requires sudo password or root."
printf "Press Ctrl+C to cancel or Enter to continue:  "
read IGNORE
sudo bash ./anti-ddos.sh

# Reboot the server
echo "Rebooting the server so that changes will take effect."
printf "Press Ctrl+C to cancel or Enter to continue:  "
read IGNORE
sudo reboot
