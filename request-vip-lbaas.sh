#!/bin/bash
source ${HOME}/devstack/openrc admin admin >/dev/null
#neutron lbaas-loadbalancer-create --name lb1 private_subnet
#neutron lbaas-loadbalancer-show lb1
#neutron lbaas-listener-create --loadbalancer lb1 --protocol HTTP --protocol-port 15000 --name listener1
#neutron lbaas-pool-create --lb-algorithm ROUND_ROBIN --listener listener1 --protocol HTTP --name pool1
neutron lbaas-loadbalancer-show lb1 | awk '$2 == "vip_address" {print $4}'
