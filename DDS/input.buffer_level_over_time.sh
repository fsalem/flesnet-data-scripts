#!/bin/bash

source "common.sh"

FILE_NAME="${array[0]}/${array[1]}.input.buffer_fill_level.out"

LABEL="set tics font 'Helvetica,15'; set xlabel 'Time elapsed' font 'Helvetica,20'; set ylabel 'Fill Level' font 'Helvetica,20'; set ytics 0,10; set yrange [0:100]; set title"
CMD_F1="$LABEL 'Buffer Fill-Level overtime in input node#${array[1]} in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "
CMD_F1="$CMD_F1'$FILE_NAME' using 1:2 with linespoints title 'Fill-Level \%' "
gnuplot -e "$CMD_F1; pause -1"

