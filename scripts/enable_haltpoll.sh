#!/bin/bash


#echo 500000 | sudo tee /sys/module/kvm/parameters/halt_poll_ns
echo 500000 | sudo tee /sys/module/kvm/parameters/halt_poll_ns

cat /sys/module/kvm/parameters/halt_poll_ns
