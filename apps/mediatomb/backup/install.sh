#!/bin/bash

sudo apt-get install mencoder libsqlite3-dev
sudo apt-get install libsqlite3-dev
sudo apt-get install libexpat1-dev

V=0.12.1

CUR_PATH=`pwd`
MSMR_ROOT="build"

if [ -d $MSMR_ROOT ]; then
	sudo rm -rf $MSMR_ROOT
fi

mkdir -p $MSMR_ROOT

cd $MSMR_ROOT

#if [ ! -d "apps" ];then
#	mkdir apps
#fi

#cd apps

#if [ ! -d "mediatomb" ];then
#	mkdir mediatomb
#fi

#cd mediatomb


rm -rf mediatomb-$V install .mediatomb
mkdir install

if [ ! -f mediatomb-$V.tar.gz ];
then
	wget http://downloads.sourceforge.net/mediatomb/mediatomb-$V.tar.gz
fi
tar zxvf mediatomb-$V.tar.gz
cd mediatomb-$V
patch -p1 < ../../disable-multicast.patch
./configure --prefix=$CUR_PATH/$MSMR_ROOT/install/


sed -e 's/search/this->search/g' src/hash/dso_hash.h > bak.h
mv bak.h src/hash/dso_hash.h

sed -e 's/search/this->search/g' src/hash/dbo_hash.h > bak.h
mv bak.h src/hash/dbo_hash.h

sed -e 's/search/this->search/g' src/hash/dbr_hash.h > bak.h
mv bak.h src/hash/dbr_hash.h

sed -e 's/#include "nil.h"/#include <cstddef>\n#include "nil.h"/g' src/zmm/zmm.h > bak.h
mv bak.h src/zmm/zmm.h

make -j `nproc`
make install

# generate database. you can also manually rerun this script for re generating database.
cd $CUR_PATH
source ./generate-database
