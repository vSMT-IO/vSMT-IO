#!/bin/bash
#
# Weiwei Jia <harryxiyou@gmail.com> (Bash)
#
# Performance analysis for good vcpu pairs on pCPUs.
#


#function usage() {
#	echo -e "./pair.sh [kvm_name]"
#	exit
#}

function find_vms() {
	ret=`ls $cpu_use/*.libvirt-qemu 2> /dev/null`
	if [ "$ret" == "" ]; then
		echo -e "It seems no VMs running, please check."
		exit
	fi
}

#check if there is VMs.
#find_vms

#if [ $# -ne 2 ]; then
#	usage
#	exit
#fi

#echo -e "kvm_name: $1"

virsh vcpuinfo kvm1 >& /tmp/kvm1vcpuinfo
virsh vcpuinfo kvm2 >& /tmp/kvm2vcpuinfo

kvm1_cpu=`cat /tmp/kvm1vcpuinfo | grep "^CPU:" | awk '{print $2}'`
kvm2_cpu=`cat /tmp/kvm2vcpuinfo | grep "^CPU:" | awk '{print $2}'`

good=0

j=16
for ((i=0;i<=15;i++))
do
	for entry1 in $kvm1_cpu
	do
		if [ "$i" == $entry1 ]; then
			for entry2 in $kvm2_cpu
			do
				if [ "$j" == $entry2 ]; then
					((good=$good+1))
				fi
			done
		fi
	done

	((j=$j+1))
done

j=0
for ((i=16;i<=31;i++))
do
	for entry1 in $kvm1_cpu
	do
		if [ "$i" == $entry1 ]; then
			for entry2 in $kvm2_cpu
			do
				if [ "$j" == $entry2 ]; then
					((good=$good+1))
				fi
			done
		fi
	done

	((j=$j+1))
done

echo -e "good pair is $good"

rate=`echo "scale=4; $good/16*100" | bc -l`

echo -e "good pair rate is: $rate"
