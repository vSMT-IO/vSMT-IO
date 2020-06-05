#!/bin/bash

virsh vcpupin kvm2 0 1
virsh vcpupin kvm3 0 1

for((i=1;i<=31;i++))
do
		virsh vcpupin kvm2 $i $i
		virsh vcpupin kvm3 $i $i
done

