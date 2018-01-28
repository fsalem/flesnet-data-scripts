#!/bin/bash

source "common.sh"

FILE_NAME="${array[0]}/${array[1]}.compute.mean_variance_interval.out"

LABEL="set xlabel 'Interval index'; set ylabel 'Mean in ms'; set xtics 0,10; set ytics 0,5; set title"
CMD_F1="$LABEL 'Mean of last 10 intervals of Compute node#${array[1]} in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:(\$2/1000) with linespoints title 'Std. Dev.' "
#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"
