#!/bin/bash

echo "What is the source directory?"
read src

echo "Which instruction would you like to test?"
read instr

TESTCASES="$src/test/testcases/*tb.v"

for i in ${TESTCASES} ; do
    TESTNAME=$(basename ${i} .v)
    echo $TESTNAME
done
