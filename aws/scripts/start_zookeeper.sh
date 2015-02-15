#!/bin/bash

set -eu

# Start docker container
sudo service docker start

sudo docker pull savaki/zookeeper:latest

sudo docker run -d -p 2181:2181 -P savaki/zookeeper:latest
