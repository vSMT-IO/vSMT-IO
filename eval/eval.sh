#!/bin/bash

vPair_HOME_DIR="$HOME/workshop/vPair"
EVAL_HOME_DIR="$vPair_HOME_DIR/eval"

source "$EVAL_HOME_DIR/$1"

usage() {
	if [ $1 == "vPair-2VMs.cfg" ]; then
		echo "./eval.sh config_file VM1_bench VM2_bench"
		exit
	fi
}

if [ $# -ne 3 ]; then
	usage
fi

echo -e "vPair config file: $1\nVM1 Bench1: $2\nVM2 Bench2: $3"
echo -e "kvm_num: $kvm_num\nkvm1: $kvm1\nkvm2: $kvm2\nkvm1_ip: $kvm1_ip\nkvm2_ip: $kvm2_ip"
