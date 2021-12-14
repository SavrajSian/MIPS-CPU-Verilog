#!/bin/bash

set -eou pipefail

srcdir="$1"
TESTCASE="$2"

>&2 echo "Compiling test-bench for ${TESTCASE}"

iverilog -Wall -g 2012 -I test/testcases/ -s -I test/testcases/ ${TESTCASE}_tb -o ${TESTCASE}_tb ${srcdir}/ALU_FINAL.v ${srcdir}/CS_FINAL.v \
${srcdir}/INSTR_REG_FINAL.v ${srcdir}/LOAD_FINAL.v ${srcdir}/MEM_TO_DATA_FINAL.v ${srcdir}/PC_FINAL.v \
${srcdir}/REGFILE_FINAL.v ${srcdir}/STORE_FINAL.v ${srcdir}/Test_RAM.v ${srcdir}/TOP_LEVEL_CPU_FINAL.v

set +e
./${TESTCASE}_tb
RESULT=$?
set -e

if [[ "${RESULT}" -ne 0 ]] ; then
   echo " ${TESTCASE}, FAIL"
else
   echo " ${TESTCASE}, pass"
fi
