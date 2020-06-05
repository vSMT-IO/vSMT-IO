#!/bin/bash

#xm vcpu-pin  ID VCPU CPU

for ((i=0;i<=15;i++))
do
	sudo xl vcpu-pin xen1 $i  0-15 0-15
done


for ((i=0;i<=15;i++))
do
	sudo xl vcpu-pin xen2 $i  0-15 0-15
done

