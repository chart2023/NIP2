#!/bin/bash
sudo rm -rf ${HOME}/nscl_info.conf
echo "nscl_ip=$nscl_private" | tee --append ${HOME}/nscl_info.conf
echo "nscl_fip=$nscl_private_floatingIp" | tee --append ${HOME}/nscl_info.conf
echo "nscl_hostname=$nscl_hostname" | tee --append ${HOME}/nscl_info.conf
sudo rm -rf ${HOME}/OpenMTC-Chula/openmtc/settings/ipserv.js
#SET IP LBaaS
echo "exports.ipnscl='$nscl_private';" | tee --append ${HOME}/OpenMTC-Chula/openmtc/settings/ipserv.js
#echo "exports.iplbaas='10.0.14.7';" | tee --append ${HOME}/OpenMTC-Chula/openmtc/settings/ipserv.js
#Set IP NSCL
#echo "exports.ipnscl='$nscl_private';" | tee --append ${HOME}/OpenMTC-Chula/openmtc/settings/ipserv.js
sudo bash -c "echo exports.ipnip=\'`ifconfig eth0 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://'`\'\; >> ${HOME}/OpenMTC-Chula/openmtc/settings/ipserv.js"
echo "exports.fipnip='$nscl_private_floatingIp';" >> tee --append ${HOME}/OpenMTC-Chula/openmtc/settings/ipserv.js
echo "exports.ipopenstack='192.168.9.14';" >> tee --append ${HOME}/OpenMTC-Chula/openmtc/settings/ipserv.js
