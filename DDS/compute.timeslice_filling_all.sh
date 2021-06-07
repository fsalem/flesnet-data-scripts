#!/bin/bash

source "common.sh"

echo "[0]=$1"
LABEL="set xlabel 'Second'; set ylabel 'Percentage'; set ytics 0,10; set yrange [0:100]; set title"
CMD_F1="$LABEL 'The percentage of the used buffer space for each connection of all Compute nodes in ${JOB_NAME} [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "


COUNTER=0
while [  $COUNTER -lt $2 ]; do
	FILE_NAME="$1/$COUNTER.compute.timeslice_filling.out"
	if [ -f "$FILE_NAME" ]; then
		echo "FILE=$FILE_NAME"
		N=$(awk 'NR==1{print NF}' $FILE_NAME)
		CMD_F1="$CMD_F1 for [i=2:$N] '$FILE_NAME' u 0:i w l title 'C$COUNTER-'.(i-2),"
	fi
	COUNTER=$((COUNTER+1))
done
#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"
