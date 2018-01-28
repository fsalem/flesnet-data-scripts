#!/bin/bash

source "common.sh"

FILE_NAME="${array[0]}/${array[1]}.input.proposed_actual_interval_info.out"
FILE_NAME2="${array[0]}/${array[1]}.compute.min_max_interval_info.out"

LABEL="set xlabel 'Interval index'; set ylabel 'Duration in ms'; set ytics 0,50; set y2label 'Enhancement Factor'; set y2range [-3:2]; set y2tics -3,1; set title" #set xtics 0,1; 
CMD_F1="$LABEL 'Proposed vs Actual durations for intervals of Input node#${array[1]} in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:4 with linespoints title 'Proposed duration', "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:5 with linespoints title 'Actual duration', "
    
CMD_F1="$CMD_F1'$FILE_NAME2' using 1:7 with linespoints title 'Factor' axes x1y2"

#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"
