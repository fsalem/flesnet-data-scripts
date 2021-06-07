#!/bin/bash

source "common.sh"

FILE_NAME="${array[0]}/${array[1]}.compute.interval_load_info.out"
echo "[0]=$1"
LABEL="set xlabel 'Interval'; set ylabel 'Load'; set title"
CMD_F1="$LABEL 'The Load distribution on CNs in ${JOB_NAME} [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "


COUNTER=0
while [  $COUNTER -lt ${array[2]} ]; do
	if [ $COUNTER -gt "0" ]; then
                CMD_F1="$CMD_F1, "
        fi
	
	
	CMD_F1="$CMD_F1'$FILE_NAME' using 1:$((COUNTER+2)) with linespoints title 'Load of CN#COUNTER' "
	COUNTER=$((COUNTER+1))
done
#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"
