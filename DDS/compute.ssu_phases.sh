#!/bin/bash

source "common.sh"

echo "[0]=${array[0]}"
FILE_NAME="${array[0]}/${array[1]}.compute.ssu_phases.out"

LABEL="set xlabel 'Interval index'; set ylabel 'Duration s'; set y2tics; set y2label 'Percentage';set title" #set xtics 0,50; 
CMD_F1="$LABEL 'Comparison between proposed duration and current variance node#${array[1]} in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

CMD_F1="$CMD_F1'$FILE_NAME' using 1:(\$2/1000) with linespoints title 'Duration', "
#CMD_F1="$CMD_F1'$FILE_NAME' using 1:(\$3/1000) with linespoints title 'Variance', "
CMD_F1="$CMD_F1'$FILE_NAME' using 1:4 with linespoints title 'Percentage' axes x1y2 "
#CMD_F1="$CMD_F1'$FILE_NAME' using 1:(\$5 == 'SPEEDUP') with linespoints title 'Phase' axes x1y2 "
#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"
