#!/bin/bash

source "common.sh"

echo "[0]=${array[0]}"
FILE_NAME="${array[0]}/${array[1]}.compute.interval_load_info.${array[2]}.out"

LABEL="set xlabel 'Interval index'; set ylabel 'Duration in ms';set y2tics; set y2label 'Percentage'; set title" #set xtics 0,50; 
CMD_F1="$LABEL 'Load balancing Stats of ${array[1]} on Compute node#${array[1]} in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:6:3:5 with yerrorbars title 'different times', "
CMD_F1="$CMD_F1'$FILE_NAME' using 1:7 with linespoints title 'Variance%' axes x1y2, "
CMD_F1="$CMD_F1'$FILE_NAME' using 1:8 with linespoints title 'Load to distribute' axes x1y2 "
#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"
