#!/bin/bash

source "common.sh"

FILE_NAME="${array[0]}/${array[1]}.input.overall_blocked_times.out"

RUNNING_TIME=$(awk 'NR==1{print $5/1000000.0}' $FILE_NAME)
#echo "RUNNING_TIME=$RUNNING_TIME"
LABEL="set ylabel 'Duration(ms)'; set ytics 0,100; set boxwidth 0.5; set style fill solid; set title"
CMD_F1="$LABEL 'Overall blocked duration of IB, CB, and scheduler of Input node#${array[1]} in $JOB_NAME (running time = $RUNNING_TIME s) [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:(\$3/1000.0):xtic(2) every ::1 with boxes title 'Blocked times'"
#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"
