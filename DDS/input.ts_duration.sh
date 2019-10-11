#!/bin/bash

source "common.sh"

FILE_NAME="${array[0]}/${array[1]}.input.ts_info.out"
if [ ! -f $FILE_NAME ]; then
	FILE_NAME="${array[0]}/${array[1]}.input.ts_duration.out"
fi

LABEL="set xlabel 'Timeslice'; set ylabel 'Duration in ms'; set title"
CMD_F1="$LABEL 'Taken duration to send and receive the completion event after writing a timeslice in input node#${array[1]} in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "
if [ ${#array[@]} -eq "2" ]; then
	CMD_F1="$CMD_F1'$FILE_NAME' using 1:(\$3/1000.0) with points title 'TS duration' "
else
	COUNTER=0
	while [  $COUNTER -lt ${array[2]} ]; do
		#if [ $COUNTER -gt "0" ]; then
                	#CMD_F1="$CMD_F1, "
        	#fi
		#CMD_F1="$CMD_F1'$FILE_NAME' using (\$2 == $COUNTER?\$1:1/0):(\$3/1000.0) with points title 'C$COUNTER' "
		COUNTER=$((COUNTER+1))
	done
	CMD_F1="$CMD_F1'$FILE_NAME' using (\$2 == ${array[2]}?\$1:1/0):(\$3/1000.0) with points title 'C${array[2]}' "
fi
#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"

