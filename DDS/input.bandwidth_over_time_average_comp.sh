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

avg_generator() {

	ORIGINAL_FILE_NAME="$1/$2.input.out"
	FILE_NAME="$1/$2.input.out.bw.tmp"
	rm $FILE_NAME
	COUNT="0"

	grep "[A-Za-z ]B/s (" $ORIGINAL_FILE_NAME | while read -r line ; do
	    IFS=' ' read -r -a arr <<< "$line"
	    ARRAY_COUNT=${#arr[@]}
	    CUR_BAND=${arr[ARRAY_COUNT-4]}
	    echo "$CUR_BAND" >> $FILE_NAME
	    COUNT=$((COUNT+1))
	done

	AVG_FILE_NAME="$1/$2.input.out.bw.avg"
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
			if [[ "$INT" -eq "0" || ( "$COUNT" -ge "200" && "$COUNT" -le "220" ) ]]; then
			    echo "line $INT"
			     echo "$COUNT		$INT" >> $AVG_FILE_NAME
			else
			    SUM=`echo $SUM + $line | bc`
			    FIELDS="$FIELDS $INT"
			    I=$((I+1))
			fi
		    fi
		fi
		COUNT=$((COUNT+1))
	    done < $FILE_NAME
	fi
}

avg_generator "${array[0]}" "${array[1]}"
avg_generator "${array[2]}" "${array[3]}"

AVG_FILE_NAME1="${array[0]}/${array[1]}.input.out.bw.avg"
AVG_FILE_NAME2="${array[2]}/${array[3]}.input.out.bw.avg"

LABEL="set xlabel 'Time in Seconds' font ',15'; set ylabel 'Bandwidth' font ',15'; set title"
#CMD_F1="$LABEL 'Bandwidth comparison overtime between ${array[0]} and ${array[2]} input node#${array[1]} and ${array[3]} in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "
CMD_F1="$LABEL 'Bandwidth comparison overtime' font ',15'; plot "
CMD_F1="$CMD_F1'$AVG_FILE_NAME1' using 1:2 with linespoints title 'FLESnet', '$AVG_FILE_NAME2' using 1:2 with linespoints title 'DFS'; "
gnuplot -e "$CMD_F1; pause -1"

