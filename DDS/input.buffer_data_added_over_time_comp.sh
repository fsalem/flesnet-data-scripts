#!/bin/bash

source "common.sh"

FILE_NAME1="${array[0]}/${array[1]}.input.buffer_fill_level_summary.out"
FILE_NAME2="${array[2]}/${array[3]}.input.buffer_fill_level_summary.out"

LABEL="set tics font 'Helvetica,15'; set xlabel 'Time elapsed (s)' font 'Helvetica,20'; set ylabel 'Bytes Added (GB)' font 'Helvetica,20'; set yrange [0:]; set title"
CMD_F1="$LABEL 'Buffer Data Added' font 'Helvetica,15'; plot "
CMD_F1="$CMD_F1'$FILE_NAME1' using (\$1/1000):(\$3/1024/1024/1024) with linespoints title 'FLESnet',  '$FILE_NAME2' using (\$1/1000):(\$3/1024/1024/1024) with linespoints title 'DFS'"
gnuplot -e "$CMD_F1; pause -1"

