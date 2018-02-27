# The anti-ddos script was not working properly so decided to remove it
cd
cd smartnode
rm anti-ddos.sh

# New security measures using ufw
_sshPortNumber=$(grep "^[#]\{0,1\}[ ]\{0,1\}Port [0-9]\{2,\}" /etc/ssh/sshd_config | awk '{print $2}')
apt install ufw
ufw disable
ufw allow 9678
ufw allow "$_sshPortNumber"/tcp
ufw limit "$_sshPortNumber"/tcp
ufw logging on
ufw default deny incoming
ufw default allow outgoing
ufw --force enable
