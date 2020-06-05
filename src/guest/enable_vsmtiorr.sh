#!/bin/bash

echo 0 | sudo tee /sys/module/core/parameters/vsmtio_enable_rr_nop
echo 0 | sudo tee /sys/module/core/parameters/vsmtio_nop_loops
echo 1 | sudo tee /sys/module/core/parameters/vsmtio_mwait_loops
echo 1 | sudo tee /sys/module/core/parameters/vsmtio_enable_rr
