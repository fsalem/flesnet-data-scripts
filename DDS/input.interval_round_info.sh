#!/bin/bash

source "common.sh"

FILE_NAME="../../${array[0]}/${array[1]}.input.interval_round_info.out"

LABEL="set xlabel 'Round index'; set ylabel 'count'; set xtics 0,1; set xrange [0:1000]; set title"
CMD_F1="$LABEL 'Blocking causes interval ${array[2]} in input node#${array[1]} in ${array[0]} [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "

CMD_F1="$CMD_F1'$FILE_NAME' using (\$1 == ${array[2]} ? \$2 : 1/0): (\$7 > 0 && \$7 < 600 ? \$7 : 1/0) with points title 'IB Problem', "
#CMD_F1="$CMD_F1'$FILE_NAME' using (\$1 == ${array[2]} ? \$2 : 1/0): (\$8 > 0 && \$8 < 600 ? \$8 : 1/0) with points title 'CB Problem' "
#CMD_F1="$CMD_F1'$FILE_NAME' using (\$1 == ${array[2]} ? \$2 : 1/0): (\$9 > 0 && \$9 < 600 ? \$9 : 1/0) with points title 'ACK Problem' "
#echo "CMD_F1=$CMD_F1"
CMD_F1="$CMD_F1'$FILE_NAME' using 2:9 with points title 'IB Problem' "
gnuplot -e "$CMD_F1; pause -1"

