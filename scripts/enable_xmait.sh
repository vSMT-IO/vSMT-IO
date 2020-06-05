#!/bin/bash

echo 1 | sudo tee /sys/module/core/parameters/enable_halt_xmwait
echo 100000 | sudo tee /sys/module/core/parameters/spinlock_sleep_time_ns
#echo 50000 | sudo tee /sys/module/core/parameters/spinlock_sleep_time_ns
echo 1 | sudo tee /sys/module/core/parameters/enable_pause_xmwait

cat /sys/module/core/parameters/enable_halt_xmwait
cat /sys/module/core/parameters/spinlock_sleep_time_ns
cat /sys/module/core/parameters/enable_pause_xmwait
