#!/bin/bash
echo "START NSCL"
echo "START at:" $(date)
user='ubuntu'
source /root/db_info.conf
dbhost=$db_ip
#dbhost='192.168.9.122'
nohup node /OpenMTC-Chula/nscl >/home/ubuntu/nscl.log 2>/home/ubuntu/nscl.err &
sleep 5
expect /opt/openbaton/scripts/init-shard.exp $dbhost
echo "STOP at:" $(date)
echo "##########FINISHED############"
