#!/bin/bash

source "common.sh"

FILE_NAME="$1/0.input.proposed_actual_interval_info.out"

LABEL="set xlabel 'Interval index'; set ylabel 'Duration in ms'; set y2label 'Enhancement Factor'; set y2range [-3:2]; set y2tics -3,1; set title" #set xtics 0,1; 
CMD_F1="$LABEL 'Actual durations for intervals of all input nodes in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

INPUT_FILES=$2
echo "INPUT_FILES=INPUT_FILES"

COUNTER=0
while [  $COUNTER -lt $INPUT_FILES ]; do
	if [ $COUNTER -gt 0 ]
	then
	    CMD_F1="$CMD_F1, "
	fi
	FILE_NAME="$1/$COUNTER.input.proposed_actual_interval_info.out"
	CMD_F1="$CMD_F1'$FILE_NAME' using 1:5 with linespoints title 'duration$COUNTER' "
    let COUNTER=COUNTER+1
done

#CMD_F1="$CMD_F1'$FILE_NAME' using 1:4 with linespoints title 'Proposed duration', "

#CMD_F1="$CMD_F1'$FILE_NAME' using 1:5 with linespoints title 'Actual duration' "

#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"
