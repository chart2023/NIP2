#!/bin/bash
echo "STEP1: INSTANTIATE NIP"
echo "START at:" $(date)
myhome=${HOME}
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
cp /opt/openbaton/scripts/start-nip.sh /etc/init.d/start-nip.sh
chmod ugo+x /etc/init.d/start-nip.sh
update-rc.d start-nip.sh defaults
sudo rm -rf /OpenMTC-Chula/openmtc/settings/ipserv.js
echo "exports.ipopenstack='${publicip}';" | tee --append /OpenMTC-Chula/openmtc/settings/ipserv.js
cp /opt/openbaton/scripts/openstack.info /home/ubuntu/openstack.info
cp /opt/openbaton/scripts/add-iplbaas.sh /home/ubuntu/add-iplbaas.sh
cp /opt/openbaton/scripts/del_iplbaas_scale.sh /home/ubuntu/del_iplbaas_scale.sh
chmod 755 /home/ubuntu/add-iplbaas.sh /home/ubuntu/del_iplbaas_scale.sh
ntpq -p
echo "STOP at:" $(date)
echo "##########FINISHED############"
