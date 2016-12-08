#!/bin/bash
$REPLSET=$(head -1 ${HOME}/db_info.conf)
QUERY_ROUTER="192.168.9.122"
sudo rm -rf /var/lib/mongod
sudo mkdir /var/lib/mongod
sudo mongod --shardsvr --replSet $REPLSET --dbpath /var/lib/mongod --fork --syslog --port 27017
sleep 3
mongo --port 27017 --eval "rs.initiate()"
sleep 3
mongo --host $QUERY_ROUTER --port 27020 --eval "sh.addShard( '$REPLSET/$THISHOST:27017' )"
