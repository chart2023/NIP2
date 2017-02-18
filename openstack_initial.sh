#!/bin/bash
#sudo apt-get update
#sudo apt-get install python-openstackclient
#source ${HOME}/devstack/openrc admin admin
. ${HOME}/admin-rc
openstack image create "openmtcv8" --file ./openmtcv82.qcow2 --disk-format qcow2 \
--container-format bare --public
openstack image list
openstack network create private
openstack subnet create --network private --subnet-range 10.0.12.0/24 --gateway 10.0.12.1 \
--dns-nameserver 161.200.80.1 private_subnet
openstack router create router1
neutron router-gateway-set router1 public
neutron router-interface-add router1 private_subnet
openstack keypair create --public-key ${HOME}/id_rsa12.pub openstack_key12
openstack keypair list
openstack security group create openstack_sec12 --description openstack_withOpenBaton
openstack security group rule create --protocol icmp openstack_sec12
openstack security group rule create openstack_sec12 \
--protocol tcp --dst-port 22:22 --remote-ip 0.0.0.0/0
openstack security group rule create openstack_sec12 \
--protocol tcp --dst-port 80:80 --remote-ip 0.0.0.0/0
openstack security group rule create openstack_sec12 \
--protocol tcp --dst-port 1000:1000 --remote-ip 0.0.0.0/0
openstack security group rule create openstack_sec12 \
--protocol tcp --dst-port 8081:8081 --remote-ip 0.0.0.0/0
openstack security group rule create openstack_sec12 \
--protocol tcp --dst-port 15000:15000 --remote-ip 0.0.0.0/0
openstack security group rule create openstack_sec12 \
--protocol tcp --dst-port 10050:10050 --remote-ip 0.0.0.0/0
for i in {1..15}
do
  openstack floating ip create public
done
openstack floating ip list
neutron lbaas-loadbalancer-create --name loadbalancer1 private_subnet
neutron lbaas-loadbalancer-show loadbalancer1
neutron lbaas-listener-create --loadbalancer loadbalancer1 --protocol HTTP --protocol-port 15000 --name listener1
neutron lbaas-pool-create --lb-algorithm ROUND_ROBIN --listener listener1 --protocol HTTP --name pool1
