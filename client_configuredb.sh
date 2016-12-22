#!/bin/bash
echo "client configure at db"
echo "nip_ip=$client_private" | sudo tee --append ${HOME}/nip_info.conf
echo "nip_fip=$client_private_floatingIp" | sudo tee --append ${HOME}/nip_info.conf
echo "nip_hostname=$client_hostname" | sudo tee --append ${HOME}/nip_info.conf
maindb_ip=$(ssh -o StrictHostKeyChecking=no -i openstack_key.pem -l ubuntu $client_private "cat /home/ubuntu/maindb_info.txt")
echo "STEP: REGISTER SHARD"
THISHOST=$(hostname)
REPLSET=$(head -1 ${HOME}/db_info.conf)
ipfile="./ipaddress.txt"
ipaddress=$(head -1 $ipfile)
sudo rm -rf /var/lib/mongod
sudo mkdir /var/lib/mongod
#sudo mongod --shardsvr --replSet $REPLSET --dbpath /var/lib/mongod --fork --syslog --port 27017
#sleep 3
#mongo --port 27017 --eval "rs.initiate()"
#sleep 3
#mongo --host $ipaddress --port 27020 --eval "sh.addShard( '$REPLSET/$THISHOST:27017' )"
service=mongos
for i in {1..5}
do
        nc -z -v $maindb_ip 27020
        if [ $? -eq 0 ];
        then
                echo "$service is running!!!"
                sudo mongod --shardsvr --replSet $REPLSET --dbpath /var/lib/mongod --fork --syslog --port 27017
                sleep 3
                mongo --port 27017 --eval "rs.initiate()"
                sleep 3
                mongo --host $ipaddress --port 27020 --eval "sh.addShard( '$REPLSET/$THISHOST:27017' )"
                break
        else
        echo "$service stopped:$i on client_configuredb.sh"
        sleep 15
        fi
done
