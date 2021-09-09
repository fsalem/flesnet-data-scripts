#!/bin/bash

source "common.sh"

LOG_KEY="compute.arrival_diff.out"
#LOG_KEY="compute.timeslice_completion.out"
# Input is number of compute nodes in space seperated
FILE_NAME="${array[0]}/$LOG_KEY"
LABEL=" set xlabel 'Timeslice no.' font 'Helvetica,35' offset 0,-5,0; 
	set ylabel 'waiting time(ms)' font 'Helvetica,35' offset -8,0,0;
	set xtics format '%0.s%c';
	set ytics format '%0.s%c';
	set lmargin 18;"
	#set terminal pdf enhanced size 31cm,21cm; 
	#set output 'different_arr_comp_times.pdf';
	set yrange [0:]; 
	#set xrange [0:101000]; 
	#set tics font 'Helvetica,35'; 
	#set key font 'Helvetica,35';
	set ytics autofreq 50;
	#set xtics offset 0,-2,0;
	#set ytics offset -1,0,0;
	
	#set bmargin 10;
	#set lmargin 18;
	#set rmargin 7;"
CMD="$LABEL set title 'Diff between first and last contribution arrival of each timeslice in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

if [ ! -f $FILE_NAME ]; then
	IFS=' ' read -r -a array <<< "$@"
	COMPUTE_FILES=${array[1]}
	echo "COMPUTE_FILES=$COMPUTE_FILES"
	TOTAL_ROW_COUNT=0

	ROW_COUNT=$(cat "${array[0]}/0.$LOG_KEY" | wc -l)
	echo "ROW_COUNT=$ROW_COUNT"
	COUNTER=0
	while [  $COUNTER -lt $COMPUTE_FILES ]; do
		CUR_FILE="${array[0]}/$COUNTER.compute.arrival_diff.out"
		cat "$CUR_FILE" >> "$FILE_NAME"
    		let COUNTER=COUNTER+1
	done
fi
CMD="$CMD '$FILE_NAME' using 1:(\$2/1000) with points title 'Difference' "

TOTAL_ROW_COUNT=$((COMPUTE_FILES*ROW_COUNT))


#echo "CMD=$CMD"
gnuplot -e "$CMD;pause -1"
