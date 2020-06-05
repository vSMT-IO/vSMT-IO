#!/bin/bash

function usage() {
    echo -e "./pin.sh domain_name"
}

if [[ $# -ne 1 ]]; then
	usage
	exit
fi

domain=$1

#vcpu_num=`virsh vcpucount $domain | awk 'NR=='1' {print $3}'`
vcpu_num=23

for ((i=0; i<$vcpu_num; i++))
do
	virsh vcpupin $domain $i $i
done

vcpu_num=23
j=24

for ((i=0; i<$vcpu_num; i++))
do
	virsh vcpupin $domain $j $i
	((j=$j+1))
done

virsh vcpupin $domain
