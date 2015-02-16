#!/bin/bash

#---------------------------------------------------------------
# prepare.sh
#
# installs common tools => docker, aws cli, curl, jq
#
#---------------------------------------------------------------

set -eu

sudo apt-get update -y
sudo apt-get install -y docker.io awscli curl jq

