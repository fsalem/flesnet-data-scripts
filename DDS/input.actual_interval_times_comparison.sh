#!/bin/bash

source "common.sh"

FILE_NAME="$1/0.input.proposed_actual_interval_info.out"

LABEL="set xlabel 'Interval index'; set ylabel 'Duration in ms'; set ytics 0,50; set title" #set xtics 0,1;
CMD_F1="$LABEL 'Actual starting times for intervals of all input nodes in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

INPUT_FILES=$2
echo "INPUT_FILES=INPUT_FILES"

COUNTER=0
while [  $COUNTER -lt $INPUT_FILES ]; do
	if [ $COUNTER -gt 0 ]
	then
	    CMD_F1="$CMD_F1, "
	fi
	FILE_NAME="$1/$COUNTER.input.proposed_actual_interval_info.out"
	CMD_F1="$CMD_F1'$FILE_NAME' using 1:3 with linespoints title 'IN#$COUNTER' "
    let COUNTER=COUNTER+1
done

#CMD_F1="$CMD_F1'$FILE_NAME' using 1:2 with linespoints title 'Proposed time', "

#CMD_F1="$CMD_F1'$FILE_NAME' using 1:3 with linespoints title 'Actual time' "

#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"
