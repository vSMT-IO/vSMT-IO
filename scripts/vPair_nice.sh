#!/bin/bash
#
# Weiwei Jia <harryxiyou@gmail.com> (Bash)
#
# vPair: a new task scheduler to bridge the gap between
# Simultaneous Multi-Threading and virtualized systems.
#
# vPair system includes three components: two (xHalt and xPause) in the
# kernel of host OS, and one (xPair) in the user space of Host OS.
#
# Algorithm:
# 1, sort all the vCPUs according to their CPU utilization.
# 2, pair low CPU utilization vCPU (sychronization intensive
#    workloads) with high utilization (CPU intensive workloads).
#
# NOTE:
# 1, (co-scheduling issue) better to pair vCPUs from different
#    VMs since resource contention factor.
# 2, (threshold) if find threadshold1 (eg., 3) times, still cannot
#    find a vCPU from another VM, pair the vCPU from the same one.
# 3, (threshold) the boundary to distinguish high/low CPU utilization vCPU.
# 4, (threshold) how long we should pair once.
#
# Dependency libraries/software:
# QEMU/KVM, libvirt, etc.
#

cpu_use="/sys/fs/cgroup/cpuacct/machine"
vm_num=0

#function=1: set kvm_name to first set hardware threads, for this server: 0-23
#function=2: set kvm_name to second set hardware threads, for this server: 24-47
function usage() {
	echo -e "./vPair [kvm_name] [vCPU#] [function#]"
	exit
}

function find_vms() {
	ret=`ls $cpu_use/*.libvirt-qemu 2> /dev/null`
	if [ "$ret" == "" ]; then
		echo -e "It seems no VMs running, please check."
		exit
	fi
}

function set_nice() {
	#echo -e "kvm_name: $1, vCPU#: $2, function#, $3"
	#i=0
	#j=24
	if [ $3 -eq 1 ]; then
		#echo "function 1"
		for ((i=0;i<$2;i++))
		do
			task_pid=`cat $cpu_use/$1.libvirt-qemu/vcpu$i/tasks`
			#echo "$task_pid"
			sudo renice -n -19 -p $task_pid
		done
	elif [ $3 -eq 2 ]; then
		#echo "function 2"
		for ((i=0;i<$2;i++))
		do
			task_pid=`cat $cpu_use/$1.libvirt-qemu/vcpu$i/tasks`
			#echo "$task_pid"
			sudo renice -n 0 -p $task_pid
		done
	elif [ $3 -eq 3 ]; then
		#echo "function 2"
		for ((i=0;i<$2;i++))
		do
			task_pid=`cat $cpu_use/$1.libvirt-qemu/vcpu$i/tasks`
			#echo "$task_pid"
			#sudo renice -n 0 -p $task_pid
			awk '{print $19}' /proc/$task_pid/stat
		done
	fi
}

#check if there is VMs.
find_vms

#get vm number
#ret=`ls $cpu_use 2> /dev/null`

# main.c is vPair's implementation source codes.

if [ $# -ne 3 ]; then
	usage
	exit
fi

echo -e "kvm_name: $1, vCPU#: $2, function#, $3"

set_nice $1 $2 $3
