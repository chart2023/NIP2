#!/bin/bash
user='ubuntu'
dbhost='192.168.9.122'
#wget http://192.168.9.14:8080/v1/AUTH_b8e61c4a0b1b4d2f82929563cab8c55a/openmtc/openstack_key14.pem -o /openstack_key14.pem
sudo chmod 600 /openstack_key14.pem
sudo nohup sudo node /home/ubuntu/OpenMTC-Chula/nscl >/home/ubuntu/nscl.log 2>/home/ubuntu/nscl.err &
sleep 5
#ssh -o StrictHostKeyChecking=no -i /openstack_key14.pem -l $user $dbhost "mongo --port 27020 initshard.js"
expect /opt/openbaton/scripts/init-shard.exp $dbhost
