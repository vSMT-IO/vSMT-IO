#!/bin/bash

if [ -d spark-2.0.2-bin-hadoop2.3 ]; then
	sudo rm -rf spark-2.0.2-bin-hadoop2.3
fi

sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update
sudo apt install openjdk-8-jdk
wget "https://archive.apache.org/dist/spark/spark-2.0.2/spark-2.0.2-bin-hadoop2.3.tgz"
echo "Downloaded pre-built spark..."
tar -zxf spark-2.0.2-bin-hadoop2.3.tgz
echo "Extracted pre-built spark..."
cd spark-2.0.2-bin-hadoop2.3/data
mkdir weiwei
cd weiwei
mkdir follower user lr pr nb kmean

echo "
import random
import sys
import argparse
import csv
import string


def integer_csv(rows, schema, delimiter):
    random.seed(42)
    generators = []
    char_set = (string.ascii_letters + string.digits +
                '\"' + \"'\" + \"#&* \t\")

    for column in schema:
        if column == 'int':
            generators.append(lambda: random.randint(0,1000))
        elif column == 'str':
            generators.append(lambda: ''.join(
                random.choice(char_set) for _ in range(12)))
        elif column == 'float':
            generators.append(lambda: random.random())
        elif column == 'sec':
            randN = random.randint(0, 100)
            s = 0
            if randN > 98:
             s = 8
            elif randN > 94:
             s = 4
            elif randN > 79:
             s = 2
            elif randN > 49:
             s = 0
            generators.append(lambda: s)

    ofile = open('new.csv', \"wb\")
    writer = csv.writer(ofile, delimiter=delimiter)
    for x in xrange(rows):
        writer.writerow([g() for g in generators])

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Generate a large CSV file.',
        epilog='''\"Space is big. You just won't believe how vastly,
        hugely, mind-bogglingly big it is.\"''')
    parser.add_argument('rows', type=int,
                        help='number of rows to generate')
    parser.add_argument('--delimiter', type=str, default=',', required=False,
                        help='the CSV delimiter')
    parser.add_argument('schema', type=str, nargs='+',
                        choices=['int', 'str', 'float','sec'],
                        help='list of column types to generate')

    args = parser.parse_args()
    integer_csv(args.rows, args.schema, args.delimiter)
" > generate.py
cp generate.py follower/ 
cp generate.py user/ 
cp generate.py lr/ 
cp generate.py pr/ 
cp generate.py kmean/

echo "
import random
import sys
import argparse
import csv
import string


def integer_csv(rows, schema, delimiter):
    random.seed(42)
    generators = []
    char_set = (string.ascii_letters + string.digits +
                '\"' + \"'\" + \"#&* \t\")

    for column in schema:
        if column == 'int':
            generators.append(lambda: random.randint(0,1000))
        elif column == 'str':
            generators.append(lambda: ''.join(
                random.choice(char_set) for _ in range(12)))
        elif column == 'float':
            generators.append(lambda: random.random())
        elif column == 'sec':
            randN = random.randint(0, 100)
            s = 0
            if randN > 98:
             s = 8
            elif randN > 94:
             s = 4
            elif randN > 79:
             s = 2
            elif randN > 49:
             s = 0
            generators.append(lambda: random.randint(0,1))

    ofile = open('new.csv', \"wb\")
    writer = csv.writer(ofile, delimiter=delimiter)
    for x in xrange(rows):
        writer.writerow([random.randint(0,1),str(random.randint(100,200))+':'+str(random.randint(0,1000)),str(random.randint(201,300))+':'+str(random.randint(0,1000)),str(random.randint(301,400))+':'+str(random.randint(0,1000)),str(random.randint(401,500))+':'+str(random.randint(0,1000))])

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Generate a large CSV file.',
        epilog='''\"Space is big. You just won't believe how vastly,
        hugely, mind-bogglingly big it is.\"''')
    parser.add_argument('rows', type=int,
                        help='number of rows to generate')
    parser.add_argument('--delimiter', type=str, default=',', required=False,
                        help='the CSV delimiter')
    parser.add_argument('schema', type=str, nargs='+',
                        choices=['int', 'str', 'float','sec'],
                        help='list of column types to generate')

    args = parser.parse_args()
    integer_csv(args.rows, args.schema, args.delimiter)
" > generate.py
mv generate.py nb/

echo "Generating graph data (1/6)..."
cd follower
python generate.py 10720000 --delimiter ' ' int int	
mv new.csv ../../graphx/followers.txt
cd ..

echo "Generating other graph data (2/6)..."
cd user
python generate.py 10720000 --delimiter ',' int int	
mv new.csv ../../graphx/users.txt
cd ..

echo "Generating Naive Bayes data (3/6)..."
cd nb
python generate.py 90000000 --delimiter ' ' int
mv new.csv ../../mllib/sample_libsvm_data.txt
cd ..		

echo "Generating Linear Regression data (4/6)..."
cd lr
python generate.py 24000000 --delimiter ' ' int int int int int int int int int int int	
cd ..	

echo "Generating Page Rank data (5/6)..."
cd pr
python generate.py 100000000 --delimiter ' ' int int
cd ..

echo "Generating KMeans data (6/6)..."
cd kmean
python generate.py 270000000 --delimiter ' ' int int int
cd
echo "Successfully generated all data"





