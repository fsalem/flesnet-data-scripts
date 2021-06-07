#!/bin/bash

source "common.sh"

LOG_KEY="compute.timeslice_processing.out"
# Input is number of compute nodes in space seperated
FILE_NAME="${array[0]}/${array[1]}.$LOG_KEY"
LABEL=" set xlabel 'Interval #' font 'Helvetica,35' offset 0,-5,0; 
	set ylabel 'waiting time(ms)' font 'Helvetica,35' offset -8,0,0;
	set xtics format '%0.s%c';
	set lmargin 18;"
	#set terminal pdf enhanced size 31cm,21cm; 
	#set output 'different_arr_comp_times.pdf';
	#set yrange [4:]; 
	#set xrange [0:101000]; 
	#set tics font 'Helvetica,35'; 
	#set key font 'Helvetica,35';
	#set xtics autofreq 20000;
	#set xtics offset 0,-2,0;
	#set ytics offset -1,0,0;
	
	#set bmargin 10;
	#set lmargin 18;
	#set rmargin 7;"
CMD="$LABEL set title 'TS Prossing duration of CN#${array[1]} in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

CMD="$CMD '$FILE_NAME' using 1:(\$2/1000) with points title 'Duration' "

TOTAL_ROW_COUNT=$((COMPUTE_FILES*ROW_COUNT))


#echo "CMD=$CMD"
gnuplot -e "$CMD;pause -1"
