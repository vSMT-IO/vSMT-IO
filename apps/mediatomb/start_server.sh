#!/bin/bash

curpath=$PWD

#if [ ! $1 ];
#then
#       echo "Usage: $0 <server IP> <server port>"
#        echo "$0 127.0.0.1 7000"
#        exit 1;
#fi

#if [ ! $2 ];
#then
#        echo "Usage: $0 <server IP> <server port>"
#        echo "$0 127.0.0.1 7000"
#        exit 1;
#fi

sudo killall mediatomb
mediatomb -d -i 127.0.0.1 -p 7000 -a ${curpath}/test1.mkv
#mediatomb -i 127.0.0.1 -p 7000 -m $PWD
