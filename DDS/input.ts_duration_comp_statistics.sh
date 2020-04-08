#!/bin/bash

source "common.sh"

# Input is number of compute nodes in space seperated
IFS=' ' read -r -a array <<< "$@"

STATS_FILE_NAME="${array[0]}/${array[1]}.input.ts_info.stats.out"
FILE_NAME="${array[0]}/${array[1]}.input.ts_info.out"
COMPUTE_FILES=${array[2]}
if [ ! -f $STATS_FILE_NAME ]; then
	RDMA_DUR_FILE="${array[0]}/${array[1]}.input.ts_info.out.tmp"
	ORDERED_FILE_NAME="${array[0]}/${array[1]}.input.ts_info.ordered.out"
	COUNTER=0
	while [  $COUNTER -lt $COMPUTE_FILES ]; do
    	awk -v IND=$COUNTER '{if($2 ~ /^[0-9]+$/ && int($2) == IND){print $3}}' $FILE_NAME > $RDMA_DUR_FILE
		sort -n $RDMA_DUR_FILE > $ORDERED_FILE_NAME
	
		WC_1=$(wc -l < $ORDERED_FILE_NAME)
		QUARTER_1=$(( WC_1/10 ))
		HALF_1=$(( WC_1/2 ))
		THREEQUARTER_1=$(( WC_1*9/10 ))

		MIN_VALUE_1=$(head -n 1 $ORDERED_FILE_NAME)
		QUARTER_VALUE_1=$(awk -v num=$QUARTER_1 'NR == num {print}' $ORDERED_FILE_NAME)
		HALF_VALUE_1=$(awk -v num=$HALF_1 'NR == num {print}' $ORDERED_FILE_NAME)
		THREEQUARTER_VALUE_1=$(awk -v num=$THREEQUARTER_1 'NR == num {print}' $ORDERED_FILE_NAME)
		MAX_VALUE_1=$(tail -n 1 $ORDERED_FILE_NAME)
		
		FILE_SPACING=$(( 3*COUNTER + 1 ))
		printf "\"CN_$COUNTER\"\t%s\t\t%s\t\t%s\t\t%s\t\t%s\t\t$FILE_SPACING\n" "$MIN_VALUE_1" "$QUARTER_VALUE_1" "$HALF_VALUE_1" "$THREEQUARTER_VALUE_1" "$MAX_VALUE_1" >> $STATS_FILE_NAME
		#printf "\"CN_$COUNTER\"\t%s\t\t%s\t\t%s\t\t%s\t\t%s\t\t$FILE_SPACING\n" "$MIN_VALUE_1" "$QUARTER_VALUE_1" "$HALF_VALUE_1" "$THREEQUARTER_VALUE_1" "$MAX_VALUE_1"
		#read -p "Press enter to continue"
		rm $ORDERED_FILE_NAME
		rm $RDMA_DUR_FILE
		let COUNTER=COUNTER+1
	done
fi

######## PARAMS ########## gnuplot -e "FILE='xyz.data'"
AUTO_FREQ=1
##########################


LABEL=" set ylabel 'Latency (ms)'; 
	set key right width -2 spacing 1.2 maxrows 4 samplen 2;
	set xtics nomirror scale 1;
	set ytics nomirror out scale 0;
	set grid ytics mytics;
	set yrange [-40: ];
	set ytics autofreq $AUTO_FREQ;
	set style data histogram;
	set style histogram cluster;
	set style fill solid border -1;
	set boxwidth 0.9;
	set offset 5,5,0;
	set xlabel 'Min, Max (bar: 10th - 90th percentile, median) of IN#${array[1]}';"
CMD="$LABEL;  set title 'Statistics about needed duration to complete a timeslice in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "


CMD="$CMD '$STATS_FILE_NAME'  using  7:(\$3/1000):(\$2/1000):(\$6/1000):(\$5/1000):xtic(1) with candlesticks ls 6 lw 0.8 notitle whiskerbars; "



#echo "CMD=$CMD"
gnuplot -e "$CMD;pause -1"
