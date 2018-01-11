#!/bin/bash

DATE=`date +%Y-%m-%d`
IFS=' ' read -r -a array <<< "$@"
Test_CASES=${#array[@]}
#echo "Test_CASES=$Test_CASES"

INPUT_COUNT=$(ls ../../${array[0]}/*.input.out | wc -l)
COMPUTE_COUNT=$(ls ../../${array[0]}/*.compute.out | wc -l)

IFS=' ' read -r -a line <<< $(grep '[A-Za-z ]*MB/s)' ../../${array[0]}/${array[1]}.input.out)
SPLIT_COUNT=${#line[@]}
INPUT_BW=${line[SPLIT_COUNT-2]:1}
