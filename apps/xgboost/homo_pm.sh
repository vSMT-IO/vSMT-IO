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
cd /home/$kvm1/xgboost/demo/binary_classification; 
for i in 1 2 3 4 5
do
	{ time ../../xgboost mushroom.conf nthread=$1; } &>> $ctx/vm1.bc &
	{ time ../../xgboost mushroom.conf nthread=$1; } &>> $ctx/vm2.bc
	sleep 10
done

#mc
cd /home/$kvm1/xgboost/demo/multiclass_classification;
for i in 1 2 3 4 5
do
	{ time ./train23.py; } &>> $ctx/vm1.mc &
	{ time ./train23.py; } &>> $ctx/vm2.mc
	sleep 10
done

#regression
cd /home/$kvm1/xgboost/demo/regression;
for i in 1 2 3 4 5
do
	{ time ../../xgboost machine.conf nthread=$1; } &>> $ctx/vm1.re &
	{ time ../../xgboost machine.conf nthread=$1; } &>> $ctx/vm2.re
	sleep 10
done

#year prediction
cd /home/$kvm1/xgboost/demo/yearpredMSD; 
for i in 1 2 3 4 5
do
	{ time ../../xgboost yearpredMSD.conf nthread=$1; } &>> $ctx/vm1.year &
	{ time ../../xgboost yearpredMSD.conf nthread=$1; } &>> $ctx/vm2.year
	sleep 10
done

