#!/bin/bash

cat /sys/module/core/parameters/enable_rr
cat /sys/module/core/parameters/rr_dedicated_vcpu_id
cat /sys/module/core/parameters/rr_retention_time

echo 0 | sudo tee /sys/module/core/parameters/enable_rr
echo 15 | sudo tee /sys/module/core/parameters/rr_dedicated_vcpu_id
echo 3000000 | sudo tee /sys/module/core/parameters/rr_retention_time

cat /sys/module/core/parameters/enable_rr
cat /sys/module/core/parameters/rr_dedicated_vcpu_id
cat /sys/module/core/parameters/rr_retention_time
