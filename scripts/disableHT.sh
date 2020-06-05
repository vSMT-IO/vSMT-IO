# sudo /opt/dell/srvadmin/bin/omconfig chassis biossetup attribute=LogicalProc setting=disabled

# disable processor id 6
#echo 0 | sudo tee /sys/devices/system/node/node0/cpu6/online
#!/bin/bash

#Weiwei Jia <harryxiyou AT gmail DOT com> 2018

socket_num=`lscpu | grep "Core(s) per socket:" | awk '{print $4}'`
cores_per_socket=`lscpu | grep "Socket(s)" | awk '{print $2}'`

core_num=`echo "$socket_num * $cores_per_socket" | bc -l`
((core_num=$core_num-1))
#echo "Core number: $core_num"
#echo "Core#  Processor#"

for ((i=0; i<$core_num; i++))
do
	sibling=`cat /sys/devices/system/cpu/cpu$i/topology/thread_siblings_list | awk -F"," '{print $2}'`
	#echo $sibling
	echo 0 | sudo tee /sys/devices/system/node/node0/cpu$sibling/online
	echo 0 | sudo tee /sys/devices/system/node/node1/cpu$sibling/online
done
