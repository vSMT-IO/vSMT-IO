#!/bin/bash

for ((i=0;i<=10;i++))
do
	./run-client.sh &>> $1
done
