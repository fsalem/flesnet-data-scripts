#!/bin/bash

source "common.sh"

# Input is number of compute nodes in space seperated
FILE_NAME1="${array[0]}/compute.arrival_diff.out"
rm $FILE_NAME1
FILE_NAME2="${array[2]}/compute.arrival_diff.out"
rm $FILE_NAME2
LABEL=" set xlabel 'Timeslice no.' font 'Helvetica,20' offset 0,-5,0; 
	set ylabel 'waiting time(ms)' font 'Helvetica,20' offset -8,0,0;
	set xtics format '%0.s%c';" 
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
CMD="$LABEL set title 'Diff between first and last contribution arrival of each timeslice in 32 and 64 nodes'; plot "

IFS=' ' read -r -a array <<< "$@"
COMPUTE_FILES=${array[1]}
#echo "COMPUTE_FILES=$COMPUTE_FILES"

ROW_COUNT=$(cat "${array[0]}/0.compute.arrival_diff.out" | wc -l)
#echo "ROW_COUNT=$ROW_COUNT"
COUNTER=0
while [  $COUNTER -lt $COMPUTE_FILES ]; do
	CUR_FILE="${array[0]}/$COUNTER.compute.arrival_diff.out"
	cat "$CUR_FILE" >> "$FILE_NAME1"
	CUR_FILE="${array[2]}/$COUNTER.compute.arrival_diff.out"
	cat "$CUR_FILE" >> "$FILE_NAME2"
    let COUNTER=COUNTER+1
done

JOB_NAME2=`basename "${array[2]}"`

CMD="$CMD '$FILE_NAME1' using 1:(\$2/1000) with points title 'Difference in 32 nodes', '$FILE_NAME2' using 1:(\$2/1000) with points title 'Difference in 64 nodes' "


#echo "CMD=$CMD"
gnuplot -e "$CMD;pause -1"
