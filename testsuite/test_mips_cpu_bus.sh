#!/bin/bash
set -eou pipefail

srcdir="$1"
instr="$2"

TESTCASES="test/testcases/*.v" #Make sure testcase module names are the file basename + '_tb'. E.g Addiu123.v has module name Addiu123_tb

for i in ${TESTCASES} ; do
	TESTNAME=$(basename ${i} .v)
	echo $TESTNAME
	./test/test_mips_cpu_oneinstr.sh ${srcdir} ${TESTNAME}
done
