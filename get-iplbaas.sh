#!/bin/bash
echo "STEP:GET IPLBAAS"
user='chart'
host_os='192.168.9.14'
ssh-keygen -N "" -f /root/.ssh/id_rsa
keyfile="/root/.ssh/id_rsa.pub"
keydata=$(cat $keyfile)
echo $keydata
expect /opt/openbaton/scripts/exchangekey.exp $keydata
iplbaas=$(ssh $user@$host_os "./request_vip_lbaas.sh")
echo "iplbaas="
echo $iplbaas
sudo echo "exports.iplbaas='$iplbaas';" | tee --append /OpenMTC-Chula/openmtc/settings/ipserv.js
