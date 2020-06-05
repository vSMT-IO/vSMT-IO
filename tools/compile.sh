#!/bin/bash

gcc accurate_cpu.c debug.c -o ./accurate_cpu -lpthread -lglib-2.0
gcc flush.c debug.c -o ./flush -lpthread -lglib-2.0
