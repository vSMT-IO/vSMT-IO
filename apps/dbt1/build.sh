#!/bin/bash
cd ~
mkdir pgdata
mkdir finaloutput
username=`whoami`
homepath=`pwd`
pgdatapath="$homepath/pgdata"
finaloutputpath="$homepath/finaloutput"
sudo apt-get install sysstat
sudo dpkg-reconfigure dash #choose no!!!!!!!!!
sudo apt-get install autoconf
sudo apt-get install libreadline6 libreadline6-dev
sudo apt-get install zlib1g zlib1g-dev

###################Building PostgresSQL##########################
wget "https://ftp.postgresql.org/pub/source/v7.4.1/postgresql-7.4.1.tar.gz"
tar -zxf postgresql-7.4.1.tar.gz
cd postgresql-7.4.1
./configure
make
sudo make install
export PATH=/usr/local/pgsql/bin:$PATH
cd ..
###################Finish building PostgresSQL##########################

###################Initiating PostgresSQL##########################
/usr/local/pgsql/bin/initdb -D $pgdatapath
sed -i -e 's~#tcpip_socket =.*~tcpip_socket = true~g' $pgdatapath/postgresql.conf
sed -i -e 's~#port = 5432~port = 5432~g' $pgdatapath/postgresql.conf
/usr/local/pgsql/bin/pg_ctl -D $pgdatapath -l logfile start
/usr/local/pgsql/bin/createdb $username$
###################Finish Initiating PostgresSQL##########################

###################Building DBT1##########################
dbt1pgdatapath="$homepath/dbt1pgdata"
#scp hkucs@202.45.128.170:~/dbt1-pgsql.tar.gz ./ #The direct download link is not provided in SourceForge, the password is "RDMA4PAXOS"
wget https://cfhcable.dl.sourceforge.net/project/osdldbt/dbt1/dbt1-v2.0/dbt1-pgsql.tar.gz
tar -zxf dbt1-pgsql.tar.gz
cd dbt1-pgsql
export CFLAGS=-I/usr/local/pgsql/include
export LDFLAGS=-L/usr/local/pgsql/lib
sudo chmod 777 scripts/pgsql/set_run_env.sh.in
sudo chmod 777 dbdriver/eu.c
autoconf
./configure
sed -i -e "s~ts.tv_sec = (time_t) (60 / rampuprate);~//ts.tv_sec = (time_t) (60 / rampuprate);~g" dbdriver/eu.c
sed -i -e "s~ts.tv_nsec =~//ts.tv_nsec =~g" dbdriver/eu.c
sed -i -e 's~(long) ((60000.0 / (double)~//(long) ((60000.0 / (double)~g' dbdriver/eu.c
sed -i -e 's~nanosleep(&ts, NULL);~sleep(60/rampuprate);~g' dbdriver/eu.c
sed -i -e 's~all: $(EXE)~% : SCCS/s.%\n\nall: $(EXE)~g' appServer/Makefile
sed -i -e 's~all: $(EXE)~% : SCCS/s.%\n\nall: $(EXE)~g' cache/Makefile
sed -i -e 's~all: $(COMMON_OBJS)~% : SCCS/s.%\n\nall: $(COMMON_OBJS)~g' common/Makefile
sed -i -e 's~all: datagen~% : SCCS/s.%\n\nall: datagen~g' datagen/Makefile
sed -i -e 's~all: $(EXE)~% : SCCS/s.%\n\nall: $(EXE)~g' dbdriver/Makefile
sed -i -e 's~all: $(OBJS)~% : SCCS/s.%\n\nall: $(OBJS)~g' interfaces/Makefile
sed -i -e 's~all: interaction_test results~% : SCCS/s.%\n\nall: interaction_test results~g' tools/Makefile
sed -i -e 's~all: $(PROGS)~% : SCCS/s.%\n\nall: $(PROGS)~g' wgen/Makefile
make
sudo make install
sed -i -e "s~/opt/DBT1~$pgdatapath~g" scripts/pgsql/set_run_env.sh
sed -i -e "s~PGUSER=pgsql~PGUSER=$username~g" scripts/pgsql/set_run_env.sh
###################Finish building DBT1##########################

export CFLAGS=-I/usr/local/pgsql/include
export LDFLAGS=-L/usr/local/pgsql/lib
export PATH=/usr/local/pgsql/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/pgsql/lib
. scripts/pgsql/set_run_env.sh
###################Building database############################
cd scripts/pgsql
mkdir database
datasetpath="`pwd`/database"
sudo chown $username:$username /tmp
./build_db.sh "-c tcpip_socket=on" 0 0 -g -d PGSQL -i $1 -u $2 -p $datasetpath
cd ../../data_collect/
chmod 777 pgsql/run.config
let gcustomers=$2*2880
sed -i -e "s~items:.*~items:$1~g" pgsql/run.config
sed -i -e "s~gcustomers:.*~gcustomers:$gcustomers~g" pgsql/run.config
sed -i -e "s~eus0:.*~eus0:$2~g" pgsql/run.config
sed -i -e "s~think_time0:.*~think_time0:0.02~g" pgsql/run.config #This is not a mandatory change. I just want higher CPU usages.
sed -i -e "s~username:.*~username:$username~g" pgsql/run.config
sed -i -e "s~password:.*~password:$username~g" pgsql/run.config
sed -i -e "s~out_dir:.*~out_dir:$finaloutputpath~g" pgsql/run.config

