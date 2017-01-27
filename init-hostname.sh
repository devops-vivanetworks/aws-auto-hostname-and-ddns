#!/bin/bash

#  - get the instance's private dns name e.g. ip-172-28-139-137.ap-southeast-1.compute.internal,
#      'explode' it by '.', take the first part, substring from the 4th character: 172-28-139-137
#  - alternative: fetch 'local-ipv4' instead of 'local-hostname', and replace '.' with '-'
INSTANCE_IP=$(/usr/bin/curl -s http://169.254.169.254/latest/meta-data/local-hostname | cut -d . -f 1 | cut -c4-)

OLD_HOSTNAME=$(hostname)
#You can inject HOSTNAME_PREFIX from file, Ansible, etc. or remove it if not needed
NEW_HOSTNAME="${HOSTNAME_PREFIX}-${INSTANCE_IP}"

echo "$NEW_HOSTNAME" > /etc/hostname
hostname -F /etc/hostname
# add the new hostname to /etc/hosts
sed -i /etc/hosts -r -e "1 i 127.0.1.1 ${NEW_HOSTNAME}" -e "/${OLD_HOSTNAME}/d"
