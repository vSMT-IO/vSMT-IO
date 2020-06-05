#!/bin/bash

echo 1 | sudo tee /sys/module/qspinlock/parameters/vsmtio_enable_optimize_locking

