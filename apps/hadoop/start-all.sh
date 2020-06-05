#!/bin/bash

sudo /etc/init.d/hadoop-0.20-mapreduce-jobtracker start
sudo /etc/init.d/hadoop-0.20-mapreduce-tasktracker start
sudo /etc/init.d/hadoop-hdfs-namenode start
sudo /etc/init.d/hadoop-hdfs-datanode start
sudo -u hdfs hadoop dfsadmin -safemode leave

sudo service zookeeper-server stop
sudo service zookeeper-server start
#sudo apt-get install hbase-master
sudo service hbase-master stop
sudo service hbase-master start
#sudo apt-get install hbase-regionserver
sudo service hbase-regionserver stop
sudo service hbase-regionserver start

