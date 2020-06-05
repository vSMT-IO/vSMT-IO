#!/bin/bash

echo 1024 | sudo tee /sys/fs/cgroup/cpu/machine/kvm2.libvirt-qemu/cpu.shares
echo 1 | sudo tee /sys/fs/cgroup/cpu/machine/kvm1.libvirt-qemu/cpu.shares
echo 1 | sudo tee /sys/fs/cgroup/cpu/machine/kvm3.libvirt-qemu/cpu.shares
