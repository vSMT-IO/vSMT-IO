#!/bin/bash

#tested by Weiwei Jia on Ubuntu 16.04 (i.e., Xenial)

#sudo /etc/init.d/hadoop-0.20-mapreduce-jobtracker start
#sudo /etc/init.d/hadoop-0.20-mapreduce-tasktracker start
#sudo /etc/init.d/hadoop-hdfs-namenode start
#sudo /etc/init.d/hadoop-hdfs-datanode start
#sudo -u hdfs hadoop dfsadmin -safemode leave

sudo service zookeeper-server stop
#sudo service zookeeper-server start
#sudo apt-get install hbase-master
sudo service hbase-master stop
#sudo service hbase-master start
#sudo apt-get install hbase-regionserver
sudo service hbase-regionserver stop
#sudo service hbase-regionserver start


sudo rm /etc/apt/preferences.d/cloudera.pref
sudo cp ./cloudera.pref /etc/apt/preferences.d/cloudera.pref

sudo rm -rf /etc/hbase/conf
sudo mkdir -p /etc/hbase/conf
sudo cp ./hbase-site.xml /etc/hbase/conf/hbase-site.xml

sudo -u hdfs hadoop fs -rm -r /hbase
sudo -u hdfs hadoop fs -mkdir /hbase
sudo -u hdfs hadoop fs -chown hbase /hbase

sudo rm -rf /var/lib/zookeeper
sudo mkdir -p /var/lib/zookeeper
sudo chown -R zookeeper /var/lib/zookeeper/

sudo apt-get install zookeeper-server
sudo service zookeeper-server init
sudo service zookeeper-server start

sudo apt-get install hbase-master
sudo service hbase-master start

sudo apt-get install hbase-regionserver
sudo service hbase-regionserver start
