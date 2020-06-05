#!/bin/bash
#
# Weiwei Jia <wj47@njit.edu>
#

bench="bc"
case1="xgboost/$bench/hete"
case2="xgboost/$bench/homo"

ssh kvm@kvm2 "/home/kvm/parsec-3.0/parsec/cpu" >> ./results/$case1/vm2.hete.$bench  &
ssh kvm@kvm3 "/home/kvm/parsec-3.0/parsec/cpu" >> ./results/$case1/vm3.hete.$bench  &
ssh kvm@kvm4 "/home/kvm/parsec-3.0/parsec/cpu" >> ./results/$case1/vm4.hete.$bench  &
for i in 1 2
do
	ssh kvm@kvm8 "cd /home/kvm/xgboost/demo/binary_classification; ../../xgboost mushroom.conf nthread=16" &>> ./results/$case1/vm8.hete.$bench
done
ssh kvm@kvm2 "killall cpu"
ssh kvm@kvm3 "killall cpu"
ssh kvm@kvm4 "killall cpu"

for i in 1 2
do
	ssh kvm@kvm2 "cd /home/kvm/xgboost/demo/binary_classification; ../../xgboost mushroom.conf nthread=16" &>> ./results/$case1/vm2.homo.$bench &
	ssh kvm@kvm3 "cd /home/kvm/xgboost/demo/binary_classification; ../../xgboost mushroom.conf nthread=16" &>> ./results/$case1/vm3.homo.$bench &
	ssh kvm@kvm4 "cd /home/kvm/xgboost/demo/binary_classification; ../../xgboost mushroom.conf nthread=16" &>> ./results/$case1/vm4.homo.$bench &
	ssh kvm@kvm8 "cd /home/kvm/xgboost/demo/binary_classification; ../../xgboost mushroom.conf nthread=16" &>> ./results/$case1/vm8.homo.$bench
	sleep 20
done

