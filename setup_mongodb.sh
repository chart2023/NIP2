#!/bin/bash
NIP_START_TIME=$(date)
MYHOME=${HOME}
THISHOST=$(hostname)
$REPLSET=$(cat /dev/urandom | tr -dc 'A-Z' | fold -w 3 | head -n 1)
log_file="$MYHOME/install-log.txt"
[ -f "$log_file" ] || touch "$log_file"
exec 1>> $log_file 2>&1
ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' > ./ipaddress.txt
ipfile="./ipaddress.txt"
ipaddress=$(head -1 $ipfile)
#bash -c "echo $ipaddress `cat /etc/hostname` >> /etc/hosts"
bash -c "echo $ipaddress $THISHOST >> /etc/hosts"
wget -q --tries=10 --timeout=20 --spider  http://archive.ubuntu.com
if [[ $? -eq 0 ]]; then
        echo "Server can connect to Internet"
else
        echo "Server cannot connect to Internet"
fi
ntpq -p
sudo service mongod stop
sudo rm -rf /var/lib/mongodbs
sudo rm -rf /var/lib/mongod
sudo mkdir /var/lib/mongodbs
sudo mongod --configsvr --replSet configReplSet --port 27019 --dbpath /var/lib/mongodbs --fork --syslog
sleep 3
mongo --port 27019 --eval "rs.initiate()"
sudo mkdir /var/lib/mongod
sudo mongod --shardsvr --replSet $REPLSET --dbpath /var/lib/mongod --fork --syslog --port 27017
mongo --port 27017 --eval "rs.initiate()"
sudo mongos --configdb configReplSet/$THISHOST:27019 --port 27020 --fork --syslog
mongo --host $THISHOST --port 27020 --eval "sh.addShard( '$REPLSET/$THISHOST:27017' )"
