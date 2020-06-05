#!/bin/bash

lines=`wc -l $1 | awk '{print $1}' | bc`

echo "lines is $lines"
total=0
power=0

for ((i=2; i<=$lines;))
do
	power=`/usr/bin/awk 'NR=='$i' {print $19}' $1`
	echo "$power"
	#((total=$total+$power))
	total=`echo "scale=6; $total+$power" | bc -l`
	#((i=$i+4))
	#power2=`/usr/bin/awk 'NR=='$i' {print $19}' $1`
	#echo "P2:$power2"
	#delta=$(echo "$power2 - $power1" | bc)
	#echo "$delta"
	((i=$i+4))
done

result=`echo $total*4/$lines | bc -l`
echo "AVG.: $result"
