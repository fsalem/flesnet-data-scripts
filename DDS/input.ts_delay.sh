#!/bin/bash

source "common.sh"

FILE_NAME="$1/$2.input.ts_info.out"

LABEL="set xlabel 'Timeslice'; set ylabel 'Delay in ms'; set xtics 0,500000; set title" 
CMD_F1="$LABEL 'The delay of writing timeslices in Input node#$2 in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:(\$4/1000.0) with points title 'Delay' "

#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"
