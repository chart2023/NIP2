#!/bin/bash
NSCL_START_TIME=$(date)
myhome=${HOME}
log_file="$myhome/install-log.txt"
[ -f "$log_file" ] || touch "$log_file"
exec 1>> $log_file 2>&1
rm -rf /opt/openbaton/scripts/
dpkg-reconfigure -f noninteractive tzdata
apt-get update
apt-get install --reinstall tzdata -y
ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' > ./ipaddress.txt
ipfile="./ipaddress.txt"
ipaddress=$(head -1 $ipfile)
bash -c "echo $ipaddress `cat /etc/hostname` >> /etc/hosts"
wget -q --tries=10 --timeout=20 --spider  http://archive.ubuntu.com
if [[ $? -eq 0 ]]; then
        echo "Server can connect to Internet"
else
        echo "Server cannot connect to Internet"
fi
cp /opt/openbaton/scripts/start-nscl.sh /etc/init.d/start-nscl.sh
chmod ugo+x /etc/init.d/start-nscl.sh
update-rc.d start-nscl.sh defaults
ntpq -p
