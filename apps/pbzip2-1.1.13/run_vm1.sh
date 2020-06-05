#!/bin/bash

for ((i=0;i<24;i++))
do
	./pbzip2 -1 -p1 -m1 -b1 -rkvf linux-4.16.3.tar.xz & 
	#rm ./testA.bz2
	#./flush
done
