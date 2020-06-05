#!/bin/bash


sudo su - postgres << EOF
echo 'sudo su postgres'
psql -c "create database pgbench;"
EOF

#sudo su postgres

#pgbench -i pgbench

#pgbench -c $1 -j $2 -T 30 -r pgbench &>> $3

#exit

