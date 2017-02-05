#!/bin/bash
echo "#############################"
echo "delete iplbaas at Openstack"
echo "START at:" $(date)
ipfile="./ipaddress.txt"
ipaddress=$(head -1 $ipfile)
source /root/nip_info.conf
echo "delete iplbaas:" $ipaddress
ssh -o StrictHostKeyChecking=no -i /openstack_key.pem -l ubuntu $nip_ip "/home/ubuntu/del_iplbaas_scale.sh $ipaddress"
echo "STOP at:" $(date)
echo "##########FINISHED############"
