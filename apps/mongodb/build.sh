#!/bin/bash
mkdir mongo
cd mongo
wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1604-4.0.0.tgz
tar xfvz mongodb-linux-x86_64-ubuntu1604-4.0.0.tgz
#mkdir /tmp/mongodb
#cd mongodb-linux-x86_64-ubuntu1604-4.0.0
#./bin/mongod --dbpath /tmp/mongodb &>/dev/null &
#cd ..

sudo apt-get install openjdk-8-jdk
sudo apt-get install maven

sudo apt-get install curl
curl -O --location https://github.com/brianfrankcooper/YCSB/releases/download/0.5.0/ycsb-0.5.0.tar.gz
tar xfvz ycsb-0.5.0.tar.gz
cp ../workloada ./ycsb-0.5.0/workloads
#cd ycsb-0.5.0
#./bin/ycsb load mongodb-async -s -P workloads/workloada > outputLoad.txt
#./bin/ycsb run mongodb-async -s -P workloads/workloada > outputRun.txt
#./bin/ycsb load mongodb -s -P workloads/workloada > outputLoad.txt
#./bin/ycsb run mongodb -s -P workloads/workloada > outputRun.txt

