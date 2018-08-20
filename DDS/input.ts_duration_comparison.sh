#!/bin/bash

source "common.sh"

LABEL="set xlabel 'Timeslice'; set ylabel 'Duration in ms'; set title"
CMD_F1="$LABEL 'Taken duration to send and receive the completion event after writing a timeslice in ${JOB_NAME} [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

INPUT_FILES=${array[1]}
echo "INPUT_FILES=$INPUT_FILES"
COUNTER=0
while [  $COUNTER -lt $INPUT_FILES ]; do
    if [ $COUNTER -gt 0 ]
    then
	CMD_F1="$CMD_F1, "
    fi
    FILE_NAME="${array[0]}/$COUNTER.input.ts_duration.out"
    if [ ${#array[@]} -eq "2" ]; then
	CMD_F1="$CMD_F1'$FILE_NAME' using ((\$1-(floor(\$1/25)*25))==0?\$1:1/0):(\$3/1000.0) with points title 'I$COUNTER' "
    else
	CMD_F1="$CMD_F1'$FILE_NAME' using (\$2 == ${array[2]}?\$1:1/0):(\$3/1000.0) with points title 'I$COUNTER of C${array[2]}' "
    fi
    let COUNTER=COUNTER+1
done
#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"