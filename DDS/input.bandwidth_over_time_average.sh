#!/bin/bash

source "common.sh"

median() {
  arr=($(printf '%d\n' "${@}" | sort -n | bc))
  nel=${#arr[@]}
  if (( $nel % 2 == 1 )); then     # Odd number of elements
    val="${arr[ $(($nel/2)) ]}"
  else                            # Even number of elements
    (( j=nel/2 ))
    (( k=j-1 ))
    (( val=(${arr[j]} + ${arr[k]})/2 ))
  fi
  echo $val
}


ORIGINAL_FILE_NAME="${array[0]}/${array[1]}.input.out"
FILE_NAME="${array[0]}/${array[1]}.input.out.bw.tmp"
rm $FILE_NAME
COUNT="0"
grep "[A-Za-z\. ]${array[2]}B/s (" $ORIGINAL_FILE_NAME | while read -r line ; do
    IFS=' ' read -r -a array <<< "$line"
    ARRAY_COUNT=${#array[@]}
    CUR_BAND=${array[ARRAY_COUNT-4]}
    CUR_BAND=$(echo $CUR_BAND 1000 | awk '{printf "%4.3f\n",$1*$2}')
    echo "$CUR_BAND" >> $FILE_NAME
    COUNT=$((COUNT+1))
done

AVG_FILE_NAME="${array[0]}/${array[1]}.input.out.bw.avg"
rm $AVG_FILE_NAME
COUNT=0
SUM=0
FIELDS=""
I=0
if [ ! -f $AVG_FILE_NAME ]; then
    while IFS= read -r line; do
	if [ "$COUNT" -eq "0" ]; then
	    echo "Time		Bandwidth" > $AVG_FILE_NAME
	else
	    mod=$((I%5))
	    if [ "$mod" -eq "0" ] && [ "$I" -gt "0" ]; then
		AVG=`echo $SUM / 5 | bc`
		#echo "$COUNT		$AVG" >> $AVG_FILE_NAME
		MED=`median$FIELDS`
#echo "FIELDS=$FIELDS -> MED=$MED"
		echo "$COUNT		$MED" >> $AVG_FILE_NAME
		SUM=0
		FIELDS=""
		I=0
	    else
		INT=($(printf "%.0f\n" "$line"))
		if [[ "$INT" -eq "0" ]]; then
		    echo "line $INT"
		     echo "$COUNT		$INT" >> $AVG_FILE_NAME
		else
		    SUM=`echo $SUM + $line | bc`
		    echo "SUM=$SUM line=$line"
		    FIELDS="$FIELDS $INT"
		    I=$((I+1))
		fi
	    fi
	fi
	COUNT=$((COUNT+1))
    done < $FILE_NAME
fi

LABEL="set xlabel 'Time in Seconds'; set ylabel 'Bandwidth'; set title"
CMD_F1="$LABEL 'Bandwidth overtime in input node#${array[1]} in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "
CMD_F1="$CMD_F1'$AVG_FILE_NAME' using 1:2 with linespoints title 'Bandwidth' "
gnuplot -e "$CMD_F1; pause -1"

