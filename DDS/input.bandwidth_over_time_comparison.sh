#!/bin/bash

source "common.sh"

ORIGINAL_FILE_NAME1="${array[0]}/${array[1]}.input.out"
FILE_NAME1="${array[0]}/${array[1]}.input.out.bw"
#rm $FILE_NAME1
COUNT="0"
if [ ! -f $FILE_NAME1 ]; then
    echo "Time		Bandwidth" > $FILE_NAME1
    grep "[A-Za-z ]B/s (" $ORIGINAL_FILE_NAME1 | while read -r line ; do
        #echo "Processing $line"
        IFS=' ' read -r -a arr <<< "$line"
        ARRAY_COUNT=${#arr[@]}
        CUR_BAND=${arr[ARRAY_COUNT-4]}
	#echo "COUNT=$COUNT, CUR_BAND=$CUR_BAND"
	echo "$COUNT		$CUR_BAND" >> $FILE_NAME1
        COUNT=$((COUNT+1))
done
fi


ORIGINAL_FILE_NAME2="${array[2]}/${array[3]}.input.out"
FILE_NAME2="${array[2]}/${array[3]}.input.out.bw"
#rm $FILE_NAME2
COUNT="0"
if [ ! -f $FILE_NAME2 ]; then
    echo "Time          Bandwidth" > $FILE_NAME2
    grep "[A-Za-z ]B/s (" $ORIGINAL_FILE_NAME2 | while read -r line ; do
        #echo "Processing $line"
        IFS=' ' read -r -a arr <<< "$line"
        ARRAY_COUNT=${#arr[@]}
        CUR_BAND=${arr[ARRAY_COUNT-4]}
        #echo "COUNT=$COUNT, CUR_BAND=$CUR_BAND"
        echo "$COUNT            $CUR_BAND" >> $FILE_NAME2
        COUNT=$((COUNT+1))
done
fi


LABEL="set xlabel 'Time in Seconds'; set ylabel 'Bandwidth'; set title"
CMD_F1="$LABEL 'Bandwidth overtime comparison [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s]'; plot "
CMD_F1="$CMD_F1'$FILE_NAME1' using 1:2 with linespoints title 'FLESnet', '$FILE_NAME2' using 1:2 with linespoints title 'DFS'  "
gnuplot -e "$CMD_F1; pause -1"

