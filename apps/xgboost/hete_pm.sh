#!/bin/bash
#
# Weiwei Jia <harryxiyou@gmail.com> (Bash) 2018
#
kvm1="wwjia"
kvm2="wwjia"
#ip1="192.168.122.96"
#ip2="192.168.122.98"
ctx=$2

#mount disk
#/home/$kvm1/vMigrater/scripts/mount.sh"
#/home/$kvm2/vMigrater/scripts/mount.sh"

#bc
/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu &>> $ctx/vm2.bc &
cd /home/$kvm1/xgboost/demo/binary_classification; 
for i in 1 2 3 4 5
do
	{ time ../../xgboost mushroom.conf nthread=$1; } &>> $ctx/vm1.bc
	#cd /home/kvm1/sda3/xgboost/demo/binary_classification; time taskset -c 0-22 ../../xgboost mushroom.conf nthread=$1" &>> $ctx/vm2.bc
	#sleep 10
done
killall accurate_cpu
sleep 5

#mc
/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu &>> $ctx/vm2.mc &
cd /home/$kvm1/xgboost/demo/multiclass_classification;
for i in 1 2 3 4 5
do
	{ time ./train23.py; } &>> $ctx/vm1.mc
	#cd /home/kvm1/sda3/xgboost/demo/multiclass_classification; time taskset -c 0-22 time ./train23.py" &>> $ctx/vm2.mc
	#sleep 10
done
killall accurate_cpu
sleep 5

#regression
/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu &>> $ctx/vm2.re &
cd /home/$kvm1/xgboost/demo/regression; 
for i in 1 2 3 4 5
do
	{ time ../../xgboost machine.conf nthread=$1; } &>> $ctx/vm1.re
	#cd /home/kvm1/sda3/xgboost/demo/regression; time taskset -c 0-22 ../../xgboost machine.conf nthread=$1" &>> $ctx/vm2.re
	#sleep 10
done
killall accurate_cpu
sleep 10

#year prediction
/home/$kvm2/parsec-3.0/parsec/vPair/inVM/accurate_cpu &>> $ctx/vm2.year &
cd /home/$kvm1/xgboost/demo/yearpredMSD; 
for i in 1 2 3 4 5
do
	{ time ../../xgboost yearpredMSD.conf nthread=$1; } &>> $ctx/vm1.year
	#cd /home/kvm1/sda3/xgboost/demo/yearpredMSD; time taskset -c 0-22 ../../xgboost yearpredMSD.conf nthread=$1" &>> $ctx/vm2.year
	#sleep 10
done
killall accurate_cpu
sleep 5

