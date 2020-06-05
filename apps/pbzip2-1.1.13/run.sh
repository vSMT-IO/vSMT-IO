#!/bin/bash

WOVPAIR_HOMO="$HOME/workshop/vPair/apps/pbzip2-1.1.13/results/wovpair/homo"
WVPAIR_HOMO="$HOME/workshop/vPair/apps/pbzip2-1.1.13/results/wvpair/homo"
WOVPAIR_HETE="$HOME/workshop/vPair/apps/pbzip2-1.1.13/results/wovpair/hete"
WVPAIR_HETE="$HOME/workshop/vPair/apps/pbzip2-1.1.13/results/wvpair/hete"

#echo "$WOVPAIR_HOMO"
#echo "$WOVPAIR_HETE"
#./homo.sh 23 $WOVPAIR_HOMO
#./hete.sh 23 $WOVPAIR_HETE
echo "$WVPAIR_HOMO"
echo "$WVPAIR_HETE"
./homo.sh 23 $WVPAIR_HOMO
./hete.sh 23 $WVPAIR_HETE
