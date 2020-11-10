#!/bin/sh
iverilog -Wall -g 2012 -s multiplier_iterative_tb -o mul_iter_tb0 multiplier_iterative_tb.v multiplier_iterative_v0.v;
iverilog -Wall -g 2012 -s multiplier_iterative_tb -o mul_iter_tb1 multiplier_iterative_tb.v multiplier_iterative_v1.v;
iverilog -Wall -g 2012 -s multiplier_iterative_tb -o mul_iter_tb2 multiplier_iterative_tb.v multiplier_iterative_v2.v;
iverilog -Wall -g 2012 -s multiplier_iterative_tb -o mul_iter_tb3 multiplier_iterative_tb.v multiplier_iterative_v3.v;

echo "Iterative Multiplier Compilation Success"

./mul_iter_tb0;
./mul_iter_tb1;
./mul_iter_tb2;
./mul_iter_tb3;

echo "Iterative Multiplier Test Complete"

iverilog -Wall -g 2012 -s multiplier_pipelined_tb -o mul_pipe_tb0 multiplier_pipelined_tb.v multiplier_pipelined_v0.v;
iverilog -Wall -g 2012 -s multiplier_pipelined_tb -o mul_pipe_tb1 multiplier_pipelined_tb.v multiplier_pipelined_v1.v;
iverilog -Wall -g 2012 -s multiplier_pipelined_tb -o mul_pipe_tb2 multiplier_pipelined_tb.v multiplier_pipelined_v2.v;
iverilog -Wall -g 2012 -s multiplier_pipelined_tb -o mul_pipe_tb3 multiplier_pipelined_tb.v multiplier_pipelined_v3.v;
iverilog -Wall -g 2012 -s multiplier_pipelined_tb -o mul_pipe_tb4 multiplier_pipelined_tb.v multiplier_pipelined_v4.v;
iverilog -Wall -g 2012 -s multiplier_pipelined_tb -o mul_pipe_tb5 multiplier_pipelined_tb.v multiplier_pipelined_v5.v;

echo "Pipelined Multiplier Compilation Success"

./mul_pipe_tb0;
./mul_pipe_tb1;
./mul_pipe_tb2;
./mul_pipe_tb3;
./mul_pipe_tb4;
./mul_pipe_tb5;

echo "Pipelined Multiplier Test Complete"

iverilog -Wall -g 2012 -s register_file_tb -o regfile_tb_random0 register_file_tb_random.v register_file_v0.v;
iverilog -Wall -g 2012 -s register_file_tb -o regfile_tb_random1 register_file_tb_random.v register_file_v1.v;
iverilog -Wall -g 2012 -s register_file_tb -o regfile_tb_random2 register_file_tb_random.v register_file_v2.v;
iverilog -Wall -g 2012 -s register_file_tb -o regfile_tb_random3 register_file_tb_random.v register_file_v3.v;

echo "Random Regfile Compilation Complete"

./regfile_tb_random0
./regfile_tb_random1
./regfile_tb_random2
./regfile_tb_random3

echo "Random Regfile Test Complete"

iverilog -Wall -g 2012 -s register_file_tb_simple -o regfile_tb_simple0 register_file_tb_simple.v register_file_v0.v;
iverilog -Wall -g 2012 -s register_file_tb_simple -o regfile_tb_simple1 register_file_tb_simple.v register_file_v1.v;
iverilog -Wall -g 2012 -s register_file_tb_simple -o regfile_tb_simple2 register_file_tb_simple.v register_file_v2.v;
iverilog -Wall -g 2012 -s register_file_tb_simple -o regfile_tb_simple3 register_file_tb_simple.v register_file_v3.v;

echo "Simple Regfile Compilation Complete"

./regfile_tb_simple0
./regfile_tb_simple1
./regfile_tb_simple2
./regfile_tb_simple3

echo "Simple Regfile Test Complete"