#!/bin/bash

FILE="$1/$2.input.ts_info.out"
PERCENTILE=$3

echo $(sort -k3 -n $FILE | awk -v perc="$PERCENTILE" '{all[NR] = $3} END{print all[int(NR*(perc/100.00) - 0.5)]}')
