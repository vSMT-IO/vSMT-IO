#!/bin/bash

echo 0 | sudo tee /sys/module/kvm/parameters/print_avg_poll_time_bool
