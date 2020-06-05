#!/bin/bash

#for((i=0;i<16;i++))
for((i=0;i<32;i++))
do
	virsh vcpupin kvm2 $i $i
done
