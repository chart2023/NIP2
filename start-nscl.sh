#!/bin/bash
echo "START NSCL"
echo "START at:" $(date)
user='ubuntu'
source /root/db_info.conf
dbhost=$db_ip
#dbhost='192.168.9.122'
user1='chart'
host_os='192.168.9.12'
ipfile="./ipaddress.txt"
ipaddress=$(head -1 $ipfile)
echo "STOP at:" $(date)
for i in {1..5}
do
        nc -z -v $dbhost 27017
        if [ $? -eq 0 ];
        then
                echo "Mongos have already started"
                nohup node /OpenMTC-Chula/nscl >/home/ubuntu/nscl.log 2>/home/ubuntu/nscl.err &
                sleep 15
                #expect /opt/openbaton/scripts/init-shard.exp $dbhost
                for j in {1..5}
                do
                     nc -z -v $ipaddress 15000
                     if [ $? -eq 0 ];
                        then   
                        ssh $user1@$host_os "./add-iplbaas.sh $ipaddress"
                        break
                        else
                        echo "NSCL is not working on NSCL"
                        sleep 5
                        fi
                done
            break
        else
        echo "Mongos stopped:$i on start_nscl"
        sleep 15
        fi
done
echo "##########FINISHED############"
