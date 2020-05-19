echo "Enter no. of processes:"
read n
echo "Enter PID of all processes(Space Separated)"
read -a pid
echo "Enter burst time of all processes(Space Separated)"
read -a burst
echo "Enter arrival time of all processes(Space Separated)"
read -a arrive
#fifo
#selection sort
for((x=0;x<n-1;x++))
do
	pos=$x
	min=${arrive[$x]}
	for((y=$x+1;y<n;y++))
	do
		if test ${arrive[$y]} -lt $min
		then
			pos=$y
			min=${arrive[$y]}
		fi
	done
	p1=${pid[$x]}
	b1=${burst[$x]}
	a1=${arrive[$x]}
	arrive[$x]=$min
	pid[$x]=${pid[$pos]}
	burst[$x]=${burst[$pos]}
	burst[$pos]=$b1
	pid[$pos]=$p1
	arrive[$pos]=$a1
done
echo "Processing starts at t=${arrive[0]}"
t=${arrive[0]}
i=0
echo -e "PID\tBurst\tArrival\tStart\tFinish\tWait\tTA"
while [ $i -lt $n ]
do
	if test $t -ge ${arrive[$i]}
	then
		wait[$i]=`expr $t - ${arrive[$i]}`
		finish=`expr $t + ${burst[$i]}`
		turnaround[$i]=`expr $finish - ${arrive[$i]}`
		echo -e "${pid[$i]}\t${burst[$i]}\t${arrive[$i]}\t$t\t$finish\t${wait[$i]}\t${turnaround[$i]}"
		t=$finish
		i=`expr 1 + $i`
	else
		t=`expr $t + 1`
	fi	
done
sumwait=0
sumta=0
j=0
while [ $j -lt $n ]
do
	sumwait=`expr $sumwait + ${wait[$j]}`
	sumta=`expr $sumta + ${turnaround[$j]}`
	j=`expr 1 + $j`
done
avgw=$(echo "$sumwait/$n" | bc -l)
avgta=$(echo "$sumta/$n" | bc -l)
echo "Average Wait Time: $avgw"
echo "Average TA Time: $avgta"
