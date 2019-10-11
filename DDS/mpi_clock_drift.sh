#!/bin/bash

source "common.sh"

FILE_NAME="$1"
COLUMNS=$2

LABEL="set xlabel 'Timestamp'; set ylabel 'Ranks'; set xtics 0,10000; set title" 
CMD_F1="$LABEL 'Clock Drifts'; plot "

	
COUNTER=0
while [  $COUNTER -lt $COLUMNS ]; do
    if [ $COUNTER -gt "0" ]; then
	CMD_F1="$CMD_F1, "
    fi
    COL=$((COUNTER+2))
    CMD_F1="$CMD_F1 '$FILE_NAME' using $COL:yticlabel(1) with linespoints title 't$COUNTER' "
    COUNTER=$((COUNTER+1))
done

#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"
