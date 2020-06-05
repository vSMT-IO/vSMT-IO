#!/bin/bash


./stop-all.sh
./PLEoff.sh 
./disable_halt_poll.sh 
./enable_mwait.sh 
sudo mount /dev/sdh1 /mnt

