#!/bin/bash
echo "START at:" $(date)
echo "add iplbaas"
ipaddress=$1
source ${HOME}/devstack/openrc admin admin >/dev/null
neutron lbaas-member-create  --subnet private-subnet --address $ipaddress --protocol-port 15000 pool1
echo "STOP at:" $(date)
