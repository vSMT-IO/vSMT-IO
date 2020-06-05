#!/bin/bash

echo 1 | sudo tee /sys/module/kvm/parameters/print_avg_poll_time_bool
