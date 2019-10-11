#!/bin/sh

# Exit immediately on error
set -e

# set -x

FILENAME=$1
echo "FILENAME=$FILENAME"

# Create temporary file
FILE=$(mktemp /tmp/$(basename $0).XXXXX) || exit 1
trap "rm -f $FILE" EXIT

# Sort entries
sort -n $* > $FILE
# Count number of data points
N=$(wc -l $FILE | awk '{print $1}')
# Calculate line numbers for each percentile we're interested in
P50=$(dc -e "$N 2 / p")
P90=$(dc -e "$N 9 * 10 / p")
P99=$(dc -e "$N 99 * 100 / p")
echo ";; 50th, 90th and 99th percentiles for $N data points"
awk "FNR==$P50 || FNR==$P90 || FNR==$P99" $FILE
