#!/bin/bash

#---------------------------------------------------------------
# start-kafka.sh
#
# Starts a containerized kafka instance.
#
# zookeeper ip is found as follows:
#
# 1. find the value of tag, test-id, for this instance
# 2. find the private ip address of an instance with tags:
#    test-id: my-test-id, node: zookeeper
#
#---------------------------------------------------------------

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


# retrieve our docker image
echo "docker pull savaki/kafka:latest"
sudo docker pull savaki/kafka:latest >& /dev/null

#------------------------------------------------------------------------------------------

# define base docker options
#
DOCKER_OPTS="-d"
DOCKER_OPTS="${DOCKER_OPTS} -P"
DOCKER_OPTS="${DOCKER_OPTS} -v /var/run/docker.sock:/var/run/docker.sock"
DOCKER_OPTS="${DOCKER_OPTS} -p 9092:9092 -P -net host"

#------------------------------------------------------------------------------------------

# add kafka configuration parameters
#
DOCKER_OPTS="${DOCKER_OPTS} -e KAFKA_ZOOKEEPER_CONNECT=${ZOOKEEPER_IP}:2181"
DOCKER_OPTS="${DOCKER_OPTS} -e KAFKA_LOG_RETENTION_HOURS=168"
DOCKER_OPTS="${DOCKER_OPTS} -e KAFKA_LOG_SEGMENT_BYTES=536870912"
DOCKER_OPTS="${DOCKER_OPTS} -e KAFKA_LOG_CLEANUP_INTERVAL_MINS=1"

#------------------------------------------------------------------------------------------

DOCKER_OPTS="${DOCKER_OPTS} -e KAFKA_ADVERTISED_HOST_NAME=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)"

# if disk1 exists, then put csv metrics there
#
if [ -d /disk1 ] ; then
  DOCKER_OPTS="${DOCKER_OPTS} -e KAFKA_METRICS_POLLING_INTERVAL_SECS=5"
  DOCKER_OPTS="${DOCKER_OPTS} -e KAFKA_METRICS_REPORTERS=kafka.metrics.KafkaCSVMetricsReporter"
  DOCKER_OPTS="${DOCKER_OPTS} -e KAFKA_CSV_METRICS_DIR=/disk1/kafka_metrics"
  DOCKER_OPTS="${DOCKER_OPTS} -e KAFKA_CSV_METRICS_REPORTER_ENABLED=false"
  DOCKER_OPTS="${DOCKER_OPTS} -v /disk1/zookeeper:/tmp/zookeeper"

  sudo mkdir -p /disk1/kafka_metrics
fi

# dynamically configure KAFKA_LOG_DIRS and KAFKA_NUM_PARTITIONS
#
export KAFKA_LOG_DIRS=""
for i in $(seq 2 100); do
  dir="/disk${i}"
  if [ -d ${dir} ] ; then
    export KAFKA_LOG_DIRS="${KAFKA_LOG_DIRS},${dir}"
    export KAFKA_NUM_PARTITIONS=$(echo "${i} - 1" | bc)
    export DOCKER_OPTS="${DOCKER_OPTS} -v ${dir}:${dir}"

    if [ -d "${dir}/lost+found" ] ; then
      sudo rm -rf "${dir}/lost+found"
    fi
  fi
done

# strip the leading , if any
export KAFKA_LOG_DIRS=$(echo ${KAFKA_LOG_DIRS} | sed s/^,//)

DOCKER_OPTS="${DOCKER_OPTS} -e KAFKA_LOG_DIRS=${KAFKA_LOG_DIRS}"
DOCKER_OPTS="${DOCKER_OPTS} -e KAFKA_NUM_PARTITIONS=${KAFKA_NUM_PARTITIONS}"

sudo docker run ${DOCKER_OPTS} savaki/kafka:latest

exit 0