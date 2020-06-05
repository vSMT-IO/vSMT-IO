#!/bin/bash


./perf kvm record -e cs -a sleep 1

./perf kvm report perf.data.guest
