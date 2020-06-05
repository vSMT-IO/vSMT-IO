#!/bin/bash

echo 0 | sudo tee /sys/module/core/parameters/vsmtio_enable_rr_nop
cat /sys/module/core/parameters/vsmtio_enable_rr_nop
