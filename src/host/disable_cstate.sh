#!/bin/bash

echo 0 | sudo tee /sys/module/kvm/parameters/vsmtio_enable_cstate_in_guest

cat /sys/module/kvm/parameters/vsmtio_enable_cstate_in_guest
