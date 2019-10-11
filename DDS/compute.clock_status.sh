#!/bin/bash

source "common.sh"

echo "[0]=$1"
FILE_NAME="$1/$2.compute.clock.out"

LABEL="set xlabel 'Interval'; set ylabel 'Offset [us]'; set ytics -1000,1000; set title"  
CMD_F1="$LABEL 'Offset changes between Input node#$3 and Compute node#$2 in ${JOB_NAME} [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

CMD_F1="$CMD_F1'$FILE_NAME' using (\$2 == $3?\$1:1/0):6 with points title 'Offset' "

gnuplot -e "$CMD_F1; pause -1"
