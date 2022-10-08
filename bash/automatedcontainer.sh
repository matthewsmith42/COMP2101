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
	echo "Creating lxdbr0 interface"
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
lxc list | grep -w "COMP2101-F22 | RUNNING" > /dev/null
if [ $? -ne 0 ]; then
	echo "Launching Ubuntu container named COMP2101-F22"
	lxc launch ubuntu:20.04 COMP2101-F22
	if [ $? -ne 0 ]; then
		echo "Failed to launch Ubuntu 20.04 container"
		exit 1
	fi
fi


# Collecting the IPv4 address from the COMP2101-F22 Container
# containerIP grabs the 4th line down, 6th object from the left
# old command that worked: containerIP=$(lxc list | awk 'FNR == 4 {print $6}')

# Grab the line with the container named COMP2101-F22, print the 6th object (IP address, and store it in a variable)
# On first-time running the script, the container IP has not yet been configured so awk picks the 6th element undesired. Setting a sleep timer for DHCP to give container an IP.
sleep 5
containerIP=$(lxc list | grep -w "COMP2101-F22" | awk '{print $6}')

# containerHostname stores the hostname of the container in a variable
containerHostname=$(lxc list | grep -w "COMP2101-F22" | awk '{print $2}')

# Combine the IP and hostname of the container into one variable
# Spacing the variables to match the spacing format of /etc/hosts (1 space + tab)
containerInfo="$containerIP 	$containerHostname"

# Add or update the /etc/hosts for hostname COMP2101-F22 with the container's current IP address if neccessary

# Checking if the container is already in /etc/hosts
grep "$containerInfo" /etc/hosts > /dev/null

# If container is not in /etc/hosts, add it to the first line using the $containerInfo
if [ $? -ne 0 ]; then
	echo "Adding the container COMP2101-F22 to the first line of /etc/hosts. Elevated permissions may be required."
	sudo chmod 646 /etc/hosts
	sudo sed -i "1i$containerInfo" /etc/hosts
fi

# Test if Apache2 is installed in the COMP2101-F22 container
lxc exec COMP2101-F22 whereis apache2 > /dev/null

# Install Apache2 in the container if necessary ; # lxc exec COMP2101-F22 ; lets us doing anything inside the container
if [ $? -ne 0 ]; then
	# Need to install apache2 in container
	lxc exec COMP2101-F22 apt-get install apache2
	if [ $? -ne 0 ]; then
	#failed to install apache2 - exit with error message and status
	echo "Failed to install apache2"
	exit 1
	fi
fi

# Retrieve the default web page from the container's web service with curl htp://COMP2101-F22 and notify the user of success or failure
