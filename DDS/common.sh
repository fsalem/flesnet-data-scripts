#!/bin/bash

DATE=`date +%Y-%m-%d`
IFS=' ' read -r -a array <<< "$@"
Test_CASES=${#array[@]}
#echo "Test_CASES=$Test_CASES"

INPUT_COUNT=$(ls ${array[0]}/*.input.out | wc -l)
COMPUTE_COUNT=$(ls ${array[0]}/*.compute.out | wc -l)

JOB_NAME=`basename "${array[0]}"`

line=''
if [ -f ${array[0]}/${array[1]}.input.out ]; then
	IFS=' ' read -r -a line <<< $(grep '[A-Za-z ]*MB/s)' ${array[0]}/${array[1]}.input.out)
else
	IFS=' ' read -r -a line <<< $(grep '[A-Za-z ]*MB/s)' ${array[0]}/0.input.out)
fi
SPLIT_COUNT=${#line[@]}
INPUT_BW=${line[SPLIT_COUNT-2]:1}
