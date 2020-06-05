#!/bin/bash

sudo -u hdfs hadoop dfsadmin -safemode leave

source ~/.bashrc
sudo -u hdfs hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-client-jobclient-tests.jar TestDFSIO -write -nrFiles 64 -fileSize 1000MB -resFile /tmp/results.log
./flush
sudo -u hdfs hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-client-jobclient-tests.jar TestDFSIO -read -nrFiles 64 -fileSize 1000MB -resFile /tmp/results.log
./flush

#sudo -u hdfs hadoop jar /usr/lib/hadoop-0.20-mapreduce/hadoop-examples.jar teragen 100000000 /tmp/test2
#sudo -u hdfs hadoop jar /usr/lib/hadoop-0.20-mapreduce/hadoop-examples.jar terasort /tmp/test2 /tmp/test3
#sudo -u hdfs hadoop fs -rmr /tmp/test2
#sudo -u hdfs hadoop fs -rmr /tmp/test3

