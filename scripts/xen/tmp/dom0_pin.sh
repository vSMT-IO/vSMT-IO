#!/bin/bash

#xm vcpu-pin  ID VCPU CPU
for ((i=0;i<32;i++))
do
	sudo xl vcpu-pin Domain-0 $i $i $i
done
