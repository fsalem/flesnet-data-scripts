#!/bin/bash

source "common.sh"

median() {
  arr=($(printf '%d\n' "${@}" | sort -n | bc))
  nel=${#arr[@]}
  if (( $nel % 2 == 1 )); then     # Odd number of elements
    val="${arr[ $(($nel/2)) ]}"
  else                            # Even number of elements
    (( j=nel/2 ))
    (( k=j-1 ))
    (( val=(${arr[j]} + ${arr[k]})/2 ))
  fi
  echo $val
}

avg_aggregator() {
	FOLDER=$1
	COMPUTE_COUNT=$2
	AGG_FILE_NAME="$1/compute.arrival_diff.out.agg"
#	#echo "Timeslice		Dur		CN" > $AGG_FILE_NAME
#	echo "" > $AGG_FILE_NAME
#	I=0
#	while [ "$I" -lt "$COMPUTE_COUNT" ]; do
#		while read -r line; do
#			if [ "$line" != "Timeslice                     Diff" ]; then
#				echo "$line			$I" >> $AGG_FILE_NAME
#			fi
#		done < "$1/$I.compute.arrival_diff.out"
#		I=$((I+1))
#	done
	SORTED_FILE_NAME="$1/compute.arrival_diff.out.agg.sorted"
#	grep "\S" $AGG_FILE_NAME | sort -k1 -k2 -k3 -n  > $SORTED_FILE_NAME
	LINES_COUNT=$(wc -l $SORTED_FILE_NAME | awk '{ print $1 }')
	#echo "LINES=$LINES_COUNT"
	STAT_FILE_NAME="$1/compute.arrival_diff.out.agg.stat"
	echo "Timeslice			Min			Max			AVG			MEDIAN			10th			90th" > $STAT_FILE_NAME
	I=0
	MIN=0
	MAX=0
	SUM=0
	MED=0
	TENTH_PER=0
	NINTH_PER=0
	TIME=0
	MIDDLE=$((INPUT_COUNT/2))
	TENTH=$(( INPUT_COUNT/10 ))
	NINTH=$(( INPUT_COUNT*9/10 ))
	COUNT=0
	while read -r -a line; do
		LATENCY=$(printf "%0.2f" ${line[1]})
		LATENCY=${LATENCY%.*}
		if [ "$TIME" -ne "${line[0]}" ]; then
			if [ "$COUNT" -lt "$TENTH" ]; then
				TENTH_PER=$MIN
			fi
			if [ "$COUNT" -lt "$NINTH" ]; then
				NINTH_PER=$MAX
			fi
			if [ "$I" -ne "0" ]; then
				AVG=$((SUM/COUNT))
				echo "$TIME				$MIN			$MAX			$AVG			$MED			$TENTH_PER			$NINTH_PER" >> $STAT_FILE_NAME
				echo "$I		${line[0]}				$TIME		$MIN		$MAX		$AVG		$MED		$TENTH_PER		$NINTH_PER"
			fi
			MIN=$LATENCY
			MAX=$LATENCY
			SUM=$LATENCY
			TIME=${line[0]}
			MED=$LATENCY
			TENTH_PER=$LATENCY
			NINTH_PER=$LATENCY
			COUNT=1
		else
		 	
			SUM=$(($SUM + $LATENCY))
			if [ "$COUNT" -eq "$TENTH" ]; then
				TENTH_PER=$LATENCY
			fi
			if [ "$COUNT" -eq "$NINTH" ]; then
				NINTH_PER=$LATENCY
			fi
			if [ "$COUNT" -eq "$MIDDLE" ]; then
				MED=$LATENCY
			fi
			if [ "$LATENCY" -lt "$MIN" ]; then
				MIN=$LATENCY
			fi
			if [ "$LATENCY" -gt "$MAX" ]; then
				MAX=$LATENCY
			fi
			COUNT=$((COUNT+1))
			
		fi
		I=$((I+1))
		if [ "$I" -eq "$LINES_COUNT" ]; then
			AVG=$((SUM/COUNT))
			echo "$TIME			$MIN			$MAX			$AVG			$MED			$TENTH_PER			$NINTH_PER" >> $STAT_FILE_NAME
			#echo "$TIME		$MIN		$MAX		$AVG		$MED		$TENTH_PER		$NINTH_PER"
		fi
	done < $SORTED_FILE_NAME
	LINES_COUNT=$(wc -l $STAT_FILE_NAME | awk '{ print $1 }')
	echo "$STAT_FILE_NAME LINES=$LINES_COUNT"
	#rm $SORTED_FILE_NAME
}

avg_aggregator ${array[0]} ${array[1]}
#avg_aggregator ${array[2]} ${array[3]}

AVG_FILE_NAME1="${array[0]}/compute.arrival_diff.out.agg.stat"
AVG_FILE_NAME2="${array[2]}/compute.arrival_diff.out.agg.stat"


CMD="set xlabel ''; set ylabel 'Latency (ms)';
set errorbars 4.0;
set grid ytics mytics;
set style data histogram;
set style histogram cluster;
set style fill solid border -1;
set yrange[-1000:];
set multiplot layout 2,1;
plot '$AVG_FILE_NAME1' using (\$1%100== 0?\$1:1/0):6:2:3:7 with candlesticks ls 6 title 'With Failure' whiskerbars, \
     ''         using (\$1%100== 0?\$1:1/0):5:5:5:5 with candlesticks ls 6 lt -1 notitle;
set xlabel 'Timeslice';    
plot '$AVG_FILE_NAME2' using (\$1%100== 0?\$1:1/0):6:2:3:7 with candlesticks ls 7 title 'W/o Failure' whiskerbars, \
     ''         using (\$1%100== 0?\$1:1/0):5:5:5:5 with candlesticks ls 7 lt -1 notitle;
unset multiplot;"

     
gnuplot -e "$CMD; pause -1"

