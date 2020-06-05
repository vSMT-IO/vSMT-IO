#!/bin/bash

# a monitor/mwait loop is 500us

echo 10 | sudo tee /sys/module/core/parameters/vsmtio_mwait_loops
cat /sys/module/core/parameters/vsmtio_mwait_loops
