#!/bin/bash

cat /sys/module/core/parameters/enable_pause_xmwait
cat /sys/module/core/parameters/spinlock_sleep_time_ns

echo 0 | sudo tee /sys/module/core/parameters/enable_pause_xmwait
echo 0 | sudo tee /sys/module/core/parameters/spinlock_sleep_time_ns

cat /sys/module/core/parameters/enable_pause_xmwait
cat /sys/module/core/parameters/spinlock_sleep_time_ns
