#!/bin/bash

#100us is good, 100000 for $1

if [ $1 == "" ]; then
	echo -e "Usage:\n\t\t ./set_spinlock_sleep_time sleep_time(nanoseconds)"
	exit
fi

cat /sys/module/core/parameters/spinlock_sleep_time_ns

echo $1 | sudo tee /sys/module/core/parameters/spinlock_sleep_time_ns

cat /sys/module/core/parameters/spinlock_sleep_time_ns
