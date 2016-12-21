#!/bin/bash
echo "STEP: START NIP"
sleep 30
sudo nohup sudo node /OpenMTC-Chula/openmtc-NIP/ProxyGateway/NIP_IEEE1888_ETSI.js >/home/ubuntu/ieee.log 2>/home/ubuntu/ieee.err &
sleep 10
sudo nohup sudo node /OpenMTC-Chula/openmtc-NIP/ProxyGateway/NIP_ETSI_IEEE1888_nscl.js >/home/ubuntu/etsi.log 2>/home/ubuntu/etsi.err &
