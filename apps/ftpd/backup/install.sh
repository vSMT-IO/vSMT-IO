#!/bin/bash

# important benchmark source files in dkftpbench-0.45: ftp_client_pipe_test.cc ftp_client_pipe.cc Poller_bench.cc

# variables
DIR=$PWD
APP_VER=1.3.5
BEN_VER=0.45
MSMR_ROOT="build"
mkdir $MSMR_ROOT
APP_DIR=$DIR/$MSMR_ROOT/proftpd

# download
cd $APP_DIR
rm -rf proftpd-$APP_VER
rm -rf install
if [ ! -f proftpd-$APP_VER.tar.gz ]; then
    wget ftp://ftp.proftpd.org/distrib/source/proftpd-$APP_VER.tar.gz
fi
tar zxvf proftpd-$APP_VER.tar.gz

# build
mkdir install
cd proftpd-$APP_VER
export install_user=$USER
export install_group=$USER
./configure --prefix=$APP_DIR/install
make
make install

# config virtual user and server
cd contrib/
./ftpasswd --passwd --name=ftpuser --home=$APP_DIR/install/data --shell=/bin/sh --uid=2000 --stdin <<< "ftpuser"
mv ftpd.passwd ../../install/etc
GROUP=$(id -gn)
cd ../../install
mkdir data
echo "Port 2121" >> proftpd.conf
echo "PidFile $APP_DIR/install/var/proftpd.pid" >> proftpd.conf
echo "WtmpLog off" >> proftpd.conf
echo "User $USER" >> proftpd.conf
echo "Group $GROUP" >> proftpd.conf
echo "ScoreboardFile $APP_DIR/install/var/proftpd.scoreboard" >> proftpd.conf
echo "DefaultRoot $APP_DIR/install/data" >> proftpd.conf
echo "RequireValidShell  off" >> proftpd.conf
echo "AuthUserFile  $APP_DIR/install/etc/ftpd.passwd" >> proftpd.conf
echo "SystemLog $APP_DIR/install/etc/proftpd.log" >> proftpd.conf
echo "<Limit LOGIN>" >> proftpd.conf
echo "AllowAll" >> proftpd.conf
echo "</Limit>" >> proftpd.conf
echo "<Directory $APP_DIR/install/data >" >> proftpd.conf
echo "<Limit WRITE READ STOR STOU>" >> proftpd.conf
echo "AllowAll" >> proftpd.conf
echo "</Limit>" >> proftpd.conf
echo "</Directory>" >> proftpd.conf
mv proftpd.conf ./etc

# benchmark
cd ../
rm -rf benchmark
rm -rf dkftpbench-$BEN_VER
if [ ! -f dkftpbench-$BEN_VER.tar.gz ]; then
    wget http://www.kegel.com/dkftpbench/dkftpbench-$BEN_VER.tar.gz
fi
tar zxvf dkftpbench-$BEN_VER.tar.gz
cd dkftpbench-$BEN_VER
patch -p1 < ../dkftpbench.patch
./configure --prefix=$APP_DIR/benchmark
make
make install

# benchmark generated data
make data
mv ./x10k.dat ../install/data/x10k.dat
mv ./x100k.dat ../install/data/x100k.dat
mv ./x1000k.dat ../install/data/x1000k.dat

