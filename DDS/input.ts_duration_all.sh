#!/bin/bash

source "common.sh"

LABEL="set xlabel 'Timeslice'; set ylabel 'Duration in ms'; set title"
CMD_F1="$LABEL 'Taken duration to send and receive the completion event after writing a timeslice in input nodes in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

COUNTER=0
echo "[1] = ${array[1]}"
while [  $COUNTER -lt ${array[1]} ]; do
	if [ $COUNTER -gt "0" ]; then
                CMD_F1="$CMD_F1, "
        fi
	FILE_NAME="${array[0]}/$COUNTER.input.ts_info.out"
	#FILE_NAME="${array[0]}/$COUNTER.input.ts_duration.out"

	if [ ${#array[@]} -eq "2" ]; then
		CMD_F1="$CMD_F1'$FILE_NAME' using 1:(\$3/1000.0) with points title 'I$COUNTER' "
	else
		CMD_F1="$CMD_F1'$FILE_NAME' using (\$2 == ${array[2]}?\$1:1/0):(\$3/1000.0) with points title 'I$COUNTER-${array[2]}' "
	fi
	COUNTER=$((COUNTER+1))
done
#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"

