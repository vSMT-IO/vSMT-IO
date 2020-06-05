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
ctx_ebizzy="ctx/heter/ebizzy"
ctx_hack="ctx/heter/hackbench"
ctx_kern="ctx/heter/kernbench"
ctx_dbench="ctx/heter/dbench"

#ebizzy
ssh $kvm2@$ip2 "/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu" >> ./results/$ctx_ebizzy/vm2.cpu  &
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "/home/$kvm1/parsec-3.0/parsec/benchmark/ebizzy-0.3/ebizzy -S 30 -t 24" >> ./results/$ctx_ebizzy/vm1.ebizzy
#	ssh $kvm2@$ip2 "/home/$kvm2/parsec-3.0/parsec/benchmark/ebizzy-0.3/ebizzy -S 30 -t 24" >> ./results/$ctx_ebizzy/vm2.ebizzy
	sleep 60
done
ssh $kvm2@$ip2 "killall accurate_cpu"


ssh $kvm2@$ip2 "/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu" >> ./results/$ctx_hack/vm2.cpu  &
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "/home/$kvm1/parsec-3.0/parsec/benchmark/hackbench/hackbench 500 process 24" >> ./results/$ctx_hack/vm1.hack
#	ssh $kvm2@$ip2 "/home/$kvm2/parsec-3.0/parsec/benchmark/hackbench/hackbench 500 process 24" >> ./results/$ctx_hack/vm2.hack
	sleep 60
done
ssh $kvm2@$ip2 "killall accurate_cpu"

ssh $kvm2@$ip2 "/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu" >> ./results/$ctx_kern/vm2.cpu  &
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "cd /home/$kvm1/parsec-3.0/parsec/benchmark/kernbench-0.42 && /home/$kvm1/parsec-3.0/parsec/benchmark/kernbench-0.42/kernbench"  >> ./results/$ctx_kern/vm1.kern
#	ssh $kvm2@$ip2 "cd /home/$kvm2/parsec-3.0/parsec/benchmark/kernbench-0.42 && /home/$kvm2/parsec-3.0/parsec/benchmark/kernbench-0.42/kernbench -o 24"  >> ./results/$ctx_kern/vm2.kern
	sleep 60
done
ssh $kvm2@$ip2 "killall accurate_cpu"

ssh $kvm2@$ip2 "/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu" >> ./results/$ctx_dbench/vm2.cpu  &
#mount disk first
for i in 1 2 3 4 5
do
	ssh $kvm1@$ip1 "/usr/bin/dbench -c /usr/share/dbench/client.txt -D /home/$kvm1/sda3/ -t 30 24" >> ./results/$ctx_dbench/vm1.dbench
	#ssh $kvm2@$ip2 "/usr/bin/dbench -c /usr/share/dbench/client.txt -D /home/$kvm2/sda3/ -t 30 24" >> ./results/$ctx_dbench/vm2.dbench
	sleep 60
done
ssh $kvm2@$ip2 "killall accurate_cpu"
