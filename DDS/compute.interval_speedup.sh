#!/bin/bash

source "common.sh"

FILE_NAME="${array[0]}/${array[1]}.compute.min_max_interval_info.out"

LABEL="set xlabel 'Interval index'; set ylabel 'Speedup factor'; set title" #set yrange [0:1];
CMD_F1="$LABEL 'Intervals Speedup factors of Compute node#${array[1]} in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:(\$6*100) with points title 'Factor' "
#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"
