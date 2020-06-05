#!/bin/bash
cd spark-2.0.2-bin-hadoop2.3
./sbin/start-master.sh -h 127.0.0.1 -p 8082
logfile=`ls logs | grep "org.apache.spark.deploy.master" | head -1`
filepath="logs/$logfile"
b=`cat $filepath | grep "Successfully started service 'sparkMaster' on port"`
c=${b:${#b}-5:4}
./sbin/start-slave.sh spark://127.0.0.1:$c


if [ "$1" = "org.apache.spark.examples.SparkKMeans" ]; then
################################Kmeans##################################################################
SECONDS=0
./bin/spark-submit --master spark://127.0.0.1:$c --master local[$2] --class org.apache.spark.examples.SparkKMeans examples/jars/spark-examples_2.11-2.0.2.jar "data/weiwei/kmean/new.csv" 5 1 
duration=$SECONDS
echo $duration >> ../$3
########################################################################################################
elif [ "$1" = "org.apache.spark.examples.SparkPageRank" ]; then
#####################################PageRank###########################################################
SECONDS=0
./bin/spark-submit --master spark://127.0.0.1:$c --master local[$2] --class org.apache.spark.examples.SparkPageRank examples/jars/spark-examples_2.11-2.0.2.jar "data/weiwei/pr/new.csv" 10
duration=$SECONDS
echo $duration >> ../$3
########################################################################################################
elif [ "$1" = "org.apache.spark.examples.graphx.TriangleCountingExample" ]; then
SECONDS=0
./bin/spark-submit --master spark://127.0.0.1:$c --master local[$2]  --driver-memory 3g --executor-memory 3g  --class org.apache.spark.examples.graphx.TriangleCountingExample examples/jars/spark-examples_2.11-2.0.2.jar > o.txt
duration=$SECONDS
rm o.txt
echo $duration >> ../$3
elif [ "$1" = "org.apache.spark.examples.SparkHdfsLR" ]; then
#################################Linear Regression######################################################
SECONDS=0
./bin/spark-submit --master spark://127.0.0.1:$c --master local[$2] --class org.apache.spark.examples.SparkHdfsLR examples/jars/spark-examples_2.11-2.0.2.jar "data/weiwei/lr/new.csv" 10
duration=$SECONDS
echo $duration >> ../$3
######################################################################################################
elif [ "$1" = "org.apache.spark.examples.mllib.NaiveBayesExample" ]; then
#################################NaiveBayes###########################################################
SECONDS=0
./bin/spark-submit --master spark://127.0.0.1:$c --master local[$2]  --class org.apache.spark.examples.mllib.NaiveBayesExample examples/jars/spark-examples_2.11-2.0.2.jar
duration=$SECONDS
echo $duration >> ../$3
rm -rf target/tmp/myNaiveBayesModel/
rm -rf /home/hkucs/spark-2.0.2-bin-hadoop2.3/target/tmp/myNaiveBayesModel
######################################################################################################
elif [ "$1" = "org.apache.spark.examples.graphx.PageRankExample" ]; then
SECONDS=0
./bin/spark-submit --master spark://127.0.0.1:$c --master local[$2] --driver-memory 4g --executor-memory 4g  --class org.apache.spark.examples.graphx.PageRankExample examples/jars/spark-examples_2.11-2.0.2.jar > o.txt 
duration=$SECONDS
rm o.txt
echo $duration >> ../$3
fi

./sbin/stop-slave.sh
./sbin/stop-master.sh

cd ..

