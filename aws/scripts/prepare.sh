#!/bin/bash

set -eu

sudo yum update -y
sudo yum install -y docker awscli curl jq

