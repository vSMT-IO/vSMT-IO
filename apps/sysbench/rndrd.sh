#!/bin/bash

#/usr/bin/sysbench --test=fileio --file-total-size=10G prepare
#/usr/bin/taskset -c 1 /usr/bin/sysbench --test=fileio --max-time=30 --max-requests=0 --num-threads=$1 --file-test-mode=rndrd --file-total-size=8GB run
for ((i=0;i<3;i++))
do
	./flush
	/usr/bin/sysbench --test=fileio --max-requests=0 --max-time=600 --num-threads=32 --file-test-mode=rndrd --file-total-size=8GB run &>> $1
done
#/usr/bin/sysbench --test=fileio --file-total-size=10G cleanup
