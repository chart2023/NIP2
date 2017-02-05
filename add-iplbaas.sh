#!/bin/bash
echo "START at:" $(date)
echo "add iplbaas"
ipaddress=$1
source /home/ubuntu/openstack.conf
curl -s -X POST $OS_AUTH_URL/tokens \
 -H "Content-Type: application/json" \
 -d '{"auth": {"tenantName": "admin", "passwordCredentials": {"username": "'"$OS_USERNAME"'", "password": "'"$OS_PASSWORD"'"}}}' \
 | python -m  json.tool > token.info
TOKEN=$(cat token.info |  jq '.access.token.id' | tr -d '"')
echo "TOKEN:"$TOKEN
curl -s -X GET http://192.168.9.12:9696/v2.0/subnets?name=private_subnet \
 -H "X-Auth-Token: $TOKEN" \
 | python -m json.tool > subnet.info
subnet=$(cat subnet.info | jq '.subnets[].id' | tr -d '"')
echo $subnet
curl -s -X GET http://192.168.9.12:9696/v2.0/lbaas/loadbalancers?name=loadbalancer1 \
 -H "X-Auth-Token: $TOKEN" \
 | python -m json.tool > lbaas.txt
vip=$(cat lbaas.txt | jq '.loadbalancers[].vip_address' | tr -d '"')
pools=$(cat lbaas.txt | jq '.loadbalancers[].pools[].id' | tr -d '"')
echo $vip
echo $pools
curl -s -X POST http://192.168.9.12:9696/v2.0/lbaas/pools/$pools/members \
 -H "X-Auth-Token: $TOKEN" \
 -d '{"member": {"address": "'"$ipaddress"'", "name": "'"$ipaddress"'","subnet_id": "'"$subnet"'", "protocol_port": "15000"}}'
 curl -s -X GET http://192.168.9.12:9696/v2.0/lbaas/pools/$pools/members \
 -H "X-Auth-Token: $TOKEN" | python -m json.tool
echo "FINISHED at:" $(date)
