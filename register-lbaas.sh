#!/bin/bash
echo "STEP: REGISTER LBAAS"
user='chart'
host_os='192.168.9.14'
ipfile="./ipaddress.txt"
ipaddress=$(head -1 $ipfile)
ssh-keygen -N "" -f /root/.ssh/id_rsa
keyfile="/root/.ssh/id_rsa.pub"
keydata=$(cat $keyfile)
echo $keydata
expect /opt/openbaton/scripts/exchangekey.exp $keydata
ssh $user@$host_os "./add-iplbaas.sh $ipaddress")
