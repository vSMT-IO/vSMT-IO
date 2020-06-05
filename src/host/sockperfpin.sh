#!/bin/bash

for((i=0;i<16;i++))
do
	virsh vcpupin kvm2 $i $i
done

virsh vcpupin kvm2 10 5
virsh vcpupin kvm2 1 5
virsh vcpupin kvm2 0 5
