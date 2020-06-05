#!/bin/bash

#$1: test name
#$2: task num
#$3: output file

function usage() {
	echo -e "Usage:\n\t./test.sh test_name task_num output_file\n"
}

if [ $# -ne 3 ]; then
	usage
	exit
fi

if [ $1 == "pagerank" ]; then
	./run.sh org.apache.spark.examples.SparkPageRank $2 $3 &>> /tmp/error.txt
elif [ $1 == "kmeans" ]; then
	./run.sh org.apache.spark.examples.SparkKMeans $2 $3 &>> /tmp/error.txt
elif [ $1 == "lr" ]; then
	./run.sh org.apache.spark.examples.SparkHdfsLR $2 $3 &>> /tmp/error.txt
elif [ $1 == "nb" ]; then
	./run.sh org.apache.spark.examples.mllib.NaiveBayesExample $2 $3 &>> /tmp/error.txt
fi
#./run.sh org.apache.spark.examples.graphx.TriangleCountingExample 24 output.txt 2> 3.txt
#./run.sh org.apache.spark.examples.graphx.PageRankExample 24 output.txt 2> 6.txt

