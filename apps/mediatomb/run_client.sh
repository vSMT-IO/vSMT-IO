#!/bin/bash

#if [ ! $1 ];
#then
#        echo "Usage: $0 <server IP> <server port>"
#        echo "$0 127.0.0.1 7000"
#        exit 1;
#fi

#if [ ! $2 ];
#then
#        echo "Usage: $0 <server IP> <server port>"
#        echo "$0 127.0.0.1 7000"
#        exit 1;
#fi

if [ $# -ne 1 ]; then
	echo -e "\n\tUsage: ./run_client.sh thread#\n"
	exit
fi

rm -rf output1.avi
rm -rf output2.avi
rm -rf output3.avi
rm -rf output4.avi
rm -rf output5.avi

#time mencoder -lavdopts threads=$1 "http://127.0.0.1:7000/content/media/object_id/8/res_id/0" -o "output1.avi" -nosound -ovc raw & 
#time mencoder -lavdopts threads=$1 "http://127.0.0.1:7000/content/media/object_id/8/res_id/0" -o "output2.avi" -nosound -ovc raw & 
#time mencoder -lavdopts threads=$1 "http://127.0.0.1:7000/content/media/object_id/8/res_id/0" -o "output3.avi" -nosound -ovc raw & 
#time mencoder -lavdopts threads=$1 "http://127.0.0.1:7000/content/media/object_id/8/res_id/0" -o "output4.avi" -nosound -ovc raw & 
time mencoder -lavdopts threads=$1 "http://127.0.0.1:7000/content/media/object_id/8/res_id/0" -o "output5.avi" -nosound -ovc raw 
#mencoder "http://127.0.0.1:7000/content/media/object_id/8/res_id/0" -o "output.avi" -nosound -ovc raw 
#ab -n 8 -c 8 \
#	http://127.0.0.1:7000/content/media/object_id/8/res_id/none/pr_name/vlcmpeg/tr/1
