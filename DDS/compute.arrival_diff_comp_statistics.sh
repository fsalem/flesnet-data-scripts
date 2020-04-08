#!/bin/bash

source "common.sh"

# Input is number of compute nodes in space seperated

STATS_FILE_NAME1="${array[0]}/compute.arrival_diff.stats.out"
if [ ! -f $STATS_FILE_NAME1 ]; then
	FILE_NAME="${array[0]}/compute.arrival_diff.out"
	ORDERED_FILE_NAME="${array[0]}/compute.arrival_diff.ordered.out"
	IFS=' ' read -r -a array <<< "$@"
	COMPUTE_FILES=${array[1]}
	echo "COMPUTE_FILES=$COMPUTE_FILES"

	ROW_COUNT=$(cat "${array[0]}/0.compute.arrival_diff.out" | wc -l)
	echo "ROW_COUNT=$ROW_COUNT"
	COUNTER=0
	while [  $COUNTER -lt $COMPUTE_FILES ]; do
        	CUR_FILE="${array[0]}/$COUNTER.compute.arrival_diff.out"
        	cat "$CUR_FILE" >> "$FILE_NAME"
    	let COUNTER=COUNTER+1
	done

	sort -k1 -n $FILE_NAME | awk '$1 <= 10000000 { print $2 }' | sort -k1 -g > $ORDERED_FILE_NAME
	
	WC_1=$(wc -l < $ORDERED_FILE_NAME)
	QUARTER_1=$(( WC_1/10 ))
	HALF_1=$(( WC_1/2 ))
	THREEQUARTER_1=$(( WC_1*9/10 ))

	MIN_VALUE_1=$(head -n 1 $ORDERED_FILE_NAME)
	QUARTER_VALUE_1=$(awk -v num=$QUARTER_1 'NR == num {print}' $ORDERED_FILE_NAME)
	HALF_VALUE_1=$(awk -v num=$HALF_1 'NR == num {print}' $ORDERED_FILE_NAME)
	THREEQUARTER_VALUE_1=$(awk -v num=$THREEQUARTER_1 'NR == num {print}' $ORDERED_FILE_NAME)
	MAX_VALUE_1=$(tail -n 1 $ORDERED_FILE_NAME)

	printf "\"With Failure\"\t%s\t\t%s\t\t%s\t\t%s\t\t%s\t\t1\n" "$MIN_VALUE_1" "$QUARTER_VALUE_1" "$HALF_VALUE_1" "$THREEQUARTER_VALUE_1" "$MAX_VALUE_1" > $STATS_FILE_NAME1
	
	rm $ORDERED_FILE_NAME
fi

STATS_FILE_NAME2="${array[2]}/compute.arrival_diff.stats.out"
if [ ! -f $STATS_FILE_NAME2 ]; then
        FILE_NAME="${array[2]}/compute.arrival_diff.out"
        ORDERED_FILE_NAME="${array[2]}/compute.arrival_diff.ordered.out"
        IFS=' ' read -r -a array <<< "$@"
        COMPUTE_FILES=${array[3]}
        echo "COMPUTE_FILES=$COMPUTE_FILES"

        ROW_COUNT=$(cat "${array[2]}/0.compute.arrival_diff.out" | wc -l)
        echo "ROW_COUNT=$ROW_COUNT"
        COUNTER=0
        while [  $COUNTER -lt $COMPUTE_FILES ]; do
                CUR_FILE="${array[2]}/$COUNTER.compute.arrival_diff.out"
                cat "$CUR_FILE" >> "$FILE_NAME"
        let COUNTER=COUNTER+1
        done

        sort -k1 -n $FILE_NAME | awk '$1 <= 10000000 { print $2 }' | sort -k1 -g > $ORDERED_FILE_NAME

        WC_1=$(wc -l < $ORDERED_FILE_NAME)
        QUARTER_1=$(( WC_1/10 ))
        HALF_1=$(( WC_1/2 ))
        THREEQUARTER_1=$(( WC_1*9/10 ))

        MIN_VALUE_1=$(head -n 1 $ORDERED_FILE_NAME)
        QUARTER_VALUE_1=$(awk -v num=$QUARTER_1 'NR == num {print}' $ORDERED_FILE_NAME)
        HALF_VALUE_1=$(awk -v num=$HALF_1 'NR == num {print}' $ORDERED_FILE_NAME)
        THREEQUARTER_VALUE_1=$(awk -v num=$THREEQUARTER_1 'NR == num {print}' $ORDERED_FILE_NAME)
        MAX_VALUE_1=$(tail -n 1 $ORDERED_FILE_NAME)

        printf "\"Without Failure\"\t%s\t\t%s\t\t%s\t\t%s\t\t%s\t\t5\n" "$MIN_VALUE_1" "$QUARTER_VALUE_1" "$HALF_VALUE_1" "$THREEQUARTER_VALUE_1" "$MAX_VALUE_1" > $STATS_FILE_NAME2

        rm $ORDERED_FILE_NAME
fi

######## PARAMS ########## gnuplot -e "FILE='xyz.data'"
NODES=16 #64, 128, 192, 384
MAX_Y_RANGE=300 # 490, 1300, 2390, 5590
AUTO_FREQ=20  # 100, 200, 400, 800
##########################


LABEL=" set ylabel ''; 
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
	set xlabel 'Min, Max (bar: 10th - 90th percentile, median) ($NODES nodes)';"
CMD="$LABEL; plot "
# set title 'Statistics about needed duration to complete a timeslice in $JOB_NAME [$INPUT_COUNT INs, $COMPUTE_COUNT CNs, $INPUT_BW GB/s] [$DATE]'; plot "


CMD="$CMD '$STATS_FILE_NAME1'  using  (\$7 == 1 ? \$7 : 1/0):(\$3/1000):(\$2/1000):(\$6/1000):(\$5/1000):xtic(1) with candlesticks ls 6 lw 0.8 notitle whiskerbars, \
	   '$STATS_FILE_NAME1' u (\$7 == 1 ? \$7 : 1/0):(\$4/1000):(\$4/1000):(\$4/1000):(\$4/1000):xtic(1)  with candlesticks lt -1 lw 1.8 notitle, \
	   '$STATS_FILE_NAME2' using  (\$7 == 5 ? \$7 : 1/0):(\$3/1000):(\$2/1000):(\$6/1000):(\$5/1000):xtic(1) with candlesticks ls 5  lw 0.8 notitle whiskerbars, \
	   '$STATS_FILE_NAME2' u (\$7 == 5 ? \$7 : 1/0):(\$4/1000):(\$4/1000):(\$4/1000):(\$4/1000):xtic(1)  with candlesticks lt -1 lw 1.8 notitle; "



#echo "CMD=$CMD"
gnuplot -e "$CMD;pause -1"
