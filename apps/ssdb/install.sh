#!/bin/bash

# benchmark source in ssdb/master/tools/ssdb-bench.cpp

# variables
#APP_DIR=$MSMR_ROOT/apps/ssdb

# working folder
if [ ! -d "build" ];then
	mkdir build
fi

cd build


# remove folders
if [ -d "ssdb-stable-1.9.5" ];then
	rm -rf ssdb-stable-1.9.5
fi

# download and extract
if [ ! -f stable-1.9.5.zip ]; then
    wget wget https://github.com/ideawu/ssdb/archive/stable-1.9.5.zip
fi

unzip stable-1.9.5.zip

# build
cd ssdb-stable-1.9.5

make
