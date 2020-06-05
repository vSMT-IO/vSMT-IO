#!/bin/bash

#if [ "$1" = "1" ]
#then
	# 1st run on shared vCPU

#stop apache first, should not have conflicts
sudo service apache2 stop
#echo "nginx, this is on vCPU $1 with $2 clients/users"
echo "nginx, with $1 clients/users"
#IP_ADDR_SERVER=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/'`
IP_ADDR_SERVER="127.0.0.1"
IP_ADDR_CLIENT="192.168.122.236"
	#cd /home/kvm1/vMigrater/macro_benchmarks/bench3/sysbench
	#./umount.sh
	#./mount.sh
	
	#cd /home/kvm1/sda3
	#/usr/bin/sysbench --test=fileio --file-total-size=10G prepare
	#sysbench --test=oltp --oltp-table-size=1000000 --mysql-db=test --mysql-user=root --mysql-password=123 prepare
	#./flush
echo "============> siege start to run===============>"
#taskset -c $1 siege --quiet --concurrent=$2 --time=60s --log=./siege.log $IP_ADDR_SERVER
siege  --concurrent=$1 -i -b --time=60s --log=./siege.log $IP_ADDR_SERVER
echo "============> siege end===============>"
