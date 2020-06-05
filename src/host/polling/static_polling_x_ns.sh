#!/bin/bash

#echo 1 | sudo tee /sys/module/kvm/parameters/halt_poll_static_enable_bool
./enable_halt_poll_static_enable_bool.sh

echo $1 | sudo tee /sys/module/kvm/parameters/halt_poll_ns
