#!/bin/bash

virsh start kvm1
virsh start kvm8
$HOME/workshop/vPair/scripts/pin_vcpu_2vm_vpair.sh
$HOME/workshop/vPair/scripts/set_spinlock_sleeptime.sh 100000
virsh vcpupin kvm1
virsh vcpupin kvm8
$HOME/workshop/vPair/scripts/enable_pause_mwait.sh
sudo service mdm stop
