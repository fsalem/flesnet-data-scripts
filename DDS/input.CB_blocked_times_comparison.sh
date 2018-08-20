#!/bin/bash

source "common.sh"

FILE_NAME="${array[0]}/${array[1]}.input.scheduler_blocked_times.out"

LABEL="set xlabel 'Interval index'; set ylabel 'blocked Duration in ms'; set xtics 0,1; set title"
CMD_F1="$LABEL 'CB Block duration of all input nodes in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

INPUT_FILES=${array[1]}
echo "INPUT_FILES=INPUT_FILES"

COUNTER=0
while [  $COUNTER -lt $INPUT_FILES ]; do
	if [ $COUNTER -gt 0 ]
	then
	    CMD_F1="$CMD_F1, "
	fi
	FILE_NAME="${array[0]}/$COUNTER.input.scheduler_blocked_times.out"
	CMD_F1="$CMD_F1'$FILE_NAME' using 1:(\$4 == 0?1/0:\$4) with points title 'duration $COUNTER' "
    let COUNTER=COUNTER+1
done

#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"
