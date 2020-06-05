#!/bin/bash

#Weiwei Jia <harryxiyou@gmail.com>

#/proc/[pid]/stat
#...
#(39) processor  %d  (since Linux 2.2.8)
#CPU number last executed on.
#...

start_vcpu=0
end_vcpu=23
vcpu_num=24
kvm1_path="/sys/fs/cgroup/cpuset/machine/kvm1.libvirt-qemu"
kvm8_path="/sys/fs/cgroup/cpuset/machine/kvm8.libvirt-qemu"
#ht[48]=


#echo "Array 47 is ${ht[47]}"

for ((;;))
do
sleep 0.015
for ((i=$start_vcpu; i<=$end_vcpu; i++))
do
	#echo $i
	kvm1_vcpu_path="$kvm1_path/vcpu$i/tasks"
	kvm8_vcpu_path="$kvm8_path/vcpu$i/tasks"
	kvm1_pid=`cat $kvm1_vcpu_path`
	kvm8_pid=`cat $kvm8_vcpu_path`
	#echo "$kvm1_pid, $kvm8_pid"
	kvm1_coreid=`./procstat $kvm1_pid`
	kvm8_coreid=`./procstat $kvm8_pid`
	ht[$kvm1_coreid]=0
	ht[$kvm1_coreid]=1
done

#give score
bad=0
good=0
for ((i=$start_vcpu; i<=$end_vcpu; i++))
do
	((j=$i+24))
	if [ "${ht[$i]}" == "${ht[$j]}" ]; then
		((bad=$bad+1))
	else
		((good=$good+1))
	fi
done

percent_good=`echo "$good/24 * 100" | bc -l`
percent_bad=`echo "$bad/24 * 100" | bc -l`

#echo "good is $good, %$percent_good"
#echo "bad is $bad, %$percent_bad"
echo -e "$percent_good\t\t$percent_bad"
done
