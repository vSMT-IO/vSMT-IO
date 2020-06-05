#!/bin/bash

CURPATH=`pwd`

sudo killall -9 clamd server.out
sleep 1
sudo killall -9 clamd server.out
cd $CURPATH/build
rm .db -rf

# if [ ! $1 ];
# then
        # echo "Usage: $0 <mongdb server port>"
        # echo "$0 7000"
        # exit 1;
# fi

sed '/TCPSocket/d' clamd.conf > server.conf
echo "TCPSocket 7000" >> server.conf

#LD_PRELOAD=$XTERN_ROOT/dync_hook/interpose.so \
./install/sbin/clamd --config-file=./server.conf &> out.txt &

echo "Clamd will be started in about 10 seconds, you could run: ps -ef | grep clamd. Please kill it after use."
echo ""
echo "Please don't run client now, wait about 10 seconds for clamd to start up."
echo ""
sleep 10

cd $CURPATH
