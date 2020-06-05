#!/bin/bash

#https://github.com/brianfrankcooper/YCSB/tree/master/hbase098
#hbase(main):001:0> n_splits = 200 # HBase recommends (10 * number of regionservers)
#hbase(main):002:0> create 'usertable', 'family', {SPLITS => (1..n_splits).map {|i| "user#{1000+i*(9999-1000)/n_splits}"}}


bin/ycsb load hbase -P workloads/workloada -cp /etc/hbase/conf -p table=usertable -p columnfamily=family
