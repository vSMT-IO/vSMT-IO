#!/bin/bash

#create build dir
#if [ ! -d "./build" ]; then
#	mkdir build
#fi

#core part
#gcc main.c debug.c -o ./build/main -lpthread -lglib-2.0
gcc main_dedicated.c debug.c -o ./main_dedicated -lpthread -lglib-2.0
gcc main_shared.c debug.c -o ./main_shared -lpthread -lglib-2.0
gcc pair.c debug.c -o ./pair -lpthread -lglib-2.0


#tools
#gcc ./tools/flush.c debug.c -o ./build/flush -lpthread -lglib-2.0
