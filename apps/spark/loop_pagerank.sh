#!/bin/bash

for ((i=0;i<=50;i++))
do
	./test.sh pagerank 16 $1
done
