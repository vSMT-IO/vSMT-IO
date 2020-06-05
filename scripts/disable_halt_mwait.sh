#!/bin/bash

cat /sys/module/core/parameters/enable_halt_xmwait

echo 0 | sudo tee /sys/module/core/parameters/enable_halt_xmwait

cat /sys/module/core/parameters/enable_halt_xmwait
