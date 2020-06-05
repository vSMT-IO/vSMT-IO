#!/bin/bash

#https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/6.0_technical_notes/deployment

# Default values are like following

#wj47@mobius04 ~ $ cat /proc/sys/kernel/sched_min_granularity_ns 
#2250000
#wj47@mobius04 ~ $ cat /proc/sys/kernel/sched_wakeup_granularity_ns 
#3000000
#wj47@mobius04 ~ $ cat /proc/sys/kernel/sched_latency_ns 
#18000000

sudo service mdm stop

echo 750000 | sudo tee /proc/sys/kernel/sched_min_granularity_ns
echo 2 | sudo tee /proc/sys/kernel/sched_wakeup_granularity_ns
#echo 24000000 | sudo tee /proc/sys/kernel/sched_latency_ns
echo 80000000 | sudo tee /proc/sys/kernel/sched_latency_ns
#echo cfq | sudo tee /sys/block/sda/queue/scheduler
