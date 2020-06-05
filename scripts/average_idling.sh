#!/bin/bash

prev=0
next=0
flag=0
count10=0
count100=0
count300=0
count500=0
count1000=0
count3000=0
count5000=0
total=0

lines=`wc -l $1 | awk '{print $1}' | bc`

echo "lines: $lines"

for ((i=1; i<$lines; i++))
do
	time=`/usr/bin/awk 'NR=='$i' {print $8}' $1 | bc`
	if [ $time -gt 10000 ]; then
		continue
	fi
	((total=$total+$time))
echo "total: $total"
average=`echo "scale=2;$total/$i" | bc -l`
echo "avg: $average"
done


echo "total: $total"
