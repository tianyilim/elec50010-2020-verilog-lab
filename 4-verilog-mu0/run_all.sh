#!/bin/bash

# Build the MU0 utilities
./build_utils.sh

# Add to this list if new testcase added
TESTS=("delay0" "delay1" "delay1v2" "delay0_abstract" "delay1_abstract" "delay1_pipe")

# Run all the test-cases for each variant
for i in ${TESTS[@]} ; do
    echo ${i}
    ./run_all_testcases.sh ${i}
    echo ""
done

# ./run_all_testcases.sh delay0
# ./run_all_testcases.sh delay1
# ./run_all_testcases.sh delay1v2
# ./run_all_testcases.sh delay0_abstract
# ./run_all_testcases.sh delay1_abstract
