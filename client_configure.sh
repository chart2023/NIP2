#!/bin/bash
echo "nip_ip=$client_private" | sudo tee --append ${HOME}/nip_info.conf
echo "nip_fip=$client_private_floatingIp" | sudo tee --append ${HOME}/nip_info.conf
echo "nip_hostname=$client_hostname" | sudo tee --append ${HOME}/nip_info.conf
