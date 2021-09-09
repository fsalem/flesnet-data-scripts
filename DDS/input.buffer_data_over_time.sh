#!/bin/bash

source "common.sh"

FILE_NAME="${array[0]}/${array[1]}.input.buffer_fill_level_summary.out"

LABEL="set tics font 'Helvetica,15'; set xlabel 'Time elapsed (s)' font 'Helvetica,20'; set ylabel 'Data (MB/s)' font 'Helvetica,20'; set yrange [0:5000]; set title"
CMD_F1="$LABEL 'Buffer Added, Sent, lost data overtime in input node#${array[1]} in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s]'; plot "
#CMD_F1="$CMD_F1'$FILE_NAME' using 1:(\$2/1000000) with linespoints title 'Lost', '$FILE_NAME' using 1:4 with linespoints title 'Added', '$FILE_NAME' using 1:6 with linespoints title 'Sent', '$FILE_NAME' using 1:((\$2/1000000)+(\$3/1000000)) with linespoints title 'Incoming' "
CMD_F1="$CMD_F1'$FILE_NAME' using 1:4 with linespoints title 'Added', '$FILE_NAME' using 1:6 with linespoints title 'Sent' "
gnuplot -e "$CMD_F1; pause -1"

