#!/bin/bash

source "common.sh"

FILE_NAME="${array[0]}/${array[1]}.input.expected_actual_round_start_time.out"

LABEL="set xlabel 'Round Index'; set ylabel 'Difference in ms'; set title"
CMD_F1="$LABEL 'The difference between the proposed and the actual round start times in input node#${array[1]} in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:(\$4/1000.0) with points title 'Diff' "

#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"

