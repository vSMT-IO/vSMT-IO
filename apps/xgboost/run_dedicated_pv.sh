#!/bin/bash

app="xgboost"

#WOVPAIR_HOMO="$HOME/workshop/vPair/apps/$app/results/wovpair/homo"
#WVPAIR_HOMO="$HOME/workshop/vPair/apps/$app/results/wvpair/homo"
#WOVPAIR_HETE="$HOME/workshop/vPair/apps/$app/results/wovpair/hete"
PV_HETE="$HOME/workshop/vPair/apps/$app/results/pv"

#echo "$WOVPAIR_HOMO"
#echo "$WOVPAIR_HETE"
#echo "$WVPAIR_HOMO"
echo "$PV_HETE"
#./homo.sh 23 $WOVPAIR_HOMO
#./hete.sh 23 $WOVPAIR_HETE
#./homo.sh 23 $WVPAIR_HOMO
./hete.sh 23 $PV_HETE
