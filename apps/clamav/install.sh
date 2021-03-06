#!/bin/bash

sudo apt-get install libxml2
sudo apt-get install libxml2-dev
sudo apt-get install libssl-dev

VER=0.98.6
CURPATH=`pwd`
# working folder

sudo rm -r build

if [ ! -d build ];then
	mkdir build
fi

MSMR_ROOT="$CURPATH/build"
cd $MSMR_ROOT

cd build

#if [ ! -d "clamav" ];then
#	mkdir clamav
#fi
#
#cd clamav

rm clamav-$VER install database *.conf* -rf

if [ ! -f clamav-$VER.tar.gz ]; then
	wget https://distfiles.macports.org/clamav/clamav-$VER.tar.gz
fi
tar zxvf clamav-$VER.tar.gz
mkdir install
mkdir database

cd clamav-$VER
./configure --prefix=$MSMR_ROOT/install \
	--with-dbdir=$MSMR_ROOT/database
make -j`nproc`
make install

cd $MSMR_ROOT
sed '/Example/d' install/etc/freshclam.conf.sample > freshclam.conf
sed '/Example/d' install/etc/clamd.conf.sample > clamd.conf
#CLAMAVPATH=`echo $MSMR_ROOT`/apps/clamav
DBPATH=$MSMR_ROOT/database
echo "DatabaseDirectory $DBPATH" >> freshclam.conf
echo "LogFile $MSMR_ROOT/server.log" >> clamd.conf
echo "DatabaseDirectory $DBPATH" >> clamd.conf
echo "TCPSocket 7000" >> clamd.conf
echo "TCPAddr 127.0.0.1" >> clamd.conf
echo "LogVerbose yes" >> clamd.conf
echo "Foreground yes" >> clamd.conf
echo "MaxThreads 23" >> clamd.conf

# Prepare database
echo "Initiliazing clamav database..."
./install/bin/freshclam --config-file=./freshclam.conf

#echo "Generating client conf with ports 7000 and 9000..."
#cd $CURPATH
#source ./generate-client-conf lo 7000
#cd $CURPATH
#source ./generate-client-conf eth0 9000

#cd $CURPATH
#source ./start-server 7000
#cd $CURPATH
#source ./run-client 7000
