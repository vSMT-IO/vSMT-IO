#!/bin/bash

#create build dir
if [ ! -d "./build" ]; then
	mkdir build
fi

gcc with_mwait.c debug.c -o ./build/with_mwait -lpthread -lglib-2.0
gcc without_mwait.c debug.c -o ./build/without_mwait -lpthread -lglib-2.0
gcc perf_lbound.c debug.c -o ./build/perf_lbound -lpthread -lglib-2.0

