#!/bin/bash
echo "START at:" $(date)
echo "db configure at NSCL"
echo "db_ip=$db_private" | sudo tee --append ${HOME}/db_info.conf
echo "db_fip=$db_private_floatingIp" | sudo tee --append ${HOME}/db_info.conf
echo "db_hostname=$db_hostname" | sudo tee --append ${HOME}/db_info.conf
echo "exports.ipdb='$db_private';" | tee --append /OpenMTC-Chula/openmtc/settings/ipserv.js
echo "STOP at:" $(date)
echo "##########FINISHED############"
