#!/bin/bash

source "common.sh"

FILE_NAME="${array[0]}/${array[1]}.input.scheduler_blocked_times.out"

LABEL="set xlabel 'Interval index'; set ylabel 'blocked Duration in ms'; set xtics 0,1; set title"
CMD_F1="$LABEL 'IB and CB Block duration of Input node#${array[1]} in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:(\$3 == 0?1/0:\$3) with points title 'IB blocked duration', "
CMD_F1="$CMD_F1'$FILE_NAME' using 1:(\$4 == 0?1/0:\$4) with points title 'CB blocked duration', "
#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"
