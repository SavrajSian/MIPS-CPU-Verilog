#!/bin/bash

set -eou pipefail

srcdir="$1"
TESTCASE="$2"

iverilog -Wall -g 2012 -I"test/testcases/" -s ${TESTCASE}_tb\
 -o ${TESTCASE}_tb "test/testcases/"${TESTCASE}.v ${srcdir}/mips_cpu_*.v ${srcdir}/mips_cpu/*.v

set +e
./${TESTCASE}_tb
RESULT=$?
set -e

if [[ "${RESULT}" -eq 0 ]] ; then
   echo "${TESTCASE}, ${TESTCASE//[^[:alpha:]]/}, Pass"
else
   echo "${TESTCASE}, ${TESTCASE//[^[:alpha:]]/}, Fail"
fi
