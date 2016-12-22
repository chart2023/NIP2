#!/bin/bash
echo "STEP:GET IPLBAAS"
echo "START at:" $(date)
user='chart'
host_os='192.168.9.12'
ssh-keygen -N "" -f /root/.ssh/id_rsa
keyfile="/root/.ssh/id_rsa.pub"
keydata=$(cat $keyfile)
echo $keydata
expect /opt/openbaton/scripts/exchangekey.exp $keydata
iplbaas=$(ssh $user@$host_os "./request-vip-lbaas.sh")
echo "iplbaas="
echo $iplbaas
sudo echo "exports.iplbaas='$iplbaas';" | tee --append /OpenMTC-Chula/openmtc/settings/ipserv.js
echo "STOP at:" $(date)
echo "##########FINISHED############"
