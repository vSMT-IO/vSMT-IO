#!/bin/bash

#kvm2
for((i=0;i<=31;i++))
do
		virsh vcpupin kvm2 $i 1-15
		virsh vcpupin kvm3 $i 16-31
done

#kvm3
#virsh vcpupin kvm3 0 1
#for((i=1;i<=31;i++))
#do
#		virsh vcpupin kvm3 $i $i
		#virsh vcpupin kvm3 $i $i
#done

