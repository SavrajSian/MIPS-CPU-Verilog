#!/bin/bash
set -eou pipefail

srcdir="$1"
instr="$2"

TESTCASES="test/testcases/*.v"

for i in ${TESTCASES} ; do
	TESTNAME=$(basename ${i} .v)
	echo $TESTNAME
	./test/test_mips_cpu_oneinstr.sh ${srcdir} ${TESTNAME}
done
