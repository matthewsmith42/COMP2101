#!/bin/bash

simpleHostname=$(hostname)

 cat <<EOF

Installation on: $simpleHostname
===============================================================

:::This is a script that automates the installation of a container named COMP2101-F22 with an Apache Web Server:::

:::Press Crtl+C to stop at anytime:::

Good Luck...

===============================================================

EOF

echo "This script will automate the installation process of a container named COMP2101-F22 with an Apache Web Server"
echo

# Use the which command to see if lxd exists on the system
which lxd > /dev/null
if [ $? -ne 0 ]; then
# Need to install lxd
	echo "Installing lxd... (Password may be required)"
	sudo snap install lxd
	if [ $? -ne 0 ]; then
	# Failed to install lxd - exit with error message and status
	echo "Failed to install lxd. Ending program."
	exit 1
	fi
fi
# lxd software install complete

# Use the ifconfig command to determine if the lxdbr0 interface exists
ifconfig | grep -w "lxdbr0" > /dev/null
if [ $? -ne 0 ]; then
# Need to create lxdbr0 interface
	echo "Creating the lxdbr0 interface..."
	echo
	lxd init --auto 
	if [ $? -ne 0 ]; then
	# Failed to create the lxdbr0 interface
		echo "Failed to start interactive configuration process. Ending program."
		exit 1
	fi
# If interface is already installed	
else
	echo "lxdbr0 interface located..."
	echo
fi

# List containers to determine if COMP2101-F22 exists and is running
lxc list | grep -w "COMP2101-F22 | RUNNING" > /dev/null
if [ $? -ne 0 ]; then
# Need to create container COMP2101-F22
lxc launch ubuntu:20.04 COMP2101-F22
	if [ $? -ne 0 ]; then
	# Failed container creation
		echo "Failed to create the COMP2101-F22 container. Ending program."
		exit 1
	fi
fi

# Sleep the script for 5 seconds to allow the container to be assigned an IP address
echo "Collecting container information..."
echo
sleep 5

# Store the container IP address and container hostname as variables
containerIP=$(lxc list | grep -w "COMP2101-F22" | awk '{print $6}')
containerHostname=$(lxc list | grep -w "COMP2101-F22" | awk '{print $2}')

# Combine the variables into a single variable to write to /etc/hosts (1 space + tab)
containerInfo="$containerIP 	$containerHostname"

# Determine if the container with the current IP exists in /etc/hosts
grep "$containerInfo" /etc/hosts > /dev/null
if [ $? -ne 0 ]; then
# Need to create/update the entry in /etc/hosts for COMP2101-F22 container
	echo "Creating/Updating the entry in /etc/hosts for COMP2101-F22 container"
	echo
	echo "Elevated permissions may be required"
	sudo sed -i "1i$containerInfo" /etc/hosts
	if [ $? -ne 0 ]; then
	# Adding the entry to /etc/hosts failed
		echo "The program could not add the container entry to /etc/hosts. Ending program."
		exit  1
	fi
else
	echo "Container entry exists in /etc/hosts"
	echo
fi

# Test if Apache2 is installed in the COMP2101-F22 container
lxc exec COMP2101-F22 which apache2 > /dev/null
if [ $? -ne 0 ]; then
# Need to install Apache2 in the COMP2101-F22 container
	echo "Installing Apache2..."
	lxc exec COMP2101-F22 -- apt-get -y install apache2 &> /dev/null
	if [ $? -ne 0 ]; then
	# Failed to install apache2 - exit with error message and status
	echo "Failed to install apache2"
	exit 1
	fi
else
	echo "Apache2 already installed"
fi

# Use the which command to see if curl exists on the system
which curl > /dev/null
if [ $? -ne 0 ]; then
# Need to install curl
	echo "Installing curl..."
	sudo snap install curl > /dev/null
	if [ $? -ne 0 ]; then
	# Failed to install curl - exit with error message and status
	echo "Failed to install curl. Ending program."
	exit 1
	fi
fi

# Retrieve the default web page from the COMP2101-F22 container Apache server
echo "Attempting to retrieve the default web page from the COMP2101-F22 Apache2 Server"
curl http://COMP2101-F22 &> /dev/null

if [ $? -ne 0 ]; then
# Tell the user that the default web page could not be retrieved
	echo "There was a problem retrieving the default web page from the COMP2101-F22 container's web service."
	echo
	echo "Script Status: FAILURE"
	exit 1
else
# Tell the user that the default web page was successfully retrieved
	echo  "The default web page was successfully retrieved from the COMP2101-F22 container web service"
	echo
	echo "Script Status: SUCCESS"
fi
