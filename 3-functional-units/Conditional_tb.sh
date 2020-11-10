#!/bin/bash

# Single >> - recreate file
# Double >> - Append

echo "Begin iterative test"
#compiles and elaboration of multiplier_iterative_v0
iverilog -Wall -g 2012 -s multiplier_iterative_tb -o multiplier_iterative_tb multiplier_iterative_tb.v multiplier_iterative_v0.v 
if ./multiplier_iterative_tb > log.txt; then
    echo "v0 test success"
else
    echo "v0 test failed"
fi

#compiles and elaboration of multiplier_iterative_v1
iverilog -Wall -g 2012 -s multiplier_iterative_tb -o multiplier_iterative_tb multiplier_iterative_tb.v multiplier_iterative_v1.v 
if ./multiplier_iterative_tb >> log.txt; then
    echo "v1 test success"
else
    echo "v1 test failed"
fi

#compiles and elaboration of multiplier_iterative_v2
iverilog -Wall -g 2012 -s multiplier_iterative_tb -o multiplier_iterative_tb multiplier_iterative_tb.v multiplier_iterative_v2.v 
if ./multiplier_iterative_tb >> log.txt; then
    echo "v2 test success"
else
    echo "v2 test failed"
fi

#compiles and elaboration of multiplier_iterative_v3
iverilog -Wall -g 2012 -s multiplier_iterative_tb -o multiplier_iterative_tb multiplier_iterative_tb.v multiplier_iterative_v3.v 
if ./multiplier_iterative_tb >> log.txt; then
    echo "v3 test success"
else
    echo "v3 test failed"
fi

echo "Begin pipelined test"
#compiles and elaboration of multiplier_pipelined_v0
iverilog -Wall -g 2012 -s multiplier_pipelined_tb -o multiplier_pipelined_tb multiplier_pipelined_tb.v multiplier_pipelined_v0.v 
if ./multiplier_pipelined_tb >> log.txt; then
    echo "v0 test success"
else
    echo "v0 test failed"
fi

#compiles and elaboration of multiplier_pipelined_v1
iverilog -Wall -g 2012 -s multiplier_pipelined_tb -o multiplier_pipelined_tb multiplier_pipelined_tb.v multiplier_pipelined_v1.v 
if ./multiplier_pipelined_tb >> log.txt; then
    echo "v1 test success"
else
    echo "v1 test failed"
fi

#compiles and elaboration of multiplier_pipelined_v2
iverilog -Wall -g 2012 -s multiplier_pipelined_tb -o multiplier_pipelined_tb multiplier_pipelined_tb.v multiplier_pipelined_v2.v 
if ./multiplier_pipelined_tb >> log.txt; then
    echo "v2 test success"
else
    echo "v2 test failed"
fi

#compiles and elaboration of multiplier_pipelined_v3
iverilog -Wall -g 2012 -s multiplier_pipelined_tb -o multiplier_pipelined_tb multiplier_pipelined_tb.v multiplier_pipelined_v3.v 
if ./multiplier_pipelined_tb >> log.txt; then
    echo "v3 test success"
else
    echo "v3 test failed"
fi

#compiles and elaboration of multiplier_pipelined_v4
iverilog -Wall -g 2012 -s multiplier_pipelined_tb -o multiplier_pipelined_tb multiplier_pipelined_tb.v multiplier_pipelined_v4.v 
if ./multiplier_pipelined_tb >> log.txt; then
    echo "v4 test success"
else
    echo "v4 test failed"
fi

# # compiles and elaboration of multiplier_pipelined_v5
iverilog -Wall -g 2012 -s multiplier_pipelined_tb -o multiplier_pipelined_tb multiplier_pipelined_tb.v multiplier_pipelined_v5.v 
if ./multiplier_pipelined_tb >> log.txt; then
    echo "v5 test success"
else
    echo "v5 test failed"
fi


echo "Begin Single-Port Register Simple file"
#compiles and elaboration of register_file_v0
iverilog -Wall -g 2012 -s register_file_tb_simple -o register_file_tb_simple register_file_tb_simple.v register_file_v0.v 
if ./register_file_tb_simple >> log.txt; then
    echo "v0 test success"
else
    echo "v0 test failed"
fi
#compiles and elaboration of register_file_v1
iverilog -Wall -g 2012 -s register_file_tb_simple -o register_file_tb_simple register_file_tb_simple.v register_file_v1.v 
if ./register_file_tb_simple >> log.txt; then
    echo "v1 test success"
else
    echo "v1 test failed"
fi
#compiles and elaboration of register_file_v2
iverilog -Wall -g 2012 -s register_file_tb_simple -o register_file_tb_simple register_file_tb_simple.v register_file_v2.v 
if ./register_file_tb_simple >> log.txt; then
    echo "v2 test success"
else
    echo "v2 test failed"
fi
#compiles and elaboration of register_file_v3
iverilog -Wall -g 2012 -s register_file_tb_simple -o register_file_tb_simple register_file_tb_simple.v register_file_v3.v 
if ./register_file_tb_simple >> log.txt; then
    echo "v3 test success"
else
    echo "v3 test failed"
fi

echo "Begin Single-Port Register Random file"
#compiles and elaboration of register_file_v0
iverilog -Wall -g 2012 -s register_file_tb -o register_file_tb register_file_tb_random.v register_file_v0.v 
if ./register_file_tb >> log.txt; then
    echo "v0 test success"
else
    echo "v0 test failed"
fi
#compiles and elaboration of register_file_v1
iverilog -Wall -g 2012 -s register_file_tb -o register_file_tb register_file_tb_random.v register_file_v1.v 
if ./register_file_tb >> log.txt; then
    echo "v1 test success"
else
    echo "v1 test failed"
fi
#compiles and elaboration of register_file_v2
iverilog -Wall -g 2012 -s register_file_tb -o register_file_tb register_file_tb_random.v register_file_v2.v 
if ./register_file_tb >> log.txt; then
    echo "v2 test success"
else
    echo "v2 test failed"
fi
#compiles and elaboration of register_file_v3
iverilog -Wall -g 2012 -s register_file_tb -o register_file_tb register_file_tb_random.v register_file_v3.v 
if ./register_file_tb >> log.txt; then
    echo "v3 test success"
else
    echo "v4 test failed"
fi

echo "Test Completed"