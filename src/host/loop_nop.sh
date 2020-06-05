#!/bin/bash

for ((i=0;i<400000;i++))
do
	taskset -c 2 ./nop
done
