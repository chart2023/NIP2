#!/bin/bash
echo "STEP:GET IPLBAAS"
user='chart'
host_os='192.168.9.14'
sudo -u ubuntu ssh-keygen -N "" -f /home/ubuntu/.ssh/id_rsa
keyfile="/home/ubuntu/.ssh/id_rsa.pub"
keydata=$(cat $keyfile)
echo $keydata
sudo expect /opt/openbaton/script/exchangekey.exp $keydata
iplbaas=$(ssh $user@$host_os "./request_vip_lbaas.sh")
echo "iplbaas="
echo $iplbaas
sudo echo "exports.iplbaas='$iplbaas';" | tee --append /home/ubuntu/OpenMTC-Chula/openmtc/settings/ipserv.js
