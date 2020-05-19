echo "Enter no. of processes:"
read n
echo "Enter PID of all processes(Space Separated)"
read -a pid
echo "Enter burst time of all processes(Space Separated)"
read -a burst
echo "Enter arrival time of all processes(Space Separated)"
read -a arrive
echo "Enter priority of all processes, 0 being highest(Space Separated)"
read -a priority

#finding order of processes

function highestPriority(){
	i=-1
	min=999
	currtime=$1
	for((x=0;x<n;x++))
	do
		if [ $min -gt ${priority[$x]} ] && [ ${arrive[$x]} -le $currtime ]
		then
			i=$x
			min=${priority[$i]}
		fi
	done
	return $i
}

time=0
done=0
#burstcopy=("${burst[@]}") #created a copy of burst array
#calculations
while [ $done -ne $n ]
do
	highestPriority $time 			#calling function to get the highest priority job
	next="$?" 				#next has index of the highest priority job
	start[$next]=$time
	wait[$next]=`expr ${start[$next]} - ${arrive[$next]}`

	echo -n "From T=$time to "	

	time=`expr ${burst[$next]} + $time`		#current time after completing shortest job
	finish[$next]=$time		

	echo "$time : Process ${pid[$next]}"
	ta[$next]=`expr ${finish[$next]} - ${arrive[$next]}`
	priority[$next]=1000		
	((done++))
done

echo -e "PID\tBurst\tArrive\tStart\tFinish\tWait\tTA"

for((i=0;i<n;i++))
do
	echo -e "${pid[$i]}\t${burst[$i]}\t${arrive[$i]}\t${start[$i]}\t${finish[$i]}\t${wait[$i]}\t${ta[$i]}"
	sumwait=`expr $sumwait + ${wait[$i]}`
	sumta=`expr $sumta + ${ta[$i]}`
done
avgw=$(echo "$sumwait/$n" | bc -l)
avgta=$(echo "$sumta/$n" | bc -l)
echo "Average Wait Time: $avgw"
echo "Average TA Time: $avgta"
