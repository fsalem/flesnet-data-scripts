#!/bin/bash

source "common.sh"

FILE_NAME="$1/$2.compute.min_max_interval_info.out"

LABEL="set xlabel 'Interval index'; set ylabel 'Duration in ms'; set y2tics; set y2label '# of rounds'; set title" #set xtics 0,1; 
CMD_F1="$LABEL 'Proposed vs Enhanced durations and # of rounds for intervals of Compute node#$2 in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:6 with linespoints title 'Proposed duration', "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:7 with linespoints title 'Enhanced duration', "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:5 with linespoints title 'Actual MAX duration', "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:9 with linespoints axes x1y2 title 'Rounds' "

#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"
