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


avg_aggregator() {
	FOLDER=$1
	INPUT_COUNT=$2
	AGG_FILE_NAME="$1/input.out.bw.avg"
	#echo "Time		Bandwidth		IN" > $AGG_FILE_NAME
	echo "" > $AGG_FILE_NAME
	I=0
	while [ "$I" -lt "$INPUT_COUNT" ]; do
		while read -r line; do
			if [ "$line" != "Time		Bandwidth" ]; then
				echo "$line			$I" >> $AGG_FILE_NAME
			fi
		done < "$1/$I.input.out.bw.avg"
		I=$((I+1))
	done
	SORTED_FILE_NAME="$1/input.out.bw.avg.sorted"
	grep "\S" $AGG_FILE_NAME | sort -k1 -k2 -k3 -n  > $SORTED_FILE_NAME
	LINES_COUNT=$(wc -l $SORTED_FILE_NAME | awk '{ print $1 }')
	#echo "LINES=$LINES_COUNT"
	STAT_FILE_NAME="$1/input.out.bw.avg.stat"
	echo "Time		Min		Max		AVG		MEDIAN		10th		90th" > $STAT_FILE_NAME
	I=0
	MIN=0
	MAX=0
	SUM=0
	MED=0
	TENTH_PER=0
	NINTH_PER=0
	TIME=0
	MIDDLE=$((INPUT_COUNT/2))
	TENTH=$(( INPUT_COUNT/10 ))
	NINTH=$(( INPUT_COUNT*9/10 ))
	while read -r -a line; do
		#FS=' ' read -r -a arr <<< "$line"
	 	mod=$((I%INPUT_COUNT))
		if [ "$mod" -eq "0" ]; then
			if [ "$I" -ne "0" ]; then
				AVG=$((SUM/INPUT_COUNT))
				echo "$TIME		$MIN		$MAX		$AVG		$MED		$TENTH_PER		$NINTH_PER" >> $STAT_FILE_NAME
				#echo "$TIME		$MIN		$MAX		$AVG		$MED		$TENTH_PER		$NINTH_PER"
			fi
			MIN=${line[1]}
			MAX=${line[1]}
			SUM=${line[1]}
			TIME=${line[0]}
			MED=${line[1]}
			TENTH_PER=${line[1]}
			NINTH_PER=${line[1]}
		else
			SUM=$(($SUM + ${line[1]}))
			if [ "$mod" -eq "$TENTH" ]; then
				TENTH_PER=${line[1]}
			fi
			if [ "$mod" -eq "$NINTH" ]; then
				NINTH_PER=${line[1]}
			fi
			if [ "$mod" -eq "$MIDDLE" ]; then
				MED=${line[1]}
			fi
			if [ "${line[1]}" -lt "$MIN" ]; then
				MIN=${line[1]}
			fi
			if [ "${line[1]}" -gt "$MAX" ]; then
				MAX=${line[1]}
			fi
		fi
		I=$((I+1))
		if [ "$I" -eq "$LINES_COUNT" ]; then
			AVG=$((SUM/INPUT_COUNT))
			echo "$TIME		$MIN		$MAX		$AVG		$MED		$TENTH_PER		$NINTH_PER" >> $STAT_FILE_NAME
			#echo "$TIME		$MIN		$MAX		$AVG		$MED		$TENTH_PER		$NINTH_PER"
		fi
	done < $SORTED_FILE_NAME
	
	#rm $SORTED_FILE_NAME
}

IND=0
#while [ "$IND" -lt "${array[1]}" ]; do
#	echo "IND=$IND"
#	avg_generator "${array[0]}" "$IND"
#	avg_generator "${array[2]}" "$IND"
#	IND=$((IND+1))
#done

#avg_aggregator ${array[0]} ${array[1]}
#avg_aggregator ${array[2]} ${array[3]}

AVG_FILE_NAME1="${array[0]}/input.out.bw.avg.stat"
AVG_FILE_NAME2="${array[2]}/input.out.bw.avg.stat"


CMD="set xlabel ''; set ylabel 'Bandwidth (MB/s)';
set errorbars 4.0;
set grid ytics mytics;
set style data histogram;
set style histogram cluster;
set style fill solid border -1;
set yrange[-1000:];
set multiplot layout 2,1;
plot '$AVG_FILE_NAME1' using 1:6:2:3:7 with candlesticks ls 6 title 'With Failure' whiskerbars, \
     ''         using 1:5:5:5:5 with candlesticks ls 6 lt -1 notitle;
set xlabel 'Time in Seconds';    
plot '$AVG_FILE_NAME2' using 1:6:2:3:7 with candlesticks ls 7 title 'W/o Failure' whiskerbars, \
     ''         using 1:5:5:5:5 with candlesticks ls 7 lt -1 notitle;
unset multiplot;"

     
gnuplot -e "$CMD; pause -1"

