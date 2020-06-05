#!/bin/bash

sudo service mdm stop

sudo rmmod kvm_intel
sudo modprobe kvm_intel ple_gap=0 ple_window=0
cat /sys/module/kvm_intel/parameters/ple*

