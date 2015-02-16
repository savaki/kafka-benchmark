#!/bin/bash

#---------------------------------------------------------------
# start-zookeeper.sh
#
# Starts a containerized zookeeper instance.
#
#---------------------------------------------------------------

set -eu

# Start docker container
echo "sudo docker pull savaki/zookeeper:latest"
sudo docker pull savaki/zookeeper:latest >& /dev/null

sudo docker run -d -p 2181:2181 -P savaki/zookeeper:latest
