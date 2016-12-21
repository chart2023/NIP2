#!/bin/bash
user='ubuntu'
dbhost='192.168.9.122'
nohup node /OpenMTC-Chula/nscl >/home/ubuntu/nscl.log 2>/home/ubuntu/nscl.err &
sleep 5
expect /opt/openbaton/scripts/init-shard.exp $dbhost
