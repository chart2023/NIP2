#!/bin/bash
echo "client configure at DB-SERVER"
echo "START at:" $(date)
echo "nip_ip=$client_private" | sudo tee --append ${HOME}/nip_info.conf
echo "nip_fip=$client_private_floatingIp" | sudo tee --append ${HOME}/nip_info.conf
echo "nip_hostname=$client_hostname" | sudo tee --append ${HOME}/nip_info.conf
MAINDB_IP=''
for i in {1..5}
do
        MAINDB_IP=$(ssh -o StrictHostKeyChecking=no -i /openstack_key.pem -l ubuntu $client_private "sudo head -1 /home/ubuntu/maindb_info.conf")
        if [ -z "$MAINDB_IP"];
        then
                echo "MAINDB_IP=NULL"
                sleep 15
        else
                echo "MAINDB_IP:" $MAINDB_IP
                break
        fi
done
echo "STEP: REGISTER SHARD"
THISHOST=$(hostname)
REPLSET=$(head -1 ${HOME}/db_info.conf)
sudo rm -rf /var/lib/mongod
#sudo mongod --shardsvr --replSet $REPLSET --dbpath /var/lib/mongod --fork --syslog --port 27017
#sleep 3
#mongo --port 27017 --eval "rs.initiate()"
#sleep 3
#mongo --host $ipaddress --port 27020 --eval "sh.addShard( '$REPLSET/$THISHOST:27017' )"
SERVICE='mongos'
MYHOST="$REPLSET/$THISHOST:27017"
for i in {1..5}
do
        nc -z -v $MAINDB_IP 27020
        if [ $? -eq 0 ];
        then
                echo "$SERVICE is running!!!"
                sudo mkdir /var/lib/mongod
                sudo mongod --shardsvr --replSet $REPLSET --dbpath /var/lib/mongod --fork --syslog --port 27017
                sleep 3
                mongo --port 27017 --eval "rs.initiate()"
                sleep 3
                mongo --host $MAINDB_IP --port 27020 --eval "sh.addShard( '$MYHOST' )"
                break
        else
        echo "$service stopped:$i on client_configuredb.sh"
        sleep 15
        fi
done
echo "STOP at:" $(date)
echo "##########FINISHED############"
