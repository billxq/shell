#!/bin/bash
i=3
while [ $i -gt 0 ];do
read -p "Please input a number to sum: " n
if [ ! -z "$(echo $n | sed 's/[0-9]//g')" ];then
	echo "Please input a number!"
	let "i=i-1" 
	echo "You have $i times left!"
	continue
else
	break
fi
done

sum=0
for num in `seq 1 $n`;do
	if [ "$(expr $num % 2)" == 0 ];then
		let "sum+=num"
	fi
done	
echo "The total is:$sum"

