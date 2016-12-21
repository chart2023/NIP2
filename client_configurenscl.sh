
#!/bin/bash
echo "client configure"
echo "nip_ip=$client_private" | sudo tee --append ${HOME}/nip_info.conf
echo "nip_fip=$client_private_floatingIp" | sudo tee --append ${HOME}/nip_info.conf
echo "nip_hostname=$client_hostname" | sudo tee --append ${HOME}/nip_info.conf
echo "STEP: REGISTER LBAAS"
user='chart'
host_os='192.168.9.12'
ipfile="./ipaddress.txt"
ipaddress=$(head -1 $ipfile)
ssh-keygen -N "" -f /root/.ssh/id_rsa
keyfile="/root/.ssh/id_rsa.pub"
keydata=$(cat $keyfile)
echo $keydata
expect /opt/openbaton/scripts/exchangekey.exp $keydata
ssh $user@$host_os "./add-iplbaas.sh $ipaddress"
