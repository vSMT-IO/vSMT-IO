#!/bin/bash

# Weiwei Jia <wj47@njit.edu>


if [ $# -ne 1 ]; then
	echo -e "./perf_analysis.sh pid"
	exit
fi


#record statistics
#context switches and IPC
./perf kvm record -e cs,instructions -a sleep 1
#report results, ./perf kvm report
#vcpus' time: from wait to ready; from ready to running; from running to finish.
stap -x $1 ./schedtimes.stp &>> sched.time &
sleep 2
killall stap

#good pairs, see pair.sh for details
