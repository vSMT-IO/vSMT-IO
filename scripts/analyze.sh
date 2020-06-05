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
	vcpuid=`/usr/bin/awk 'NR=='$i' {print $7}' $1`
	#echo "id: $vcpuid"
	if [ "$vcpuid" == "$2" ]; then
		((total=$total+1))
		if [ $flag -eq 0 ]; then
			prev=`/usr/bin/awk 'NR=='$i' {print $8}' $1 | bc`
			flag=1
		else
			next=`/usr/bin/awk 'NR=='$i' {print $8}' $1 | bc`
			if [ $prev -le 10 ] && [ $next -le 10 ]; then
				((count10=$count10+1))
			elif [ $prev -ge 10 ] && [ $next -ge 10 ]; then
				((count10=$count10+1))
			fi
			if [ $prev -le 100 ] && [ $next -le 100 ]; then
				((count100=$count100+1))
			elif [ $prev -ge 100 ] && [ $next -ge 100 ]; then
				((count100=$count100+1))
			fi
			if [ $prev -le 300 ] && [ $next -le 300 ]; then
				((count300=$count300+1))
			elif [ $prev -ge 300 ] && [ $next -ge 300 ]; then
				((count300=$count300+1))
			fi
			if [ $prev -le 500 ] && [ $next -le 500 ]; then
				((count500=$count500+1))
			elif [ $prev -ge 500 ] && [ $next -ge 500 ]; then
				((count500=$count500+1))
			fi
			if [ $prev -le 1000 ] && [ $next -le 1000 ]; then
				((count1000=$count1000+1))
			elif [ $prev -ge 1000 ] && [ $next -ge 1000 ]; then
				((count1000=$count1000+1))
			fi
			if [ $prev -le 3000 ] && [ $next -le 3000 ]; then
				((count3000=$count3000+1))
			elif [ $prev -ge 3000 ] && [ $next -ge 3000 ]; then
				((count3000=$count3000+1))
			fi
			if [ $prev -le 5000 ] && [ $next -le 5000 ]; then
				((count5000=$count5000+1))
			elif [ $prev -ge 5000 ] && [ $next -ge 5000 ]; then
				((count5000=$count5000+1))
			fi
			((prev=$next))
		fi
echo "10us: $count10"
echo "100us: $count100"
echo "300us: $count300"
echo "500us: $count500"
echo "1000us: $count1000"
echo "3000us: $count3000"
echo "5000us: $count5000"
echo "total: $total"
	fi
done

echo "10us: $count10"
echo "100us: $count100"
echo "300us: $count300"
echo "500us: $count500"
echo "1000us: $count1000"
echo "3000us: $count3000"
echo "5000us: $count5000"
echo "total: $total"

