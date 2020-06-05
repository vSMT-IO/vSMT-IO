#!/bin/bash

sudo rm -rf /var/lib/hadoop-hdfs/cache/hdfs/dfs/*
sudo apt-get install openjdk-8-jdk

#TODO: setup ~/.bashrc as follows
sed -i '$aexport JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' ~/.bashrc
sed -i '$aexport HADOOP_HOME=/usr/lib/hadoop' ~/.bashrc
sed -i '$aexport PATH=/root/bin:/home/kvm1/workshop/parsec-3.0/bin:$JAVA_HOME/bin:$HADOOP_HOME/bin:$PATH' ~/.bashrc

#install and deploy CDH5: https://www.cloudera.com/documentation/enterprise/5-11-x/topics/cdh_ig_cdh5_install.html

wget https://archive.cloudera.com/cdh5/ubuntu/xenial/amd64/cdh/archive.key -O archive.key
sudo apt-key add archive.key
sudo wget 'https://archive.cloudera.com/cdh5/ubuntu/xenial/amd64/cdh/cloudera.list' -O /etc/apt/sources.list.d/cloudera.list
sudo cp ./cloudera.list /etc/apt/sources.list.d/cloudera.list
#sudo wget 'https://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/cloudera.list' -O /etc/apt/sources.list.d/cloudera.list
sudo apt-get update
sudo apt-get install hadoop-0.20-conf-pseudo
#sudo apt-get install hadoop-conf-pseudo

sudo -u hdfs hadoop namenode -format

./stop-all.sh
./start-all.sh
./change_permission.sh
./stop-all.sh
./start-all.sh
