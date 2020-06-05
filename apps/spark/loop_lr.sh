#!/bin/bash

for ((i=0;i<=20;i++))
do
	./test.sh lr 24 lr1 &
	./test.sh lr 24 lr1 &
	./test.sh lr 24 lr1
	sleep 10
done
