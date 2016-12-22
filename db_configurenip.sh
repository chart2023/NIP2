#!/bin/bash
echo "db configure at NIP"
echo "db_ip=$db_private" | sudo tee --append ${HOME}/db_info.conf
echo "db_fip=$db_private_floatingIp" | sudo tee --append ${HOME}/db_info.conf
echo "db_hostname=$db_hostname" | sudo tee --append ${HOME}/db_info.conf
echo "exports.ipdb='$db_private';" | tee --append /OpenMTC-Chula/openmtc/settings/ipserv.js
echo "$db_private" | sudo tee --append /home/ubuntu/maindb_info.conf
source ${HOME}/db_info.conf
dbhost=$db_ip
expect /opt/openbaton/scripts/setup-shard.exp $dbhost
echo "#############FINISHED################"
