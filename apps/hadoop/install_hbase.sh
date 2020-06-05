#!/bin/bash

#tested by Weiwei Jia on Ubuntu 16.04 (i.e., Xenial)

sudo cp ./cloudera.pref /etc/apt/preferences.d/cloudera.pref

sudo mkdir -p /etc/hbase/conf
sudo cp ./hbase-site.xml /etc/hbase/conf/hbase-site.xml

sudo -u hdfs hadoop fs -mkdir /hbase
sudo -u hdfs hadoop fs -chown hbase /hbase

mkdir -p /var/lib/zookeeper
sudo chown -R zookeeper /var/lib/zookeeper/

#fix error: The following packages have unmet dependencies:
#zookeeper-server : Depends: zookeeper
#(= 3.4.5+cdh5.15.1+149-1.cdh5.15.1.p0.4~xenial-cdh5.15.1) but 3.4.8-1 is to be installed
#E: Unable to correct problems, you have held broken packages.
#
#sudo apt-get purge zookeeper

sudo apt-get install zookeeper-server
sudo service zookeeper-server init
sudo service zookeeper-server start

sudo apt-get install hbase-master
sudo service hbase-master start


sudo apt-get install hbase-regionserver
sudo service hbase-regionserver start
