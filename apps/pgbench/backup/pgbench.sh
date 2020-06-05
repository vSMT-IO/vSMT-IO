#!/bin/bash

#sudo apt-get install postgresql-client
#sudo apt-get install postgresql
#sudo su postgres
#psql
#\password postgres
#CREATE USER dbuser WITH PASSWORD 'password';
#CREATE DATABASE pgbench OWNER dbuser;
#GRANT ALL PRIVILEGES ON DATABASE pgbench to dbuser;
APP_DIR=$MSMR_ROOT/apps/pgbench

echo 'Please be sure for having installed postgresql and created pgbench database, true of false？'
read hasFinish
if [ $hasFinish = 'false' ]; then
	echo 'Exiting'
	return
fi

# working folder
cd $MSMR_ROOT

if [ ! -d "apps" ];then
	mkdir apps
fi

cd apps

if [ ! -d "pgbench" ];then
	mkdir pgbench
fi

cd pgbench

# remove folders
if [ -d "postgresql-9.3.23" ];then
	rm -rf postgresql-9.3.23
fi

# download and extract
if [ ! -f postgresql-9.3.23.tar.bz2 ]; then
    wget https://ftp.postgresql.org/pub/source/v9.3.23/postgresql-9.3.23.tar.bz2
fi
tar xjvf postgresql-9.3.23.tar.bz2

# build
cd postgresql-9.3.23
./configure --without-zlib --without-readline
make

cd contrib
make

cd pgbench
sudo cp pgbench /usr/lib/postgresql/9.3/bin/
echo 'cp pgbench /usr/lib/postgresql/9.3/bin/'

sudo su postgres<<'PGBENCH'
echo 'sudo su postgres'

pgbench -i pgbench
echo 'pgbench -i pgbench'
pgbench -c 96  -j 12 -T 20 -r pgbench
PGBENCH
