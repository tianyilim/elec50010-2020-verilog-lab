## Lab 3 Comments
The comments here are just a consolidation of what I found when reading the code in Lab 3. I would suggest having the code open in a neighbouring tab for reference.

1. `Multiplier_Iterative`
    1. Testbench
       - Runs the clock for 10000 times and exits with failure if no success code previously output, so that testbench will exit automatically if something goes (very) wrong.
       - Performs timing analysis for squaring numbers from `i=1` to `i=100`, by reporting the time taken for 100 square calculations to be done.
       - Performs correctness analysis for large numbers, iterating multiplier operands `a` and `b` separately by big values (overflow is intentional)
       - Outputs out the time taken for both portions of the anaylsis.
       - Fails fatally if the calculated value differs from the expected value (using `a*b` calculated using the computer)
       - Does **NOT** check for improper/sudden assertion of `valid_in` signal before `valid_out` has been asserted, (effectively "interrupting" the multiplier)
    2. v0, Total time = 135996
        - Uses two hardware flags `valid_in` and `valid_out` for external communication and synchronization. 
        - If the `valid_in` flag is set, the multiplier updates the multiplier and multiplicand registers. This is allowed to overwrite the current multiplier and multiplicand registers while a calculation is in progress.
        - If the `valid_out` flag is set, this signifies that the calculation is complete. This happens after 32 iterations, and there is a tracking variable `i` for this.
        - When `i==32`, no further calculation is performed, so the results calculated stay valid until a new calculation is requested.
        - Iteratively shifts the multiplier and multiplicand left and right respectively in the `always @ (*)` block. If the LSB of the current multiplier is 1, then we add the current value of the multiplicand to an accumulator.
        - This process always terminates after 32 iterations, regardless of the multiplier.
    3. v1, Total time = 84116
        - Optimises the multiplication process by checking if the multiplier has been equal to 0. In that case the process terminates early, slightly optimising the process.
    4. v2, Total time = 29556
       - Divide and Conquer algorithim in play here. Instead of shifting the multiplier one bit by one bit, we see that the algorithim shifts four bits at a go. 
       - The Verilog `*` operator is used to multiply these four-bit chunks of the multiplier with the multiplicand, and then add to the accumulator.
       - This requires more resources of course, but speeds up the operation fourfold when compared to the v1.
    5. v3, Total time = 7996
       - Uses the Verilog `*` operator to output the result after one clock cycle. The result of multiplication is output one cycle after the inputs are given.
       - However, as there is no write enable, the result of multiplication is lost after the inputs are no longer applied.
2. `Multiplier_Parallel`
   1. Testbench
      - No Timing analysis built-in, only has correctness testing built in
      - In addition, there are no source files that fit the naming convention.
3. `Multiplier_Pipelined`
   1. Testbench
      - Uses `LOCALPARAM` that allows quick adjustment of testbench parameters with the change of 1 variable
      - There is an additional delay in the pipelined multiplier architecture, which necessitates an extra delay to be factored in within the testbench.
   2. v0
      - Uses the Verilog `*` operator as in `Multiplier_iterative_v3`, but outputs the result of the multiplication into another register, further delaying the output by 1 cycle. This should reduce critical path (and thus increase theoretical clock speed).
      - Lets new outputs come in simultaneously as old results are read, thus it is considered "pipelined". 
   3. v1
      - Instead of taking the multiplication of the two 32-bit numbers at once, the multiplication is performed on slices of the multiplicand. This divide-and-conquer method reduces the overall complexity and hardware required in the circuit.
      - 8*32 multiplier -> 40-bit products.
   4. v2
      - The bit slicing is different as in v1, taking the high and low slices of the multiplier and multiplicand and multiplying them with each other.
      - 16*16 multiplier -> 32-bit products.
   5. v3
      - Register placement in v3 is different as in v2, although methodology is largely similar:
      - v2 places individual multiplication results and final addition results in a register.
      - v3 places the inputs and final addition results in a register.
      - This is an optimization because the multiplication path is likely to be combinatiorial, which means that there is not much benefit in adding a register to that.
   6. v4
      - Similar in concept to v2 and v3, but further splits the operands into three banks instead of two.
      - Splits along bits 31:22, 21:11, and 10:0 (11, 11, 10 bits respectively)
      - This "flattens" the circuit more, having more lower-bit logic units compared to a single higher-bit logic units.
   7. v5
      - Generates a array of logic bits, 33*64 bits wide for each operand.
      - Lots of combinational logic that implements the shift/add multiplication in parallel (and understandably adds a lot of area).
4. `Register File`
   1. Random Testbench
      - Two `LOCALPARAMS` are used, one for test cycles and one for timeout (to exit the testbench if something has gone wrong)
      - Creates a `shadow` version of the regfile that is updated alongside the stimuli for the regfile, allowing for any given input to be checked. This is convenient because the inputs to the regfile are random and would change everytime the testbench is run.
      - Asserts are used at important points to check the correctness of the output.
   2. Simple Testbench
      - Naive testbench that manually toggles the clock and inputs. There are comparatively few inputs for this testbench and it might miss out some error cases.
   3. v0
      - Uses `always_comb` and `always_ff` sections to implement combinatorial and sequential parts.
      - Reading index is combinatorial and occurs in the `always_comb` section, and has different cases based on the different possible inputs: Reset HIGH, readaddress 0-3, and readadress undefined
      - Use of 16'hXXXX to define an undefined output.
      - Writing index is sequential an a series of muxes / ternary operators are used to implement this.
      - `value` either writes to 0 or an input value based on the Reset input.
      - `If` statements are used to choose between writing to a register or not.
   4. v1
      - A different coding style is used, using `case-switch` statements instead of `if-else`.
      - Note that for there is no default case for the reading operation now - the behaviour of the module when the inputs are undefined is not certain.
   5. v2
      - Use of a `for` loop to implement the Reset sequence. This would be a compact way of expressing resets especially with larger register files.
      - Using array indexing to read and write regfile values.
      - This would be a convenient way to index arrays of busses.
   6. v3
      - Beautiful use of ternary operators / muxes to express the regfile functionality
      - Using a ternary operator to express writing to regfile - if `write_enable` is low, then write the current value of the register back to itself.
5. Shell Scripts _(Not complete, update if you find a better solution)_
   ```bash
   #!/bin/bash

   echo "Begin iterative test"
   #compiles and elaboration of multiplier_iterative_v0
   MAX_ITER=5
   for i in {0..$MAX_ITER}
   do
      iverilog -Wall -g 2012 -s multiplier_iterative_tb -o multiplier_iterative_tb multiplier_iterative_tb.v multiplier_iterative_v$i.v 
      if ./multiplier_iterative_tb > log.txt; then
         echo "v$i test success"
      else
         echo "v$i test failed"
      fi
   done
   ```
   - Can use this form of testing, which is fairly portable and reusable.
   - Loops through the different iterative multiplier versions using the for loop, which is parameterized using the `MAX_ITER` variable.
   - Pipes the output of the script into a log file so as not to clog up the terminal screen, only showing if the test passed or failed.
   - Future extension: to pipe the total timing (and other important testing metrics) out onto `stderr` (and onto the terminal) for easier reference after test completion, so that test architectures can be compared with just a glance.

   - _Section credit: if's: Siyu, for's: Joshua_