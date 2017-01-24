#!/bin/bash
echo "db configure at NIP"
echo "START at:" $(date)
DBFILE=/home/ubuntu/db_info.conf
#echo "db_ip=$db_private" | sudo tee --append ${HOME}/db_info.conf
#echo "db_fip=$db_private_floatingIp" | sudo tee --append ${HOME}/db_info.conf
#echo "db_hostname=$db_hostname" | sudo tee --append ${HOME}/db_info.conf
echo "$db_private $db_hostname" | sudo tee --append $DBFILE
echo "exports.ipdb='$db_private';" | tee --append /OpenMTC-Chula/openmtc/settings/ipserv.js
echo "$db_private" | sudo tee --append /home/ubuntu/maindb_info.conf
#source ${HOME}/db_info.conf
#MAINDB_IP=$(head -1 /home/ubuntu/maindb_info.conf)
NUM_DB=$(cat $DBFILE | wc -l)
echo $NUM_DB
MAINDB_IP=$(awk -F' ' '{ print $1}' $DBFILE | head -1)
echo $MAINDB_IP
MAINDB_NAME=$(awk -F' ' '{ print $2}' $DBFILE | head -1)
echo $MAINDB_NAME
MAINDB_INFO=$(head -1 $DBFILE)
echo $MAINDB_INFO
THISDB_INFO=$(tail -1 $DBFILE)
echo $THISDB_INFO
THISDB_NAME=$(awk -F' ' '{ print $2}' $DBFILE | tail -1)
if [ $MAINDB_IP = $db_private ];
then
  echo "THIS IS MAIN DB"
  expect /opt/openbaton/scripts/setup-shard.exp $db_private
else
  echo "THIS IS EXTENDED DB"
  ##Add new DB hostname to MAIN DB
  ssh -o StrictHostKeyChecking=no -i /openstack_key.pem -l ubuntu MAINDB_IP "echo $THISDB_INFO | sudo tee --append /etc/hosts" 
  ##Add Main DB hostname to extend DB
  THISDB_IP=$(awk -F' ' '{ print $1}' $DBFILE | tail -1)
  ssh -o StrictHostKeyChecking=no -i /openstack_key.pem -l ubuntu $db_private "echo $MAINDB_INFO | sudo tee --append /etc/hosts"
  REPLSET=$(ssh -o StrictHostKeyChecking=no -i /openstack_key.pem -l ubuntu $db_private "head -1 /home/ubuntu/db_info.conf")
  REPLSETID="$REPLSET/$THISDB_NAME:27017"
  mongo --host $MAINDB_IP --port 27020 --eval "sh.addShard( '$REPLSETID' )"
fi
echo "FINISED at:" $(date)
echo "##########FINISHED############"
