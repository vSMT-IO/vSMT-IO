#!/bin/bash

echo 0 | sudo tee /sys/module/qspinlock/parameters/vsmtio_enable_optimize_locking

