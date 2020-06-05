#!/bin/bash

for((;;))
do
	taskset -c 2 sysbench --test=cpu --num-threads=1 --max-time=0 --cpu-max-prime=50000 run
done
