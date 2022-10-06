#!/bin/bash

# this is my testing script for playing with containers

# use the which command to see if lxd exists on the system already
which lxd > /dev/null
if [ $? -ne 0 ]; then
#need to install lxd
	echo "Installing lxd - you may need to input password"
	sudo snap install lxd
	if [ $? -ne 0 ]; then
	#failed to install lxd - exit with error message and status
	echo "Failed to install lxd"
	exit 1
	fi
fi
#lxd software install complete

# check to see if lxdbr0 inerface exists
# Listing all interfaces and searching for lxdbr0
ifconfig | grep -w "lxdbr0" > /dev/null

# if the test value of grep "lxdbr0" is not 0, need to run lxd init --auto
if [ $? -ne 0 ]; then
	echo "You do not have the required interface. Starting the interactive configuration process"
	lxd init --auto
	if [ $? -ne 0 ]; then
	# failed to start interactive configuration process
	echo "Failed to start interactive configuration process"
	exit 1
	fi
else
	echo "lxdbr0 interface found on machine"
fi

# Launch a container running Ubuntu 20.04 server named COMP2101-F22 if necessary
lxc launch ubuntu: 20.04 COMP2101-F22

# Add or update the /etc/hosts for hostname COMP2101-F22 with the container's current IP address if neccessary

# Install Apache2 in the container if necessary

# Retrieve the default web page from the container's web service with curl htp://COMP2101-F22 and notify the user of success or failure
