#!/bin/bash
echo "START NSCL"
echo "START at:" $(date)
user='ubuntu'
source /root/db_info.conf
dbhost=$db_ip
#dbhost='192.168.9.122'

echo "STOP at:" $(date)
echo "##########FINISHED############"
for i in {1..5}
do
        nc -z -v $dbhost 27017
        if [ $? -eq 0 ];
        then
                nohup node /OpenMTC-Chula/nscl >/home/ubuntu/nscl.log 2>/home/ubuntu/nscl.err &
                sleep 5
                expect /opt/openbaton/scripts/init-shard.exp $dbhost
                break
        else
        echo "Mongos stopped:$i on start_nscl"
        sleep 15
        fi
done
