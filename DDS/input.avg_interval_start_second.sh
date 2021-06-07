#!/bin/bash

source "common.sh"

individual_generator() {

	ORIGINAL_FILE_NAME="$1/$2.input.proposed_actual_interval_info.out"
	FILE_NAME="$1/$2.input.interval_second.out"
	rm $FILE_NAME
	
	#echo "Interval			Second" > $FILE_NAME
	echo "" > $FILE_NAME
	while read -r -a line; do
		re='^[0-9]+$'
		if  [[ ${line[0]} =~ $re ]] ; then
			SEC=`echo ${line[2]} / 1000 | bc`
			echo "${line[0]}			$SEC" >> $FILE_NAME
		fi
	done < $ORIGINAL_FILE_NAME
}


interval_second_aggregator() {
	FOLDER=$1
	INPUT_COUNT=$2
	AGG_FILE_NAME="$1/input.agg_interval_second.out"
	echo "" > $AGG_FILE_NAME
	I=0
	while [ "$I" -lt "$INPUT_COUNT" ]; do
		while read -r line; do
			echo "$line			$I" >> $AGG_FILE_NAME
		done < "$1/$I.input.interval_second.out"
		I=$((I+1))
	done
	SORTED_FILE_NAME="$1/input.agg_interval_second.out.sorted"
	grep "\S" $AGG_FILE_NAME | sort -k1 -k3 -n  > $SORTED_FILE_NAME
	LINES_COUNT=$(wc -l $SORTED_FILE_NAME | awk '{ print $1 }')
	#echo "LINES=$LINES_COUNT"
	STAT_FILE_NAME="$1/input.avg_interval_second.out.stat"
	echo "Interval			Second" > $STAT_FILE_NAME
	SUM=0
	CUR_INV=0
	COUNT=0
	while read -r -a line; do
		re='^[0-9]+$'
		if  [[ ${line[0]} =~ $re ]] &&  [[ ${line[1]} =~ $re ]]; then
			if [ "$CUR_INV" = "0" ]; then
				CUR_INV=${line[0]}
			fi
			if [ "$CUR_INV" != "0" ] && [ "$CUR_INV" != "${line[0]}" ]; then
				AVG=`echo $SUM / $COUNT | bc`
				echo "$CUR_INV			$AVG" >> $STAT_FILE_NAME
				CUR_INV=${line[0]}
				COUNT=0
				SUM=0
			fi
			SUM=$(($SUM+${line[1]}))
			COUNT=$((COUNT+1))
		fi
	done < $SORTED_FILE_NAME
	AVG=`echo $SUM / $COUNT | bc`
	echo "$CUR_INV			$AVG" >> $STAT_FILE_NAME
	
	rm $SORTED_FILE_NAME $AGG_FILE_NAME
	
}

IND=0
while [ "$IND" -lt "${array[1]}" ]; do
	echo "IND=$IND"
	individual_generator "${array[0]}" "$IND"
	individual_generator "${array[2]}" "$IND"
	IND=$((IND+1))
done

interval_second_aggregator ${array[0]} ${array[1]}
interval_second_aggregator ${array[2]} ${array[3]}

AVG_FILE_NAME1="${array[0]}/input.avg_interval_second.out.stat"
AVG_FILE_NAME2="${array[2]}/input.avg_interval_second.out.stat"


CMD="set xlabel ''; set ylabel 'Interval';
set errorbars 4.0;
set grid ytics mytics;
set style data histogram;
set style histogram cluster;
set style fill solid border -1;
#set yrange[-1000:6000];
#set xrange[:800];

set multiplot layout 2,1;
plot '$AVG_FILE_NAME1' using 2:1 with points ls 6 title '#1', \
	 '$AVG_FILE_NAME2' using 2:1 with points ls 7 title '#2';
unset multiplot;"

     
gnuplot -e "$CMD; pause -1"

