#!/bin/bash

source "common.sh"

FILE_NAME="../../${array[0]}/${array[1]}.compute.min_max_interval_info.out"

LABEL="set xlabel 'Interval index'; set ylabel 'Time in ms'; set xtics 0,1; set title"
CMD_F1="$LABEL 'Difference between min and max duration of intervals of Compute node#${array[1]} in ${array[0]} [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:4:(\$5-\$4) with yerrorbars title 'different times' "
#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"