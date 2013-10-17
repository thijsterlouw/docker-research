#!/bin/bash

# NOTE: you need to be root to run this script

# This script resets docker + networking layer very useful 
# when you update docker and some of the internals change 
# (eg network address of docker0 interface). 
# Reasons why you might need this are routing issues/conflicts 
# eg internal network using the same ranges as docker0).

# check dotcloud/docker/network.go#128 ( CreateBridgeIface )
# for more details about networking

pkill -9 docker
# be sure to check all are gone
KILL_DOCKER=`ps aux | grep [d]ocker | wc -l`
if [ "${KILL_DOCKER}" -ne "0" ]; then
    echo "docker was not killed"
    exit -1
else
    echo "docker was killed" 
fi
iptables -t nat -F
ifconfig docker0 down
brctl delbr docker0
docker -d -r=true
