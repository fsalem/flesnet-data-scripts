#!/bin/bash

source "common.sh"

#echo "[0]=$1"
FILE_NAME="$1/$2.compute.buffer_status.out"
echo "FILE: $FILE_NAME"

LABEL="set xlabel 'Second'; set ylabel 'Percentage'; set ytics 0,10; set title"  
CMD_F1="$LABEL 'The percentage of the used buffer space for each connection of Compute node#$2 in ${JOB_NAME} [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

#echo "FILE=$FILE_NAME"
N=$(awk 'NR==1{print NF}' $FILE_NAME)
CMD_F1="$CMD_F1 for [i=2:$N] '$FILE_NAME' u 0:i w l title 'I'.(i-2)"
#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"
