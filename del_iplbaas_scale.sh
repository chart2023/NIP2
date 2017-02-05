#!/bin/bash
source /home/ubuntu/openstack.info
ipaddress=$1
echo "Perform by" $ipaddress >> log_iplbaas.log
iplbaas=$(cat ${HOME}/iplbaas.info)
sleep 1
for ip in $iplbaas
do
        nc -z -v -w 1 $ip 15000
        if [ $? -eq 0 ];
        then
          echo $ip "is reachable at" $(date) >> log_iplbaas.log
        else
          curl -s -X POST $OS_AUTH_URL/tokens \
          -H "Content-Type: application/json" \
           -d '{"auth": {"tenantName": "admin", "passwordCredentials": {"username": "'"$OS_USERNAME"'", "password": "'"$OS_PASSWORD"'"}}}' | python -m  json.tool > token.txt
          TOKEN=$(cat token.txt |  jq '.access.token.id' | tr -d '"')
          echo $TOKEN
          curl -s -X GET http://$ipopenstack:9696/v2.0/lbaas/loadbalancers?name=loadbalancer1 \
          -H "X-Auth-Token: $TOKEN" \
          | python -m json.tool > lbaas.txt
          pools=$(cat lbaas.txt | jq '.loadbalancers[].pools[].id' | tr -d '"')
          curl -s -X GET http://$ipopenstack:9696/v2.0/lbaas/pools/$pools/members?address="$ip" \
          -H "X-Auth-Token: $TOKEN" | python -m json.tool > lbaasmember.info
          MEMBER_ID=$(cat lbaasmember.info | jq '.members[].id' | tr -d '"')
          curl -s -X DELETE http://$ipopenstack:9696/v2.0/lbaas/pools/$pools/members/$MEMBER_ID \
           -H "X-Auth-Token: $TOKEN" \
          echo $ip "is unreachable at" $(date) >> log_iplbaas.log
          sed -i -e "/$ip/d" ${HOME}/iplbaas.info
          sleep 5
        fi
done
curl -s -X GET http://192.168.9.12:9696/v2.0/lbaas/pools/$pools/members \
 -H "X-Auth-Token: $TOKEN" | python -m json.tool 
