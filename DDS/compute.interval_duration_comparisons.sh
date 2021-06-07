#!/bin/bash

source "common.sh"

FILE_NAME="${array[0]}/${array[1]}.compute.min_max_interval_info.out"
LABEL="set xlabel 'Interval index'; set ylabel 'Duration in ms'; set title" #set xtics 0,1; 
CMD_F1="$LABEL 'durations for intervals of Compute node#${array[1]} in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:(\$4/1000) with points title 'Min duration', "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:(\$5/1000) with points title 'Max duration', "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:(\$6/1000) with points title 'Proposed duration', "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:(\$7/1000) with points title 'Enhanced duration' "

#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"
