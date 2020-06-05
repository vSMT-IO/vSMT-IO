#!/bin/bash
#mkdir mongo
killall mongod &> /dev/null
rm -rf /tmp/mongodb &> /dev/null
#cd mongo
#wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1604-4.0.0.tgz
#tar mongodb-linux-x86_64-ubuntu1604-4.0.0.tgz
#mkdir /tmp/mongodb
#cd mongodb-linux-x86_64-ubuntu1604-4.0.0
#./bin/mongod --dbpath /tmp/mongodb &
#cd ..

#sudo apt-get install openjdk-8-jdk
#sudo apt-get install maven

#curl -O --location https://github.com/brianfrankcooper/YCSB/releases/download/0.5.0/ycsb-0.5.0.tar.gz
#tar xfvz ycsb-0.5.0.tar.gz

#cd ycsb-0.5.0

#if [ $1 == "1" ]; then
#	time ./bin/ycsb load mongodb-async -s -P workloads/workloada > outputLoad.txt
#	time ./bin/ycsb run mongodb-async -s -P workloads/workloada > outputRun.txt
#else
#someone may change JAVA path, we fix it
#source ~/.bashrc
#time ./bin/ycsb load mongodb -s -P workloads/workloada 
#	time ./bin/ycsb run mongodb -s -P workloads/workloada -threads $1 &>> $2
#fi
#killall mongod &> /dev/null
#rm -rf /tmp/mongodb &> /dev/null
