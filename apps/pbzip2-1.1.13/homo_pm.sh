#!/bin/bash

#
# Weiwei Jia <wj47@njit.edu>
#
# context switch problem for vHT research project.
#

kvm1="wwjia"
kvm2="wwjia"
ip1="192.168.122.1"
ip2="192.168.122.1"
ctx_ebizzy=$2
ctx_hack=$2
ctx_kern=$2
ctx_dbench=$2
ctx_pbzip2=$2
ctx_sockperf=$2
ctx_oltp=$2

#mount disk
#ssh $kvm1@$ip1 "/home/$kvm1/vMigrater/scripts/mount.sh"
#ssh $kvm2@$ip2 "/home/$kvm2/vMigrater/scripts/mount.sh"

#ebizzy
for i in 1 2 3 4 5
do
	{ time taskset -c 0-22 /home/$kvm1/parsec-3.0/parsec/benchmark/ebizzy-0.3/ebizzy -S 30 -t $1; } &>> $ctx_ebizzy/vm1.ebizzy &
	{ time taskset -c 24-46 /home/$kvm2/parsec-3.0/parsec/benchmark/ebizzy-0.3/ebizzy -S 30 -t $1; } &>> $ctx_ebizzy/vm2.ebizzy
	sleep 30
done

for i in 1 2 3 4 5
do
	{ time taskset -c 0-22 /home/$kvm1/parsec-3.0/parsec/benchmark/hackbench/hackbench 500 process $1; } &>> $ctx_hack/vm1.hack &
	{ time taskset -c 24-46 /home/$kvm2/parsec-3.0/parsec/benchmark/hackbench/hackbench 500 process $1; } &>> $ctx_hack/vm2.hack
	sleep 30
done

cd /home/$kvm1/parsec-3.0/parsec/benchmark/kernbench-0.42;
for i in 1 2 3 4 5
do
	 { time taskset -c 0-22 /home/$kvm1/parsec-3.0/parsec/benchmark/kernbench-0.42/kernbench -H -O -M -o $1 -n 1; }  &>> $ctx_kern/vm1.kern &
	 { time taskset -c 24-46 /home/$kvm2/parsec-3.0/parsec/benchmark/kernbench-0.42/kernbench -H -O -M -o $1 -n 1; }  &>> $ctx_kern/vm2.kern
	sleep 30
done

#mount disk first
#dbench
for i in 1 2 3 4 5
do
	{ time taskset -c 0-22 /usr/bin/dbench -c /usr/share/dbench/client.txt -D /home/$kvm1/ -t 30 $1; } &>> $ctx_dbench/vm1.dbench &
	{ time taskset -c 24-46 /usr/bin/dbench -c /usr/share/dbench/client.txt -D /home/$kvm2/ -t 30 $1; } &>> $ctx_dbench/vm2.dbench
	sleep 30
done

#pbzip2
#compress
cd $HOME;
for i in 1 2 3 4 5
do
	{ time taskset -c 0-22 /home/$kvm1/parsec-3.0/parsec/benchmark/pbzip2-1.1.13/pbzip2 -1 -p$1 -m1 -b1 -rkvf /home/wwjia/testA; } &>> $ctx_pbzip2/vm1.pbzip2 &
	{ time taskset -c 24-46 /home/$kvm2/parsec-3.0/parsec/benchmark/pbzip2-1.1.13/pbzip2 -1 -p$1 -m1 -b1 -rkvf /home/wwjia/testA; } &>> $ctx_pbzip2/vm2.pbzip2
	sleep 30
done

#decompress
for i in 1 2 3 4 5
do
	{ time taskset -c 0-22 /home/$kvm1/parsec-3.0/parsec/benchmark/pbzip2-1.1.13/pbzip2 -1 -p$1 -m1 -b1 -dkvf /home/wwjia/testA.bz2; } &>> $ctx_pbzip2/vm1.pbzip2.de &
	{ time taskset -c 24-46 /home/$kvm2/parsec-3.0/parsec/benchmark/pbzip2-1.1.13/pbzip2 -1 -p$1 -m1 -b1 -dkvf /home/wwjia/testA.bz2; } &>> $ctx_pbzip2/vm2.pbzip2.de
	sleep 30
done

#sockperf
#server side
SOCKPERF_DIR="/home/wwjia/workshop/vMigrater/macro_benchmarks/bench6/net_perf/sockperf/sockperf-3.1"
SOCKPERF_BIN="$SOCKPERF_DIR/sockperf"
{ time taskset -c 0-22 $SOCKPERF_BIN server --tcp -i $ip1 -p 23456; } &>> $ctx_sockperf/vm1.sockperf &
{ time taskset -c 24-46 $SOCKPERF_BIN server --tcp -i $ip2 -p 12345; } &>> $ctx_sockperf/vm2.sockperf &
for i in 1 2 3 4 5
do
	{ time taskset -c 0-22 $SOCKPERF_BIN pp --tcp -i $ip2 -p 12345 -t 30; } &>> $ctx_sockperf/vm1.sockperf &
	{ time taskset -c 24-46 $SOCKPERF_BIN pp --tcp -i $ip1 -p 23456 -t 30; } &>> $ctx_sockperf/vm2.sockperf
	sleep 30
done
killall sockperf
killall sockperf

#sysbench mysql OLTP
for i in 1 2 3 4 5
do
	{ time taskset -c 0-22 /usr/bin/sysbench --test=oltp --oltp-table-size=1000000 --mysql-db=test --mysql-user=root --mysql-password=123 --max-time=60 --oltp-read-only=on --max-requests=0 --num-threads=$1 run; } &>> $ctx_oltp/vm1.oltp &
	{ time taskset -c 24-46 /usr/bin/sysbench --test=oltp --oltp-table-size=1000000 --mysql-db=test --mysql-user=root --mysql-password=123 --max-time=60 --oltp-read-only=on --max-requests=0 --num-threads=$1 run; } &>> $ctx_oltp/vm2.oltp
	sleep 30
done
