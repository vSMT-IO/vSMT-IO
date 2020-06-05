#!/bin/bash

for i in {0..140}
do
		#echo $i
			echo 1 | sudo tee /proc/irq/$i/smp_affinity
done

		echo 1 | sudo tee /proc/irq/default_smp_affinity

		sudo cat /proc/irq/*/smp_affinity
		sudo cat /proc/irq/default_smp_affinity
