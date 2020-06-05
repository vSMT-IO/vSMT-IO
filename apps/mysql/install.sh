#!/bin/bash

sudo apt-get install mysql-server
sudo apt-get install mysql-client
sudo apt-get install sysbench

mysql -u root -p

#https://www.jamescoyle.net/how-to/1131-benchmark-mysql-server-performance-with-sysbench
#CREATE DATABASE dbtest;
#CREATE DATABASE sbtest;
#CREATE USER 'sbtest'@'localhost';
#GRANT ALL PRIVILEGES ON * . * TO 'sbtest'@'localhost';
#FLUSH PRIVILEGES;
#quit;



#XXX: reference, https://serverfault.com/questions/666159/sysbench-mysql-cannot-connect
