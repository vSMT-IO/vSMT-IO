#!/bin/bash

#$1: # of requests
#$2: # of clients

usage() {
	echo -e "\n\tUsage: ./run [# of requests] [# of clients]\n"
	echo -e "\n\tExample: ab -n 100000000 -c 1000 http://localhost/\n"
}


if [ $# != 2 ]; then
	usage
	exit
fi

sudo /etc/init.d/nginx stop
sudo /etc/init.d/apache2 start
#ab -n 100000000 -c 1000 http://localhost/
ab -n $1 -c $2 http://localhost/
