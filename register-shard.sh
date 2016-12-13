#!/bin/bash
echo "STEP: REGISTER SHARD"
$REPLSET=$(head -1 ${HOME}/db_info.conf)
ipfile="./ipaddress.txt"
ipaddress=$(head -1 $ipfile)
sudo rm -rf /var/lib/mongod
sudo mkdir /var/lib/mongod
sudo mongod --shardsvr --replSet $REPLSET --dbpath /var/lib/mongod --fork --syslog --port 27017
sleep 3
mongo --port 27017 --eval "rs.initiate()"
sleep 3
mongo --host $ipaddress --port 27020 --eval "sh.addShard( '$REPLSET/$THISHOST:27017' )"
