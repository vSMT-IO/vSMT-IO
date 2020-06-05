#!/bin/bash

echo 200000 | sudo tee /sys/module/kvm/parameters/halt_poll_ns

cat /sys/module/kvm/parameters/halt_poll_ns
