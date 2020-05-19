echo "Enter no. of processes:"
read n
echo "Enter PID of all processes(Space Separated)"
read -a pid
echo "Enter burst time of all processes(Space Separated)"
read -a burst
echo "Enter arrival time of all processes(Space Separated)"
read -a arrive
echo "Enter time slice"
read slice
#round robin

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

for((x=0;x<n;x++))
do
	remain[$x]=${burst[$x]}
	wait[$x]=0
	last[$x]=0
	start[$x]=0
	finish[$x]=0
done

echo "Processing starts at ${arrive[0]}"
t=${arrive[0]}
done=0

while [ $done -ne $n ]
do
	for((i=0;i<n;i++))
	do
		given=0
		if test ${remain[$i]} -eq 0
		then
			continue
		elif test ${remain[$i]} -ge $slice
		then
			given=$slice
		else
			given=${remain[$i]}
		fi

		#note start time
		if test ${remain[$i]} -eq ${burst[$i]}
		then
			start[$i]=$t
		fi

		#note wait time since last turn
		waitadd=`expr $t - ${last[$i]}`
		wait[$i]=`expr ${wait[$i]} + $waitadd`

		#print
		echo -n "Process ${pid[$i]} from $t to "
		t=`expr $t + $given`
		echo $t
		last[$i]=$t

		#calculate remaining
		remain[$i]=`expr ${remain[$i]} - $given`

		#store finish time
		if test ${remain[$i]} -eq 0
		then
			finish[$i]=$t
			done=`expr $done + 1`
		fi
		
	done
done

waitsum=0
tasum=0

echo -e "PID\tBurst\tArrival\tStart\tFinish\tWait\tTA"

for((x=0;x<n;x++))
do
	#calculate wait and ta for all
	turnaround[$x]=`expr ${finish[$x]} - ${arrive[$x]}`
	wait[$x]=`expr ${wait[$x]} - ${arrive[$x]}`
	waitsum=`expr $waitsum + ${wait[$x]}`
	tasum=`expr $tasum + ${turnaround[$x]}`
	echo -e "${pid[$x]}\t${burst[$x]}\t${arrive[$x]}\t${start[$x]}\t${finish[$x]}\t${wait[$x]}\t${turnaround[$x]}" 
done

avgw=$(echo "$waitsum/$n" | bc -l)
avgta=$(echo "$tasum/$n" | bc -l)

echo "Average Wait Time: $avgw"
echo "Average TA Time: $avgta"
