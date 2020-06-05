#!/bin/bash

#virsh shutdown kvm1
#sleep 5
#virsh shutdown kvm02
#sleep 5
sudo rmmod kvm_intel
sudo modprobe kvm_intel ple_gap=0 ple_window=0
cat /sys/module/kvm_intel/parameters/ple*
#virsh start kvm1
#sleep 5
#virsh start kvm02
