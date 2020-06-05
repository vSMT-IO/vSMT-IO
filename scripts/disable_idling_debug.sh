#!/bin/bash


echo 0 | sudo tee /sys/module/core/parameters/enable_idling_debug

cat /sys/module/core/parameters/enable_idling_debug
