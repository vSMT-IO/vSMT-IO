#!/bin/bash

#
# Weiwei Jia <wj47@njit.edu>
#
# context switch problem for vHT research project.
#

kvm1="kvm1"
kvm2="kvm1"
ip1="192.168.122.96"
ip2="192.168.122.98"
ctx_ebizzy=$2
ctx_hack=$2
ctx_kern=$2
ctx_dbench=$2
ctx_pbzip2=$2
ctx_sockperf=$2
ctx_oltp=$2

#mount disk
ssh $kvm1@$ip1 "/home/$kvm1/vMigrater/scripts/mount.sh"
ssh $kvm2@$ip2 "/home/$kvm2/vMigrater/scripts/mount.sh"

#ebizzy
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 /home/$kvm1/parsec-3.0/parsec/benchmark/ebizzy-0.3/ebizzy -S 30 -t $1" &>> $ctx_ebizzy/vm1.ebizzy &
	ssh $kvm2@$ip2 "time taskset -c 0-22 /home/$kvm2/parsec-3.0/parsec/benchmark/ebizzy-0.3/ebizzy -S 30 -t $1" &>> $ctx_ebizzy/vm2.ebizzy
	sleep 30
done

for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 /home/$kvm1/parsec-3.0/parsec/benchmark/hackbench/hackbench 500 process $1" &>> $ctx_hack/vm1.hack &
	ssh $kvm2@$ip2 "time taskset -c 0-22 /home/$kvm2/parsec-3.0/parsec/benchmark/hackbench/hackbench 500 process $1" &>> $ctx_hack/vm2.hack
	sleep 30
done

for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "cd /home/$kvm1/parsec-3.0/parsec/benchmark/kernbench-0.42 && time taskset -c 0-22 /home/$kvm1/parsec-3.0/parsec/benchmark/kernbench-0.42/kernbench -H -O -M -o $1 -n 1"  &>> $ctx_kern/vm1.kern &
	ssh $kvm2@$ip2 "cd /home/$kvm2/parsec-3.0/parsec/benchmark/kernbench-0.42 && time taskset -c 0-22 /home/$kvm2/parsec-3.0/parsec/benchmark/kernbench-0.42/kernbench -H -O -M -o $1 -n 1"  &>> $ctx_kern/vm2.kern
	sleep 30
done

#mount disk first
#dbench
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 /usr/bin/dbench -c /usr/share/dbench/client.txt -D /home/$kvm1/sda3/ -t 30 $1" &>> $ctx_dbench/vm1.dbench &
	ssh $kvm2@$ip2 "time taskset -c 0-22 /usr/bin/dbench -c /usr/share/dbench/client.txt -D /home/$kvm2/sda3/ -t 30 $1" &>> $ctx_dbench/vm2.dbench
	sleep 30
done

#pbzip2
#compress
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 /home/$kvm1/parsec-3.0/parsec/benchmark/pbzip2-1.1.13/pbzip2 -1 -p$1 -m1 -b1 -rkvf ~/sda2/testA" &>> $ctx_pbzip2/vm1.pbzip2 &
	ssh $kvm2@$ip2 "time taskset -c 0-22 /home/$kvm2/parsec-3.0/parsec/benchmark/pbzip2-1.1.13/pbzip2 -1 -p$1 -m1 -b1 -rkvf ~/sda2/testA" &>> $ctx_pbzip2/vm2.pbzip2
	sleep 30
done

#decompress
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 /home/$kvm1/parsec-3.0/parsec/benchmark/pbzip2-1.1.13/pbzip2 -1 -p$1 -m1 -b1 -dkvf ~/sda2/testA.bz2" &>> $ctx_pbzip2/vm1.pbzip2.de &
	ssh $kvm2@$ip2 "time taskset -c 0-22 /home/$kvm2/parsec-3.0/parsec/benchmark/pbzip2-1.1.13/pbzip2 -1 -p$1 -m1 -b1 -dkvf ~/sda2/testA.bz2" &>> $ctx_pbzip2/vm2.pbzip2.de
	sleep 30
done

#sockperf
#server side
SOCKPERF_DIR="/home/kvm1/vMigrater/apps/macro_benchmarks/bench6/net_perf/sockperf/sockperf-3.1"
SOCKPERF_BIN="$SOCKPERF_DIR/sockperf"
ssh $kvm1@$ip1 "time taskset -c 0-22 $SOCKPERF_BIN server --tcp -i $ip1 -p 23456" &>> $ctx_sockperf/vm1.sockperf &
ssh $kvm2@$ip2 "time taskset -c 0-22 $SOCKPERF_BIN server --tcp -i $ip2 -p 12345" &>> $ctx_sockperf/vm2.sockperf &
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 $SOCKPERF_BIN pp --tcp -i $ip2 -p 12345 -t 30" &>> $ctx_sockperf/vm1.sockperf &
	ssh $kvm2@$ip2 "time taskset -c 0-22 $SOCKPERF_BIN pp --tcp -i $ip1 -p 23456 -t 30" &>> $ctx_sockperf/vm2.sockperf
	sleep 30
done
ssh $kvm1@$ip1 "killall sockperf"
ssh $kvm2@$ip2 "killall sockperf"

#sysbench mysql OLTP
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "time taskset -c 0-22 /usr/bin/sysbench --test=oltp --oltp-table-size=1000000 --mysql-db=test --mysql-user=root --mysql-password=123 --max-time=60 --oltp-read-only=on --max-requests=0 --num-threads=$1 run" &>> $ctx_oltp/vm1.oltp &
	ssh $kvm2@$ip2 "time taskset -c 0-22 /usr/bin/sysbench --test=oltp --oltp-table-size=1000000 --mysql-db=test --mysql-user=root --mysql-password=123 --max-time=60 --oltp-read-only=on --max-requests=0 --num-threads=$1 run" &>> $ctx_oltp/vm2.oltp
	sleep 30
done
