#!/bin/bash
echo "STEP: INSTANTIATE MONGODB"
echo "START at:" $(date)
MYHOME=${HOME}
THISHOST=$(hostname)
date +%s | sha256sum | base64 | head -c 3 >> /home/ubuntu/db_info.conf
dpkg-reconfigure -f noninteractive tzdata
apt-get update
apt-get install --reinstall tzdata -y
ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' > ./ipaddress.txt
ipfile="./ipaddress.txt"
ipaddress=$(head -1 $ipfile)
#bash -c "echo $ipaddress `cat /etc/hostname` >> /etc/hosts"
bash -c "echo $ipaddress $THISHOST >> /etc/hosts"
wget -q --tries=10 --timeout=20 --spider  http://archive.ubuntu.com
if [[ $? -eq 0 ]]; then
        echo "Server can connect to Internet"
else
        echo "Server cannot connect to Internet"
fi
ntpq -p
cp /opt/openbaton/scripts/initshard_bigfile.js /home/ubuntu/initshard.js
chown ubuntu:ubuntu /home/ubuntu/initshard.js
chmod 755 /home/ubuntu/initshard.js
echo "STOP at:" $(date)
echo "##########FINISHED############"
