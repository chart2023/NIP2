#!/bin/bash
wget
ssh -o StrictHostKeyChecking=no -l $user $host
sleep 30
sudo nohup sudo node ${HOME}/OpenMTC-Chula/openmtc-NIP/ProxyGateway/NIP_IEEE1888_ETSI.js >${HOME}/ieee.log 2>${HOME}/ieee.err &
sleep 10
sudo nohup sudo node ${HOME}/OpenMTC-Chula/openmtc-NIP/ProxyGateway/NIP_ETSI_IEEE1888_nscl.js >${HOME}/etsi.log 2>${HOME}/etsi.err &
