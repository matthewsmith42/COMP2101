#!/bin/bash
# My Bash Beginner Script for Lab 1

# Getting the FQDN from the Machine
echo 'FQDN:' "$(hostname --fqdn)"

# Getting the OS Name, Version, and Linux Distro in Use
echo "Host Information:"
hostnamectl

# Outputting any IP address that are not on the 127 network
echo 'IP Addresses:'
hostname -I

# Outputting the amount of space available in only the root filesystem, displayed as a human-readable friendly number
echo 'Root Filesystem Status:'
df -h /dev/sda3
