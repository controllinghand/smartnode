# SmartNode
### Bash Checker for smartnode on Ubuntu 16.04 LTS x64
### (!) No need to run this if you already used the official bash installer
### ATTENTION: This installer is only suitable for a dedicated vps. The anti-ddos script in this installer will disable all ports including the http, https and dns ports.
### This gives you the option to change the SSH port default but can be skipped

### This is from the great work of https://forum.smartcash.cc/u/msg768
### This script Assumes you already have a Smartnode installed.  If you need to install a new Smartnode you may want to use the installer script provided by @msg786 https://github.com/SmartCash/smartnode or you can follow my guide at https://forum.smartcash.cc/t/smartcash-smartnode-setup-guide-v2-1-mac-version-quick-setup/3022

### You must run this script as smartadmin or ID you used to run smartcashd some people installed as root and that's ok. At the end of the script you will be asked for a sudo password to run the anti-ddos script and reboot command

#### This shell script comes with 4 cronjobs: 
1. Make sure the daemon is always running: `makerun.sh`
2. Make sure the daemon is never stuck: `checkdaemon.sh`
3. Make sure smartcash is always up-to-date: `upgrade.sh`
4. Clear the log file every other day: `clearlog.sh`

#### And an anti-ddos script
5. Disable all ports including the http, https and dns ports: `anti-ddos.sh`

#### Login to your vps as smartadmin or ID you used to run smartcashd, donwload the installck.sh file and then run it:
```
wget https://rawgit.com/controllinghand/smartnode-checkonly/master/installck.sh
bash ./installck.sh
```
#### At the end of the install your server will reboot so that the anti-ddos and cron jobs will take effect

### Donation to my Smartcash please: SebFkuHrqDnj3obXvMtfxtQKRgFeVpXF5x
