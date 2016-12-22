#!/bin/bash
echo "client configure"
echo "nip_ip=$client_private" | sudo tee --append ${HOME}/nip_info.conf
echo "nip_ip2=${client_private}" | sudo tee --append ${HOME}/nip_info.conf
