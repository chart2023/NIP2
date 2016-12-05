#!/bin/bash
#sudo touch /opt/openbaton/clientinfo.txt
#sudo bash -c 'echo $client_private > /opt/openbaton/clientinfo.txt'
#sudo bash -c 'echo $client_private_floatingIp >> /opt/openbaton/clientinfo.txt'
echo "nscl_ip=$nscl_private" | sudo tee --append ${HOME}/nscl_info.conf
echo "nscl_fip=$nscl_private_floatingIp" | sudo tee --append ${HOME}/nscl_info.conf
echo "nscl_hostname=$nscl_hostname" | sudo tee --append ${HOME}/nscl_info.conf
#echo "listen_addresses = 'localhost, $ipaddress'" | sudo tee --append /var/lib/pgsql/9.3/data/postgresql.conf
