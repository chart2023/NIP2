#!/bin/bash
echo "START at:" $(date)
ipfile="./ipaddress.txt"
ipaddress=$(head -1 $ipfile)
sudo rm -rf ${HOME}/nscl_info.conf
echo "nscl_ip=$server_private" | tee --append ${HOME}/nscl_info.conf
echo "nscl_fip=$server_private_floatingIp" | tee --append ${HOME}/nscl_info.conf
echo "nscl_hostname=$server_hostname" | tee --append ${HOME}/nscl_info.conf
sudo rm -rf /OpenMTC-Chula/openmtc/settings/ipserv.js
#SET IP LBaaS
echo "exports.ipnscl='$server_private';" | tee --append /OpenMTC-Chula/openmtc/settings/ipserv.js
#echo "exports.iplbaas='10.0.14.7';" | tee --append ${HOME}/OpenMTC-Chula/openmtc/settings/ipserv.js
#Set IP NSCL
#echo "exports.ipnscl='$nscl_private';" | tee --append ${HOME}/OpenMTC-Chula/openmtc/settings/ipserv.js
echo "exports.ipnip='$ipaddress';" | tee --append /OpenMTC-Chula/openmtc/settings/ipserv.js
echo "exports.fipnscl='$server_private_floatingIp';" | tee --append /OpenMTC-Chula/openmtc/settings/ipserv.js
echo "exports.ipopenstack='161.200.90.78';" | tee --append /OpenMTC-Chula/openmtc/settings/ipserv.js
echo "STOP at:" $(date)
echo "##########FINISHED############"
