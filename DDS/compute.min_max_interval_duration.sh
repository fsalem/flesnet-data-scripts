#!/bin/bash

source "common.sh"

echo "[0]=${array[0]}"
FILE_NAME="${array[0]}/${array[1]}.compute.min_max_interval_info.out"

LABEL="set xlabel 'Interval index'; set ylabel 'Time in ms'; set title" #set xtics 0,50; 
CMD_F1="$LABEL 'Difference between min and max duration of intervals of Compute node#${array[1]} in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:((\$4+\$5)/2):4:5 with yerrorbars title 'different times' " #(\$5-\$4)
#CMD_F1="$CMD_F1'$FILE_NAME' using 1:(\$6/1000):4:5 with yerrorbars title 'different times' " #(\$5-\$4)
#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"
