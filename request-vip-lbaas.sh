#!/bin/bash
source /home/chart/devstack/openrc admin admin >/dev/null
neutron lbaas-loadbalancer-show 'loadbalancer1' | awk '$2 == "vip_address" {print $4}'
echo "STOP at:" $(date)
echo "##########FINISHED############"
