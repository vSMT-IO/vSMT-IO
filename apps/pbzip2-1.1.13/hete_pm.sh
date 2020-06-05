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
bench="ebizzy"
/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu >> $ctx_ebizzy/vm2.p.$bench  &
for i in 1 2 3 4 5
do
	{ time taskset -c 24-46 /home/$kvm1/parsec-3.0/parsec/benchmark/ebizzy-0.3/ebizzy -S 30 -t $1; } &>> $ctx_ebizzy/vm1.ebizzy
	#ssh $kvm2@$ip2 "/home/$kvm2/parsec-3.0/parsec/benchmark/ebizzy-0.3/ebizzy -S 30 -t $1" &>> $ctx_ebizzy/vm2.ebizzy
	#sleep 60
done
killall accurate_cpu
sleep 5

bench="hack"
/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu >> $ctx_hack/vm2.p.$bench  &
for i in 1 2 3 4 5
do
	{ time taskset -c 24-46 /home/$kvm1/parsec-3.0/parsec/benchmark/hackbench/hackbench 500 process $1; } &>> $ctx_hack/vm1.hack
	#ssh $kvm2@$ip2 "/home/$kvm2/parsec-3.0/parsec/benchmark/hackbench/hackbench 500 process $1" &>> $ctx_hack/vm2.hack
	#sleep 60
done
killall accurate_cpu
sleep 5

bench="kern"
cd /home/$kvm1/parsec-3.0/parsec/benchmark/kernbench-0.42;
/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu >> $ctx_kern/vm2.p.$bench  &
for i in 1 2 3 4 5
do
	{ time taskset -c 24-46 /home/$kvm1/parsec-3.0/parsec/benchmark/kernbench-0.42/kernbench -H -O -M -o $1 -n 1; }  &>> $ctx_kern/vm1.kern
	#ssh $kvm2@$ip2 "cd /home/$kvm2/parsec-3.0/parsec/benchmark/kernbench-0.42 && /home/$kvm2/parsec-3.0/parsec/benchmark/kernbench-0.42/kernbench -o $1"  &>> $ctx_kern/vm2.kern
	#sleep 60
done
killall accurate_cpu
sleep 5

bench="dbench"
/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu >> $ctx_dbench/vm2.p.$bench  &
#mount disk first
for i in 1 2 3 4 5
do
	{ time taskset -c 24-46 /usr/bin/dbench -c /usr/share/dbench/client.txt -D /home/$kvm1/ -t 30 $1; } &>> $ctx_dbench/vm1.dbench
	#ssh $kvm2@$ip2 "/usr/bin/dbench -c /usr/share/dbench/client.txt -D /home/$kvm2/sda3/ -t 30 $1" &>> $ctx_dbench/vm2.dbench
	#sleep 60
done
killall accurate_cpu
sleep 5

bench="pbzip2"
cd $HOME;
/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu >> $ctx_pbzip2/vm2.p.$bench  &
#compress
for i in 1 2 3 4 5
do
	{ time taskset -c 24-46 /home/$kvm1/parsec-3.0/parsec/benchmark/pbzip2-1.1.13/pbzip2 -1 -p$1 -m1 -b1 -rkvf /home/wwjia/testA; } &>> $ctx_pbzip2/vm1.pbzip2
	#ssh $kvm2@$ip2 "/home/$kvm2/parsec-3.0/parsec/benchmark/pbzip2-1.1.13/pbzip2 -1 -p$1 -m1 -b1 -rkvf ~/sda2/testA" &>> $ctx_pbzip2/vm2.pbzip2
	#sleep 60
done
killall accurate_cpu
sleep 5

bench="pbzip2_de"
/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu >> $ctx_pbzip2/vm2.p.$bench  &
#decompress
for i in 1 2 3 4 5
do
	{ time taskset -c 24-46 /home/$kvm1/parsec-3.0/parsec/benchmark/pbzip2-1.1.13/pbzip2 -1 -p$1 -m1 -b1 -dkvf /home/wwjia/testA.bz2; } &>> $ctx_pbzip2/vm1.pbzip2.de
	#ssh $kvm2@$ip2 "/home/$kvm2/parsec-3.0/parsec/benchmark/pbzip2-1.1.13/pbzip2 -1 -p$1 -m1 -b1 -dkvf ~/sda2/testA.bz2" &>> $ctx_pbzip2/vm2.pbzip2.de
	#sleep 60
done
killall accurate_cpu
sleep 5

#sockperf
#server side
SOCKPERF_DIR="/home/wwjia/workshop/vMigrater/macro_benchmarks/bench6/net_perf/sockperf/sockperf-3.1"
SOCKPERF_BIN="$SOCKPERF_DIR/sockperf"
/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu >> $ctx_sockperf/vm2.sockperf  &
time taskset -c 0-22 $SOCKPERF_BIN server --tcp -i $ip2 -p 12345 &>> $ctx_sockperf/vm2.sockperf &
for i in 1 2 3 4 5
do
	{ time taskset -c 24-46 $SOCKPERF_BIN pp --tcp -i 192.168.122.1 -p 12345 -t 30; } &>> $ctx_sockperf/vm1.sockperf
	#sleep 60
done
killall sockperf
killall accurate_cpu

#sysbench mysql OLTP
/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu >> $ctx_oltp/vm2.oltp  &
for i in 1 2 3 4 5
do
	{ time taskset -c 24-46 /usr/bin/sysbench --test=oltp --oltp-table-size=1000000 --mysql-db=test --mysql-user=root --mysql-password=123 --max-time=60 --oltp-read-only=on --max-requests=0 --num-threads=$1 run; } &>> $ctx_oltp/vm1.oltp
	#ssh $kvm2@$ip2 "/usr/bin/sysbench --test=oltp --oltp-table-size=1000000 --mysql-db=test --mysql-user=root --mysql-password=123 --max-time=60 --oltp-read-only=on --max-requests=0 --num-threads=$1 run" &>> $ctx_oltp/vm2.oltp
	sleep 30
done
killall accurate_cpu
