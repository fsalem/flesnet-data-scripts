#!/bin/bash

source "common.sh"

echo "[0]=$1"
FILE_NAME="$1/$2.input.buffer_status.out"

LABEL="set xlabel 'Second'; set ylabel 'Percentage'; set ytics 0,10; set title"  
CMD_F1="$LABEL 'The percentage of the used buffer space of Input node#$2 in ${JOB_NAME} [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]';"

#CMD_F1="$CMD_F1 div=1.1; bw = 0.9; h=1.0; BW=0.9; wd=10; LIMIT=255-wd; white = 0;"
#CMD_F1="$CMD_F1 red = '#080000'; green = '#000800'; blue = '#000008'; yellow = '#FFFF00';"
#CMD_F1="$CMD_F1 set style data histogram;"
#CMD_F1="$CMD_F1 set style histogram rowstacked;"
#CMD_F1="$CMD_F1 set style fill solid;"
#CMD_F1="$CMD_F1 set boxwidth bw;"
#CMD_F1="$CMD_F1 set xrange [0:11];"
CMD_F1="$CMD_F1 plot "
#CMD_F1="$CMD_F1 "


echo "FILE=$FILE_NAME"
CMD_F1="$CMD_F1 '$FILE_NAME' u 0:(100-\$5) w l title '100-Unused';"
#CMD_F1="$CMD_F1 '$FILE_NAME' u 0:3 w l title 'Sending';"
#CMD_F1="$CMD_F1 '$FILE_NAME' u 2 title 'Used',"
#CMD_F1="$CMD_F1 '$FILE_NAME' u 3 title 'Sending',"
#CMD_F1="$CMD_F1 '$FILE_NAME' u 4 title 'Freeing',"
#CMD_F1="$CMD_F1 '$FILE_NAME' u 5 title 'Unused';"
#echo "CMD_F1=$CMD_F1"
gnuplot -e "$CMD_F1; pause -1"
