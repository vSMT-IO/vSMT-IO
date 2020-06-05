#!/bin/bash

for ((i=0;i<=20;i++))
do
	./wrk.sh &>> $1
done
