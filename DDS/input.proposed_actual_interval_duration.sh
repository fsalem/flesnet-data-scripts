#!/bin/bash

source "common.sh"

FILE_NAME="$1/$2.input.proposed_actual_interval_info.out"
FILE_NAME2="$1/$2.compute.min_max_interval_info.out"

LABEL="set xlabel 'Interval index'; set ylabel 'Duration in ms'; set y2label 'Enhancement Factor'; set y2range [-3:2]; set y2tics -3,1; set title" #set xtics 0,1; 
CMD_F1="$LABEL 'Proposed vs Actual durations for intervals of Input node#$2 in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:4 with linespoints title 'Proposed duration', "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:5 with linespoints title 'Actual duration', "
    
CMD_F1="$CMD_F1'$FILE_NAME2' using 1:8 with linespoints title 'Factor' axes x1y2"

#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"
