#!/bin/bash
echo "START at:" $(date)
REPLSET=$(cat /dev/urandom | tr -dc 'A-Z' | fold -w 3 | head -n 1)
echo $REPLSET >> /root/db_info.conf
echo "STOP at:" $(date)
echo "##########FINISHED############"
