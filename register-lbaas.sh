#!/bin/bash
user='chart'
host_os='192.168.9.14'
ipfile="./ipaddress.txt"
ipaddress=$(head -1 $ipfile)
ssh-keygen
keyfile="${HOME}/.ssh/id_rsa.pub"
keydata=$(cat $keyfile)
echo $keydata
expect ./exchangekey.exp $keydata
ssh $user@$host_os "./add-iplbaas.sh $ipaddress")
