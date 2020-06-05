#!/bin/bash

sudo -u hdfs hadoop dfsadmin -safemode leave

#hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-client-jobclient-tests.jar TestDFSIO -write -size 100MB
#hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-client-jobclient-tests.jar TestDFSIO -read -size 100MB

sudo -u hdfs hadoop jar /usr/lib/hadoop-0.20-mapreduce/hadoop-examples.jar teragen 10000000 /tmp/test2 -resFile /tmp/terasort.log
time sudo -u hdfs hadoop jar /usr/lib/hadoop-0.20-mapreduce/hadoop-examples.jar terasort /tmp/test2 /tmp/test3 -resFile /tmp/terasort.log
sudo -u hdfs hadoop fs -rm -r /tmp/test2
sudo -u hdfs hadoop fs -rm -r /tmp/test3

