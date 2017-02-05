#!/bin/bash
echo "START NSCL"
echo "START at:" $(date)
user='ubuntu'
source /root/db_info.conf
dbhost=$db_ip
#dbhost='192.168.9.122'
user1='chart'
ipfile="./ipaddress.txt"
ipaddress=$(head -1 $ipfile)
source /root/nip_info.conf
for i in {1..5}
do
        nc -z -v $dbhost 27017
        if [ $? -eq 0 ];
        then
                echo "Mongos have already started"
                nohup node /OpenMTC-Chula/nscl >/home/ubuntu/nscl.log 2>/home/ubuntu/nscl.err &
                sleep 15
                expect /opt/openbaton/scripts/init-shard.exp $dbhost
                for j in {1..5}
                do
                     nc -z -v $ipaddress 15000
                     if [ $? -eq 0 ];
                        then
                        echo "NSCL has been started"
                        source /home/ubuntu/openstack.conf
                        curl -s -X POST $OS_AUTH_URL/tokens \
                         -H "Content-Type: application/json" \
                         -d '{"auth": {"tenantName": "admin", "passwordCredentials": {"username": "'"$OS_USERNAME"'", "password": "'"$OS_PASSWORD"'"}}}' \
                         | python -m  json.tool > token.info
                        TOKEN=$(cat token.info |  jq '.access.token.id' | tr -d '"')
                        echo "TOKEN:"$TOKEN
                        curl -s -X GET http://$ipopenstack:9696/v2.0/subnets?name=private_subnet \
                         -H "X-Auth-Token: $TOKEN" \
                         | python -m json.tool > subnet.info
                        subnet=$(cat subnet.info | jq '.subnets[].id' | tr -d '"')
                        echo $subnet
                        curl -s -X GET http://$ipopenstack:9696/v2.0/lbaas/loadbalancers?name=loadbalancer1 \
                         -H "X-Auth-Token: $TOKEN" \
                         | python -m json.tool > lbaas.txt
                        vip=$(cat lbaas.txt | jq '.loadbalancers[].vip_address' | tr -d '"')
                        pools=$(cat lbaas.txt | jq '.loadbalancers[].pools[].id' | tr -d '"')
                        echo $vip
                        echo $pools
                        curl -s -X POST http://$ipopenstack:9696/v2.0/lbaas/pools/$pools/members \
                         -H "X-Auth-Token: $TOKEN" \
                         -d '{"member": {"address": "'"$ipaddress"'", "name": "'"$ipaddress"'","subnet_id": "'"$subnet"'", "protocol_port": "15000"}}'
                        curl -s -X GET http://$ipopenstack:9696/v2.0/lbaas/pools/$pools/members \
                        -H "X-Auth-Token: $TOKEN" | python -m json.tool
                        ssh $user1@$host_os "./add-iplbaas.sh $ipopenstack
                        ssh -o StrictHostKeyChecking=no -i /openstack_key.pem -l ubuntu $nip_ip "/opt/openbaton/scripts/add-iplbaas.sh $ipaddress"
                        break
                        else
                        echo "NSCL is not working on NSCL"
                        sleep 5
                        fi
                done
            break
        else
        echo "Mongos stopped:$i on start_nscl"
        sleep 15
        fi
done
echo "FINISH at:" $(date)
echo "##########FINISHED############"
