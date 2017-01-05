#!/bin/bash
echo "STEP1: INSTANTIATE NSCL"
echo "START at:" $(date)
NSCL_START_TIME=$(date)
myhome=${HOME}
#keyfile=${keyfile}
#keyname=${keyname}
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
echo "nscl_ip=${private}" | sudo tee --append ${HOME}/nscl_info.conf
echo "nscl_fip=${private_floatingIp}" | sudo tee --append ${HOME}/nscl_info.conf
cp /opt/openbaton/scripts/start-nscl.sh /etc/init.d/start-nscl.sh
chmod ugo+x /etc/init.d/start-nscl.sh
update-rc.d start-nscl.sh defaults
ntpq -p
#rm -rf ./$keyname*
#wget $keyfile
chmod 600 /$keyname
echo "STOP at:" $(date)
echo "##########FINISHED############"
