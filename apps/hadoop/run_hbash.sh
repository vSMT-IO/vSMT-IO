#!/bin/bash


./bin/ycsb run hbase098 -P workloads/workloada -cp /etc/hbase/conf -p table=usertable -p columnfamily=family -threads 32
