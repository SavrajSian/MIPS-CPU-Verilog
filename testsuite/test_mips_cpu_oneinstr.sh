#!/bin/bash

set -eou pipefail

srcdir="$1"
TESTCASE="$2"

>&2 echo "Compiling test-bench for ${TESTCASE}"

iverilog -Wall -g 2012 -I"test/testcases/" -s ${TESTCASE}_tb -o ${TESTCASE}_tb "test/testcases/"${TESTCASE}.v ${srcdir}/*.v

set +e
./${TESTCASE}_tb
RESULT=$?
set -e

if [[ "${RESULT}" -ne 0 ]] ; then
   echo "${TESTCASE}, ${TESTCASE//[^[:alpha:]]/}, fail"
else
   echo "${TESTCASE}, ${TESTCASE//[^[:alpha:]]/}, pass"
fi
