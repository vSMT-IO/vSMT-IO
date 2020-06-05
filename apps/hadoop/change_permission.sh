#!/bin/bash

sudo -u hdfs hdfs dfs -chmod 775 /
sudo -u hdfs hdfs dfs -chown mapred:mapred /
sudo -u hdfs hdfs dfs -mkdir /user
sudo -u hdfs hdfs dfs -chown mapred:mapred /user
sudo -u hdfs hdfs dfs -mkdir /tmp
sudo -u hdfs hdfs dfs -chown mapred:mapred /tmp
