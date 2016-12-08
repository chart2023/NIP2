#!/bin/bash
echo "nip_ip=$nip_private" | sudo tee --append ${HOME}/nip_info.conf
echo "nip_fip=$nip_private_floatingIp" | sudo tee --append ${HOME}/nip_info.conf
echo "nip_hostname=$nip_hostname" | sudo tee --append ${HOME}/nip_info.conf
