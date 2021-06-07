#!/bin/bash

FILE="$1/$2.input.ts_info.out"
SORTED_FILE="$1/$2.input.ts_info.out.sorted"

if [ ! -f $SORTED_FILE ]; then
	sort -k3 -n $FILE > $SORTED_FILE
fi

MIN=$(awk -v perc="1" '{all[NR] = $3} END{print all[int(NR*(perc/100.00) - 0.5)]}' $SORTED_FILE)
TENTH=$(awk -v perc="10" '{all[NR] = $3} END{print all[int(NR*(perc/100.00) - 0.5)]}' $SORTED_FILE)
MID=$(awk -v perc="50" '{all[NR] = $3} END{print all[int(NR*(perc/100.00) - 0.5)]}' $SORTED_FILE)
NINTH=$(awk -v perc="90" '{all[NR] = $3} END{print all[int(NR*(perc/100.00) - 0.5)]}' $SORTED_FILE)
MAX=$(awk -v perc="100" '{all[NR] = $3} END{print all[int(NR*(perc/100.00) - 0.5)]}' $SORTED_FILE)

echo "|-------------------------------------------------------------------------------|"
echo "|	0	|	10	|	50	|	90	|	100	|"
echo "|-------------------------------------------------------------------------------|"
echo "|	$MIN	|	$TENTH	|	$MID	|	$NINTH	|	$MAX	|"
echo "|-------------------------------------------------------------------------------|"
