#!/bin/bash
$user='ubuntu'
$dbhost='192.168.9.122'
wget http://192.168.9.14:8080/v1/AUTH_b8e61c4a0b1b4d2f82929563cab8c55a/openmtc/openstack_key14.pem --output-document=${HOME}/openstack_key14.pem
sudo chmod 600 ${HOME}/openstack_key14.pem
sudo nohup sudo node ${HOME}/OpenMTC-Chula/nscl >${HOME}/nscl.log 2>${HOME}/nscl.err &
sleep 5
ssh -o StrictHostKeyChecking=no -i ${HOME}/openstack_key14.pem -l $user $dbhost --eval "mongo --port 27020 initshard.js"
