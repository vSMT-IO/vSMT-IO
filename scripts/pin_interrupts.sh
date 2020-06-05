#!/bin/bash

items=`ls /proc/irq/`

#debug
#echo "$items"

for i in $items
do
	#debug
	#echo $i
	if [ $i != "default_smp_affinity" ]; then
		echo 1 | sudo tee /proc/irq/$i/smp_affinity
	fi
done


echo 1 | sudo tee /proc/irq/default_smp_affinity

sudo cat /proc/irq/*/smp_affinity
sudo cat /proc/irq/default_smp_affinity
