#!/bin/bash

source "common.sh"

FILE_NAME="${array[0]}/${array[1]}.input.proposed_actual_interval_info.out"

LABEL="set xlabel 'Interval index'; set ylabel 'Duration in m=ms'; set xtics 0,1; set title"
CMD_F1="$LABEL 'Proposed vs Actual durations for intervals of Input node#${array[1]} in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:4 with linespoints title 'Proposed duration', "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:5 with linespoints title 'Actual duration' "

#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"
