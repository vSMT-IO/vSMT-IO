#!/bin/bash

#$1: test name
#$2: task num
#$3: output file
#./scale_run.sh 48 6 pgbench

function usage() {
	echo -e "Usage:\n\t./test.sh client_num task_num output_file\n"
	echo -e "Example:\n\t./run.sh 48 24 pgbench\n"
}

if [ $# -ne 3 ]; then
	usage
	exit
fi


#./run.sh 48 24 pgbench

sudo su - postgres << EOF
echo 'sudo su postgres'
pgbench -i pgbench &>> $3
echo 'pgbench -i pgbench &>> $3'
pgbench -c $1  -j $2 -T 30 -r pgbench  
#echo "pgbench -c $1 -j $2 -T 30 -r pgbench &>> $3"
EOF

#sudo su postgres

#pgbench -i pgbench

#pgbench -c $1 -j $2 -T 30 -r pgbench &>> $3

#exit

