#!/bin/bash

# This sources the directory with environment variables to use
source /etc/os-release

# gather my data for my report
# This collects the hostname and fqdn of the computer
simpleHostname=$(hostname)
fqdn=$(hostname --fqdn)

# This uses the $NAME and $VERSION variable from os-release
osName=$NAME
osVersion=$VERSION

# This is the ip address of the host
ipAddress=$(hostname -I)

# This will show only available space on root filesystem.
# grep -w "/" will grab the line with the root filesystem
# awk print $4 will grab the 4th column; available space
freeSpace=$(df -h | grep -w "/" | awk '{print $4}')

# print out the report using the gathered data
cat <<EOF

Report for: $simpleHostname
=======================
FQDN: $fqdn
Operating System name and version: $osName $osVersion
IP Address: $ipAddress
Root Filesystem Free Space: $freeSpace
=======================

EOF
