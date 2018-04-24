#!/bin/bash

###############################################################################
# Get information about your computer including:
#
#	- number of volumes, size of each volume, free space on each volume
#	- number cpus/cores, information about the cpus/core
#	- amount of ram, 
#	- your mac address and ip address
###############################################################################
echo "Computer Information ---------------------------------------------------"
echo ""

##############################
# number of volumes
#
#	ls /Volumes
#	Macintosh HD
##############################
echo "- Number of Volumes: "
ret=`ls /Volumes`
echo "$ret"
echo ""

##############################
#	size and free space
#
#	df -h |grep "/dev/disk"
#	Filesystem      Size   Used  Avail Capacity iused               ifree %iused  Mounted on
#	/dev/disk1s1   466Gi  377Gi   85Gi    82% 2057248 9223372036852718559    0%   /
#	/dev/disk1s4   466Gi  3.0Gi   85Gi     4%       3 9223372036854775804    0%   /private/var/vm
##############################
echo "- Size and Free Space: "
echo "Filesystem      Size   Used  Avail "
ret=`df -h |grep "/dev/disk"`
echo "$ret"
echo ""

##############################
# number cpus/cores
#
#	system_profiler SPHardwareDataType | grep "Processors"
#	system_profiler SPHardwareDataType | grep "Cores"
#	
##############################
echo "- Processors"
ret=`system_profiler SPHardwareDataType | grep "Processors"`
echo "$ret"
echo ""

echo "- Cores Per Processor"
ret=`system_profiler SPHardwareDataType | grep "Cores"`
echo "$ret"
echo ""

##############################
# information about the cpus/core
#
#	system_profiler SPHardwareDataType | grep
#	Processor Name: Intel Core i7
#   Processor Speed: 2.6 GHz
##############################
echo "- CPUs and Core Information"
ret1=`system_profiler SPHardwareDataType | grep "Processor Name"`
ret2=`system_profiler SPHardwareDataType | grep "Processor Speed"`
ret3=`sysctl machdep.cpu.brand_string | cut -d : -f 2`
echo "$ret1"
echo "$ret2"
echo "     $ret3"
echo ""

##############################
# your mac address and ip address
##############################
echo "- MAC address and IP address"
ret1=`ifconfig en0 |grep ether |grep -v inet6 | cut -f 2 -d ' '`
ret2=`ifconfig en0 |grep inet |grep -v inet6 | cut -f 2 -d ' '`
echo "MAC: $ret1"
echo "IP:  $ret2"
echo ""



##############################
# amount of ram
#
#	sysctl hw.memsize
#	8589934592
##############################
echo "- Physical Memory"
ret=`sysctl hw.memsize | cut -d : -f 2`
mem=`expr $ret / 1024`
mem=`expr $mem / 1024`
echo "mem: $mem MB"


##############################
##############################


