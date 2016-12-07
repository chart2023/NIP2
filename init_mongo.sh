#!/bin/bash
#################
#This script run at Mongodb instance if Mongodb instance rebooted.
#This script start query router, configserver, sharding again.
#################
THISHOST=$(hostname)
MONGODBINFO=${HOME}/mongodb_info.conf
REPLSET=$(head -1 $MONGODBINFO)
sudo mongod --configsvr --replSet configReplSet --port 27019 --dbpath /var/lib/mongodbs --fork --syslog
sleep 5
sudo mongod --shardsvr --replSet $REPLSET --dbpath /var/lib/mongod --fork --syslog --port 27017
sleep 5
sudo mongos --configdb configReplSet/$THISHOST:27019 --port 27020 --fork --syslog
