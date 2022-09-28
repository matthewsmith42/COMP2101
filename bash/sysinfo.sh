#!/bin/bash

# source environment variables
source /etc/os-release

# gather my data for my report
fqdn=$(hostname --fqdn)
osName=$NAME
osVersion=$VERSION
ipAddress=$(hostname -I)
freeSpace=$(df -h /dev/sda3)

# print a blank line before script output
echo

# title for report
echo 'Report for: '$(hostname)
echo '========================'

# display system fully qualified domain name
echo "FQDN: $fqdn"

# display os name and version
echo "Operating System name and version: $osName $osVersion"

# display IP address
echo "IP Address: $ipAddress"

# display root filesystem free space
echo "Root Filesystem Free Space: $freeSpace"

# end script with separator and blank line
echo '========================'
echo
