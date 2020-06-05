#!/bin/bash

echo $1 | sudo tee /sys/module/kvm/parameters/halt_poll_ns
