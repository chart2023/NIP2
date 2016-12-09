#!/bin/bash
#############################
#1. Setup host ip
#2. Setup start_nip.sh to start when instance boot
############################
NIP_START_TIME=$(date)
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
cp /opt/openbaton/scripts/start-nip.sh /etc/init.d/start-nip.sh
chmod ugo+x /etc/init.d/start-nip.sh
update-rc.d start-nip.sh defaults
ntpq -p
wget http://192.168.9.14:8080/v1/AUTH_b8e61c4a0b1b4d2f82929563cab8c55a/openmtc/openstack_key14.pem --output-document=${HOME}/openstack_key14.pem
sudo chmod 600 ${HOME}/openstack_key14.pem
$user='ubuntu'
$dbhost='192.168.9.122'
ssh -o StrictHostKeyChecking=no -i ${HOME}/openstack_key14.pem -l $user $dbhost --eval "bash /opt/openbaton/scripts/setup-shard.sh"
