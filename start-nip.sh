#!/bin/bash
#$user='ubuntu'
#$dbhost='192.168.9.122'
#wget http://192.168.9.14:8080/v1/AUTH_b8e61c4a0b1b4d2f82929563cab8c55a/openmtc/openstack_key14.pem --output-document=${HOME}/openstack_key14.pem
#sudo chmod 600 ${HOME}/openstack_key14.pem
#ssh -o StrictHostKeyChecking=no -i ${HOME}/openstack_key14.pem -l $user $dbhost --eval "mongo --port 27020 initshard.js"
sleep 30
sudo nohup sudo node ${HOME}/OpenMTC-Chula/openmtc-NIP/ProxyGateway/NIP_IEEE1888_ETSI.js >${HOME}/ieee.log 2>${HOME}/ieee.err &
sleep 10
sudo nohup sudo node ${HOME}/OpenMTC-Chula/openmtc-NIP/ProxyGateway/NIP_ETSI_IEEE1888_nscl.js >${HOME}/etsi.log 2>${HOME}/etsi.err &
