#!/bin/bash
NIP_START_TIME=$(date)
MYHOME=${HOME}
THISHOST=$(hostname)
log_file="$MYHOME/install-log.txt"
[ -f "$log_file" ] || touch "$log_file"
exec 1>> $log_file 2>&1
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
cp /opt/openbaton/scripts/initshard.js ${HOME}/initshard.js

