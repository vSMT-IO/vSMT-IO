#!/bin/bash

# a loop is 100us

echo 30 | sudo tee /sys/module/core/parameters/vsmtio_nop_loops
cat /sys/module/core/parameters/vsmtio_nop_loops
