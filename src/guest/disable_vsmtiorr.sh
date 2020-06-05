#!/bin/bash

echo 0 | sudo tee /sys/module/core/parameters/vsmtio_enable_rr
cat /sys/module/core/parameters/vsmtio_enable_rr
