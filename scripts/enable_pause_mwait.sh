#!/bin/bash

cat /sys/module/core/parameters/enable_pause_xmwait

echo 1 | sudo tee /sys/module/core/parameters/enable_pause_xmwait

cat /sys/module/core/parameters/enable_pause_xmwait
