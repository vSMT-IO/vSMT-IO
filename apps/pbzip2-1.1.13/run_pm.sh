#!/bin/bash

bench="pbzip2-1.1.13"

PM_HOMO="$HOME/workshop/vPair/apps/$bench/results/pm/homo"
PM_HETE="$HOME/workshop/vPair/apps/$bench/results/pm/hete"

echo "$PM_HOMO"
echo "$PM_HETE"
./homo_pm.sh 23 $PM_HOMO
./hete_pm.sh 23 $PM_HETE
