#sjf non-pre-emptive

echo "Enter no. of processes"
read n
echo "Enter PID for all process, separated by spaces:"
read -a pid
echo "Enter burst time for all process, separated by spaces:"
read -a burst
echo "Enter arrival time for all process, separated by spaces:"
read -a arrive

function shortest(){
	i=-1
	min=999
	currtime=$1
	for((x=0;x<n;x++))
	do
		if [ $min -gt ${burst[$x]} ] && [ ${arrive[$x]} -le $currtime ]
		then
			i=$x
			min=${burst[$i]}
		fi
	done
	return $i
}

time=0
done=0
burstcopy=("${burst[@]}") #created a copy of burst array
#calculations
while [ $done -ne $n ]
do
	shortest $time 			#calling function to get the shortest job
	next="$?" 				#next has index of shortest job
	start[$next]=$time
	wait[$next]=`expr ${start[$next]} - ${arrive[$next]}`

	echo -n "From T=$time to "	

	time=`expr ${burst[$next]} + $time`		#current time after completing shortest job
	finish[$next]=$time		

	echo "$time : Process ${pid[$next]}"
	ta[$next]=`expr ${finish[$next]} - ${arrive[$next]}`
	burst[$next]=1000		
	((done++))
done

echo -e "PID\tBurst\tArrive\tStart\tFinish\tWait\tTA"

for((i=0;i<n;i++))
do
	echo -e "${pid[$i]}\t${burstcopy[$i]}\t${arrive[$i]}\t${start[$i]}\t${finish[$i]}\t${wait[$i]}\t${ta[$i]}"
	sumwait=`expr $sumwait + ${wait[$i]}`
	sumta=`expr $sumta + ${ta[$i]}`
done
avgw=$(echo "$sumwait/$n" | bc -l)
avgta=$(echo "$sumta/$n" | bc -l)
echo "Average Wait Time: $avgw"
echo "Average TA Time: $avgta"
