#!/bin/bash

if grep -Fxq "$FILENAME" my_list.txt
then
    # code if found
else
    # code if not found
fi

DATE=`date +%Y-%m-%d`
IFS=' ' read -r -a array <<< "$@"
Test_CASES=${#array[@]}
#echo "Test_CASES=$Test_CASES"

INPUT_COUNT=$(ls ${array[0]}/*.input.out | wc -l)
COMPUTE_COUNT=$(ls ${array[0]}/*.compute.out | wc -l)

JOB_NAME=`basename "${array[0]}"`

IFS=' ' read -r -a line <<< $(grep '[A-Za-z ]*MB/s)' ${array[0]}/${array[1]}.input.out)
SPLIT_COUNT=${#line[@]}
INPUT_BW=${line[SPLIT_COUNT-2]:1}
