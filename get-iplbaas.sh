#!/bin/bash
user='chart'
host_os='192.168.9.14'
ssh-keygen
keyfile="${HOME}/.ssh/id_rsa.pub"
keydata=$(cat $keyfile)
echo $keydata
expect ./exchangekey.exp $keydata
iplbaas=$(ssh $user@$host_os "./request_vip_lbaas.sh")
echo $iplbaas
echo "exports.iplbaas='$iplbaas';" | tee --append ${HOME}/OpenMTC-Chula/openmtc/settings/ipserv.js
