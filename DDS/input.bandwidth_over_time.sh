#!/bin/bash

source "common.sh"

ORIGINAL_FILE_NAME="${array[0]}/${array[1]}.input.out"
FILE_NAME="${array[0]}/${array[1]}.input.out.bw"
rm $FILE_NAME
COUNT="0"
if [ ! -f $FILE_NAME ]; then
    echo "Time		Bandwidth" > $FILE_NAME
    grep "[A-Za-z ]${array[2]}B/s (" $ORIGINAL_FILE_NAME | while read -r line ; do
        #echo "Processing $line"
        IFS=' ' read -r -a array <<< "$line"
        ARRAY_COUNT=${#array[@]}
        CUR_BAND=${array[ARRAY_COUNT-4]}
	#echo "COUNT=$COUNT, CUR_BAND=$CUR_BAND"
	echo "$COUNT		$CUR_BAND" >> $FILE_NAME
        COUNT=$((COUNT+1))
done
fi

LABEL="set tics font 'Helvetica,15';  set xlabel 'Time in Seconds' font 'Helvetica,20'; set ylabel 'Bandwidth (MB/s)' font 'Helvetica,20'; set ytics 1000; set title"
CMD_F1="$LABEL 'Bandwidth overtime in input node#${array[1]} in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "
CMD_F1="$CMD_F1'$FILE_NAME' using 1:2 with linespoints title 'Bandwidth' "
gnuplot -e "$CMD_F1; pause -1"

