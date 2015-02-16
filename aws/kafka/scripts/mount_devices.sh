#!/bin/bash

#---------------------------------------------------------------
# mount_devices.sh
#
# enumerates through each of the mapped ebs block devices and
# mounts them to /diskN.  ebs1 => /disk1, ebs2 => /disk2
#
#---------------------------------------------------------------

for i in $(seq 1 100); do
  device_name=$(curl -s http://169.254.169.254/latest/meta-data/block-device-mapping/ebs${i})
  if ! echo ${device_name} | grep -q '^sd'; then
    break
  fi
  device="/dev/$(echo ${device_name} | sed s/sd/xvd/)"
  mount_point="/disk${i}"

  echo "mounting ${device}"
  sudo mkfs -t ext4 ${device}
  sudo mkdir -p ${mount_point}
  sudo mount ${device} ${mount_point}
done
