#!/bin/bash

for ((i=0;i<=50;i++))
do
	./run_client.sh 16 &>> $1
done
