#!/bin/bash

# variables
APP_VER=1.3.5
MSMR_ROOT="build"
APP_DIR=$PWD/$MSMR_ROOT/proftpd

# start server
echo ""
echo "Running benchmark of proftpd requires root privilege, please enter your password if prompted"
echo ""
sleep 5
cd $APP_DIR/install
sudo sbin/proftpd -c $APP_DIR/install/etc/proftpd.conf -d 10
sleep 2

# benchmark
cd ../benchmark
bin/dkftpbench -hlocalhost -P2121 -n20 -c20 -t10 -k1 -uftpuser -pftpuser -v1 -fx10k.dat

# terminate server
cd ../install
sudo kill -SIGINT $(cat ./var/proftpd.pid)

