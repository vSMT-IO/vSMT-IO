#!/bin/bash

#please enable HT.
#to check which logical processors share one physical core.
#Weiwei Jia <harryxiyou AT gmail DOT com> 2018

socket_num=`lscpu | grep "Core(s) per socket:" | awk '{print $4}'`
cores_per_socket=`lscpu | grep "Socket(s)" | awk '{print $2}'`

core_num=`echo "$socket_num * $cores_per_socket" | bc -l`
#echo "Core number: $core_num"
echo "Core#  Processor#"

for ((i=0; i<$core_num; i++))
do
	siblings=`cat /sys/devices/system/cpu/cpu$i/topology/thread_siblings_list`
	echo -e " $i\t $siblings"
done
