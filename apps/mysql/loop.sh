#!/bin/bash

for ((i=0;i<=20;i++))
do
	./sysbench2.sh 32 &>> $1
done
