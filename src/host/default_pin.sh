#!/bin/bash

#kvm2
for((i=0;i<=31;i++))
do
		virsh vcpupin kvm2 $i 0-31
		#virsh vcpupin kvm3 $i $i
done

#kvm3
for((i=0;i<=31;i++))
do
		virsh vcpupin kvm3 $i 0-31
		#virsh vcpupin kvm3 $i $i
done

