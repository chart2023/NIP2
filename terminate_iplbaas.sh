#!/bin/bash
echo "TERMINATED iplbaas at" $(hostname)
echo "START at:" $(date)
source /home/ubuntu/openstack.conf
ipfile="./ipaddress.txt"
ipaddress=$(head -1 $ipfile)
curl -s -X POST $OS_AUTH_URL/tokens \
-H "Content-Type: application/json" \
-d '{"auth": {"tenantName": "admin", "passwordCredentials": {"username": "'"$OS_USERNAME"'", "password": "'"$OS_PASSWORD"'"}}}' | python -m  json.tool > token.txt
TOKEN=$(cat token.txt |  jq '.access.token.id' | tr -d '"')
echo $TOKEN
curl -s -X GET http://$ipopenstack:9696/v2.0/lbaas/loadbalancers?name=loadbalancer1 \
 -H "X-Auth-Token: $TOKEN" \
 | python -m json.tool > lbaas.txt
vip=$(cat lbaas.txt | jq '.loadbalancers[].vip_address' | tr -d '"')
pools=$(cat lbaas.txt | jq '.loadbalancers[].pools[].id' | tr -d '"')
echo $vip
echo $pools
curl -s -X GET http://$ipopenstack:9696/v2.0/subnets?name=private_subnet \
 -H "X-Auth-Token: $TOKEN" \
 | python -m json.tool > subnet.info
subnet=$(cat subnet.info | jq '.subnets[].id' | tr -d '"')
echo $subnet
curl -s -X GET http://$ipopenstack:9696/v2.0/lbaas/pools/$pools/members?address="$ipaddress" \
 -H "X-Auth-Token: $TOKEN" | python -m json.tool > lbaasmember.info
MEMBER_ID=$(cat lbaasmember.info | jq '.members[].id' | tr -d '"')
curl -s -X DELETE http://$ipopenstack:9696/v2.0/lbaas/pools/$pools/members/$MEMBER_ID \
 -H "X-Auth-Token: $TOKEN" \
 curl -s -X GET http://$ipopenstack:9696/v2.0/lbaas/pools/$pools/members \
 -H "X-Auth-Token: $TOKEN" | python -m json.tool
echo "FINISH at:" $(date)
echo "##########FINISHED############"
