#!/bin/bash
echo "START at:" $(date) "by" $(hostname)
echo "delete iplbaas"
ipaddress=$1
sed -i -e "/$ipaddress/d" ${HOME}/iplbaas.info
echo "DELETE:" $ipaddress at $(date) >> ${HOME}log_iplbaas.log
echo "FINISHED at:" $(date)
