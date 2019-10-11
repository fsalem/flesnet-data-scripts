#!/bin/bash

source "common.sh"

# Input is number of compute nodes in space seperated
FILE_NAME1="${array[0]}/input.ts_info.out"
rm $FILE_NAME1
FILE_NAME2="${array[2]}/input.ts_info.out"
rm $FILE_NAME2
LABEL=" set xlabel 'Timeslice no.' font 'Helvetica,20' offset 0,-5,0; 
	set ylabel 'Latency(ms)' font 'Helvetica,20' offset -8,0,0;
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
#CMD="$LABEL set title 'Diff between first and last contribution arrival of each timeslice in 32 and 64 nodes'; plot "
CMD="$LABEL; plot "

IFS=' ' read -r -a array <<< "$@"
INPUT_FILES=${array[1]}

FILE_EXT1="input.ts_info.out"
CUR_FILE="${array[0]}/0.$FILE_EXT1"
echo "FILE_EXT1=$FILE_EXT1, CUR_FILE=$CUR_FILE"
if [ ! -f $CUR_FILE ]; then
   FILE_EXT1="input.ts_duration.out"
fi

FILE_EXT2="input.ts_info.out"
CUR_FILE="${array[2]}/0.$FILE_EXT2"
if [ ! -f $CUR_FILE ]; then
   FILE_EXT2="input.ts_duration.out"
fi

ROW_COUNT=$(cat "${array[0]}/0.$FILE_EXT1" | wc -l)

#echo "ROW_COUNT=$ROW_COUNT"
COUNTER=0
while [  $COUNTER -lt $INPUT_FILES ]; do
	CUR_FILE="${array[0]}/$COUNTER.$FILE_EXT1"
	cat "$CUR_FILE" >> "$FILE_NAME1"
	CUR_FILE="${array[2]}/$COUNTER.$FILE_EXT2"
	cat "$CUR_FILE" >> "$FILE_NAME2"
    let COUNTER=COUNTER+1
done

JOB_NAME2=`basename "${array[2]}"`

CMD="$CMD '$FILE_NAME1' using ((\$1-floor(\$1/2000)*2000) == 0?\$1:1/0):(\$3/1000.0) with points title 'With DFS', '$FILE_NAME2' using ((\$1-floor(\$1/2000)*2000) == 0?\$1:1/0):(\$3/1000.0) with points title 'Without DFS' "


#echo "CMD=$CMD"
gnuplot -e "$CMD;pause -1"
