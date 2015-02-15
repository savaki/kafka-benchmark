#!/bin/bash

set -eu

# set the default region for aws cli commands
export AWS_DEFAULT_REGION=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/.$//')

# Logic - determining the ip address of our zookeeper instance
#
# 1. retrieve our instance id
# 2. use our instance id to retrieve our test-id
# 3. scan the instances in our region to find an instance with our run-id with node=zookeeper

# 1. retrieve our instance id
INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)

# 2. use our instance id to retrieve our test-id
TEST_ID=$(aws ec2 describe-instances | jq -r ".Reservations[].Instances[] | select(.InstanceId == \"${INSTANCE_ID}\") | .Tags[] | select(.Key == \"test-id\") | .Value")

# 3. scan the instances in our region to find an instance with our run-id with node=zookeeper
ZOOKEEPER_IP=$(aws ec2 describe-instances | jq -r ".Reservations[].Instances[] | \
    select(.State.Name == \"running\") | \
    select(.Tags[] | contains({\"Key\":\"node\",    \"Value\":\"zookeeper\"})) | \
    select(.Tags[] | contains({\"Key\":\"test-id\", \"Value\":\"${TEST_ID}\"})) | \
    .PrivateIpAddress")


# Start docker container
sudo service docker start

# retrieve our docker image
sudo docker pull savaki/kafka:latest

