#!/bin/bash
echo "START NIP"
echo "START at:" $(date)
source /root/nscl_info.conf
NSCL_IP=$nscl_ip
echo $NSCL_IP
sleep 30
for i in {1..10}
do
        nc -z -v $NSCL_IP 15000
        if [ $? -eq 0 ];
        then
                sudo nohup  node /OpenMTC-Chula/openmtc-NIP/ProxyGateway/NIP_IEEE1888_ETSI.js >/home/ubuntu/ieee.log 2>/home/ubuntu/ieee.err &
                sleep 10
                sudo nohup node /OpenMTC-Chula/openmtc-NIP/ProxyGateway/NIP_ETSI_IEEE1888_nscl.js >/home/ubuntu/etsi.log 2>/home/ubuntu/etsi.err &
                break
        else
        echo "NSCL stopped:$i on start_nscl"
        sleep 15
        fi
done
echo "STOP at:" $(date)
echo "##########FINISHED############"
