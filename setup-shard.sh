#!/bin/bash
#####################
# Once time run
# Run by setup_nip.sh at NIP in INSTANTIATE state
##PARAMETER
START_TIME=$(date)
MYHOME=${HOME}
THISHOST=$(hostname)
QUERY_ROUTER="192.168.9.122"
#REPLSET=$(cat /dev/urandom | tr -dc 'A-Z' | fold -w 3 | head -n 1)
log_file="$MYHOME/install-log.txt"
[ -f "$log_file" ] || touch "$log_file"
exec 1>> $log_file 2>&1
sudo service mongod stop
sudo rm -rf /var/lib/mongodbs
sudo rm -rf /var/lib/mongod
sudo mkdir /var/lib/mongodbs
sudo mongod --configsvr --replSet configReplSet --port 27019 --dbpath /var/lib/mongodbs --fork --syslog
sleep 5
mongo --port 27019 --eval "rs.initiate()"
sleep 7
#sudo mkdir /var/lib/mongod
#sudo mongod --shardsvr --replSet $REPLSET --dbpath /var/lib/mongod --fork --syslog --port 27017
#sleep 3
#mongo --port 27017 --eval "rs.initiate()"
#sleep 3
service=mongos
for i in {1..5}
do
        if (( $(ps -ef | grep -v grep | grep $service | wc -l) > 0 ))
        then
                echo "$service is running!!!"
                break
        else
        echo "$service stopped:$i"
        sudo mongos --configdb configReplSet/$THISHOST:27019 --port 27020 --fork --logpath /var/log/mongodb/mongos.log
        sleep 10
        fi
done
#mongo --host $THISHOST --port 27020 --eval "show dbs"
cp /opt/openbaton/scripts/init-mongo.sh /etc/init.d/init-mongo.sh
chmod ugo+x /etc/init.d/init-mongo.sh
update-rc.d init-mongo.sh defaults
