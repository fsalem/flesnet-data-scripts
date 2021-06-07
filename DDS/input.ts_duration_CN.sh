#!/bin/bash

source "common.sh"

FILE_NAME="${array[0]}/${array[1]}.input.ts_info.out"

LABEL="set xlabel 'Compute Node'; set ylabel 'Duration in ms'; set ytics 0,30; set title"
CMD_F1="$LABEL 'Taken duration to send and receive the completion event after writing a timeslice in input node#${array[1]} in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "
if [ ${#array[@]} -eq "2" ]; then
	CMD_F1="$CMD_F1'$FILE_NAME' using 2:(\$3/1000.0) with points title 'TS duration' "
else
	CMD_F1="$CMD_F1'$FILE_NAME' using (\$2 == ${array[2]}?\$1:1/0):(\$3/1000.0) with points title 'TS duration of compute node ${array[2]}' "
fi
#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"

