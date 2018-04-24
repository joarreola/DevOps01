#!/bin/bash

###############################################################################
# Get information about your computer including:
#
#	- number of volumes, size of each volume, free space on each volume
#	- number cpus/cores, information about the cpus/core
#	- amount of ram, 
#	- your mac address and ip address
###############################################################################
usage() {
	echo ""
	echo "Usage: devops01bsh [-volumes][-cpu][-ram][-network][-all]"
	echo ""
}


##############################
# parse parameters.
# expect a minimum of 1 parameter
#
##############################
argCount=$#
while [ "$argCount" -gt "0" ]
do
	var=$1
	
	# parse for [-volumes][-cpu][-ram][-network][-all]
	if [ "${var}" == "-volumes" ]; then
		v=1
	elif [ "${var}" == "-cpu" ]; then
		c=1
	elif [ "${var}" == "-ram" ]; then
		r=1
	elif [ "${var}" == "-network" ]; then
		n=1
	elif [ "${var}" == "-all" ]; then
		a=1
	fi
	
	# housekeeping
	let argCount=argCount-1
	shift 1
done

# check if at least one arg
if [[ -z "${v}" ]] && [[ -z "${c}" ]] && [[ -z "${r}" ]] && [[ -z "${n}" ]] && [[ -z "${a}" ]]; then
	usage
	exit 1
fi

# enable all if a set
if [[ ! -z "${a}" ]]; then
	v=1; c=1; r=1; n=1
fi
#echo "v:$v c:$c r:$r n:$n a:$a"


echo "Computer Information ---------------------------------------------------"
echo ""

##############################
# number of volumes
#
#	ls /Volumes
#	Macintosh HD
##############################
if [[ ! -z "${v}" ]]; then
	echo "- Number of Volumes: "
	ret=`ls /Volumes`
	echo "$ret"
	echo ""
fi

##############################
#	size and free space
#
#	df -h |grep "/dev/disk"
#	Filesystem      Size   Used  Avail Capacity iused               ifree %iused  Mounted on
#	/dev/disk1s1   466Gi  377Gi   85Gi    82% 2057248 9223372036852718559    0%   /
#	/dev/disk1s4   466Gi  3.0Gi   85Gi     4%       3 9223372036854775804    0%   /private/var/vm
##############################
if [[ ! -z "${v}" ]]; then
	echo "- Size and Free Space: "
	echo "Filesystem      Size   Used  Avail "
	ret=`df -h |grep "/dev/disk"`
	echo "$ret"
	echo ""
fi

##############################
# number cpus/cores
#
#	system_profiler SPHardwareDataType | grep "Processors"
#	system_profiler SPHardwareDataType | grep "Cores"
#	
##############################
if [[ ! -z "${c}" ]]; then
	echo "- Processors"
	ret=`system_profiler SPHardwareDataType | grep "Processors"`
	echo "$ret"
	echo ""

	echo "- Cores Per Processor"
	ret=`system_profiler SPHardwareDataType | grep "Cores"`
	echo "$ret"
	echo ""
fi



##############################
# information about the cpus/core
#
#	system_profiler SPHardwareDataType | grep
#	Processor Name: Intel Core i7
#   Processor Speed: 2.6 GHz
##############################
if [[ ! -z "${c}" ]]; then
	echo "- CPUs and Core Information"
	ret1=`system_profiler SPHardwareDataType | grep "Processor Name"`
	ret2=`system_profiler SPHardwareDataType | grep "Processor Speed"`
	ret3=`sysctl machdep.cpu.brand_string | cut -d : -f 2`
	echo "$ret1"
	echo "$ret2"
	echo "     $ret3"
	echo ""
fi

##############################
# your mac address and ip address
##############################
if [[ ! -z "${n}" ]]; then
	echo "- MAC address and IP address"
	ret1=`ifconfig en0 |grep ether |grep -v inet6 | cut -f 2 -d ' '`
	ret2=`ifconfig en0 |grep inet |grep -v inet6 | cut -f 2 -d ' '`
	echo "MAC: $ret1"
	echo "IP:  $ret2"
	echo ""
fi


##############################
# amount of ram
#
#	sysctl hw.memsize
#	8589934592
##############################
if [[ ! -z "${r}" ]]; then
	echo "- Physical Memory"
	ret=`sysctl hw.memsize | cut -d : -f 2`
	mem=`expr $ret / 1024`
	mem=`expr $mem / 1024`
	echo "mem: $mem MB"
fi



