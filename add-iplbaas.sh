#!/bin/bash
echo "START at:" $(date) "by" $(hostname)
echo "add iplbaas"
ipaddress=$1
echo "ADDED:" $ipaddress at $(date) >> log_iplbaas.log
echo $ipaddress >> ${HOME}/iplbaas.info
echo "FINISHED at:" $(date)
