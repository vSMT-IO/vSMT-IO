#!/bin/bash

for ((i=0;i<=10;i++))
do
	./run-hdfs.sh &>> $1
done
