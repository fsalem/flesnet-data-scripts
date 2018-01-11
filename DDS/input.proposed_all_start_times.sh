#!/bin/bash

source "common.sh"

FILE_NAME="../../${array[0]}/${array[1]}.input.proposed_all_start_times.out"

LABEL="set xlabel 'Interval index'; set ylabel 'Duration in ms'; set xtics 0,1; set title"
CMD_F1="$LABEL 'Proposed starting times for intervals of Input node#${array[1]} in ${array[0]} [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

COLUMN_COUNT=$(awk '{print NF}' $FILE_NAME | sort -nu | tail -n 1)

for i in `seq 2 $COLUMN_COUNT`;
do
	if [ "$i" -ne "2" ]; then
		CMD_F1="$CMD_F1,"	
	fi
	CMD_F1="$CMD_F1'$FILE_NAME' using 1:(\$$i == -1?1/0:\$$i) with points title 'Compute#$((i-1))' "
done

#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"
