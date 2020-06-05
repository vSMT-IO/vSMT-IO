#!/bin/bash
#
# Weiwei Jia <harryxiyou@gmail.com> (Bash)
#
# get vcpu/vm's CPU utilization during one period
#

cpu_use="/sys/fs/cgroup/cpuacct/machine"
kvm1_dir="$cpu_use/kvm1.libvirt-qemu"
kvm8_dir="$cpu_use/kvm8.libvirt-qemu"
vm_num=0
#vm10=0
result1=0
result8=0

#function=1: set kvm_name to first set hardware threads, for this server: 0-23
#function=2: set kvm_name to second set hardware threads, for this server: 24-47
function usage() {
	echo -e "Usage:\n\t./vPair [Sleep_time4testing]"
	exit
}

function find_vms() {
	ret=`ls $cpu_use/*.libvirt-qemu 2> /dev/null`
	if [ "$ret" == "" ]; then
		echo -e "It seems no VMs running, please check."
		exit
	fi
}

function set_affinity() {
	#echo -e "kvm_name: $1, vCPU#: $2, function#, $3"
	i=0
	j=24
	if [ $3 -eq 1 ]; then
		#echo "function 1"
		for ((i=0;i<$2;i++))
		do
			task_pid=`cat $cpu_use/$1.libvirt-qemu/vcpu$i/tasks`
			#echo "$task_pid"
			sudo taskset -pc $i $task_pid
		done
	elif [ $3 -eq 2 ]; then
		#echo "function 2"
		for ((i=0;i<$2;i++,j++))
		do
			task_pid=`cat $cpu_use/$1.libvirt-qemu/vcpu$i/tasks`
			#echo "$task_pid"
			sudo taskset -pc $j $task_pid
		done
	elif [ $3 -eq 3 ]; then
		#echo "function 2"
		for ((i=0;i<$2;i++))
		do
			task_pid=`cat $cpu_use/$1.libvirt-qemu/vcpu$i/tasks`
			#echo "$task_pid"
			sudo taskset -pc 0-47 $task_pid
		done
	fi
}

function get_vcpu_time() {
	for ((i=0;i<24;i++))
	do
		vm1[$i]=`cat $kvm1_dir/vcpu$i/cpuacct.usage`
		vm8[$i]=`cat $kvm8_dir/vcpu$i/cpuacct.usage`
	done
}

#check if there is VMs.
find_vms

if [ $# -ne 1 ]; then
	usage
	exit
fi

#get vm number
#ret=`ls $cpu_use 2> /dev/null`

# main.c is vPair's implementation source codes.

#if [ $# -ne 3 ]; then
#	usage
#	exit
#fi

#echo -e "kvm_name: $1, vCPU#: $2, function#, $3"

#set_affinity $1 $2 $3


#get_vcpu_time
for ((i=0;i<23;i++))
do
	vm1[$i]=`cat $kvm1_dir/vcpu$i/cpuacct.usage`
	vm8[$i]=`cat $kvm8_dir/vcpu$i/cpuacct.usage`
done

#echo -e "vCPU#\t\tVM1\t\tVM8"
for((;;))
do
	sleep $1
	for ((i=0;i<23;i++))
	do
		tmp1=`cat $kvm1_dir/vcpu$i/cpuacct.usage`
		tmp8=`cat $kvm8_dir/vcpu$i/cpuacct.usage`
		((result1=$tmp1 - ${vm1[$i]}))
		((result8=$tmp8 - ${vm8[$i]}))
		result11=`echo "scale=3; $result1/($1*1000000000)*100" | bc -l`
		result81=`echo "scale=3; $result8/($1*1000000000)*100" | bc -l`
		#echo -e "vCPU$i\t\t$result11\t\t$result81"
		#echo -e "vCPU$i\t\t${vm1[$i]}\t\t\t${vm8[$i]}"
		echo "$result11"
	done

	for ((i=0;i<23;i++))
	do
		vm1[$i]=`cat $kvm1_dir/vcpu$i/cpuacct.usage`
		vm8[$i]=`cat $kvm8_dir/vcpu$i/cpuacct.usage`
	done
	#get_vcpu_time
done
