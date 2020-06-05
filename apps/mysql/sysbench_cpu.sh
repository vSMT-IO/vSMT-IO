#!/bin/bash


for ((i=0;i<=20;i++))
do
	sysbench --test=cpu --num-threads=16 --max-time=60 --cpu-max-prime=1000000 run &>> cpu_intensive
done
