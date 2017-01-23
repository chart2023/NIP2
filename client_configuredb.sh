#!/bin/bash
THISHOST=$(hostname)
ipfile="./ipaddress.txt"
THISIP=$(head -1 $ipfile)
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
SERVICE='mongos'
if [ $MAINDB_IP = $THISIP];
then
        echo "STEP: REGISTER MAIN SHARD"
        REPLSET=$(head -1 /home/ubuntu/db_info.conf)
        sudo rm -rf /var/lib/mongod
        #sudo mongod --shardsvr --replSet $REPLSET --dbpath /var/lib/mongod --fork --syslog --port 27017
        #sleep 3
        #mongo --port 27017 --eval "rs.initiate()"
        #sleep 3
        #mongo --host $ipaddress --port 27020 --eval "sh.addShard( '$REPLSET/$THISHOST:27017' )"
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
        echo "FINISHED at:" $(date)
else
        echo "STEP: REGISTER extended SHARD"
        #MAINREPLSET=$(ssh -o StrictHostKeyChecking=no -i /openstack_key.pem -l ubuntu $MAINDB_IP "sudo head -1 /home/ubuntu/db_info.conf")
        REPLSET=$(head -1 /home/ubuntu/db_info.conf)
        sudo rm -rf /var/lib/mongod
        #MYHOST="$MAINREPLSET/$THISHOST:27017"
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
        echo "FINISHED at:" $(date)
fi
echo "##########FINISHED############"
