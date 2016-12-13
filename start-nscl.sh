#!/bin/bash
user='ubuntu'
dbhost='192.168.9.122'
rm -rf ./openstack_key14.pem*
wget http://192.168.9.14:8080/v1/AUTH_b8e61c4a0b1b4d2f82929563cab8c55a/openmtc/openstack_key14.pem
chmod 600 /openstack_key14.pem
nohup node /home/ubuntu/OpenMTC-Chula/nscl >/home/ubuntu/nscl.log 2>/home/ubuntu/nscl.err &
sleep 5
ssh -o StrictHostKeyChecking=no -i ./openstack_key14.pem -l $user $dbhost "mongo --port 27020 initshard.js"
#expect /opt/openbaton/scripts/init-shard.exp $dbhost
