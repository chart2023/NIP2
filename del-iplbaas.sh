#!/bin/bash
echo "#############################"
echo "delete iplbaas at Openstack"
echo "START at:" $(date)
host_os='192.168.9.12'
ipfile="./ipaddress.txt"
ipaddress=$(head -1 $ipfile)
ssh $user@$host_os "./delete-iplbaas.sh $ipaddress"
echo "STOP at:" $(date)
echo "##########FINISHED############"
