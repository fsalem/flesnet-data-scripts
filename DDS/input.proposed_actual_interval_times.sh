#!/bin/bash

source "common.sh"

FILE_NAME="${array[0]}/${array[1]}.input.proposed_actual_interval_info.out"

LABEL="set xlabel 'Interval index'; set ylabel 'Duration in ms'; set xtics 0,1; set ytics 0,50; set title"
CMD_F1="$LABEL 'Proposed vs Actual starting times for intervals of Input node#${array[1]} in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:2 with linespoints title 'Proposed time', "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:3 with linespoints title 'Actual time' "

#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"
