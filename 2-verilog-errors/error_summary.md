## Summary of errors found in Lab 2
- v1
    - Bit width of testbench does not match that of the DUT
    - Compiler gives error for bit width mismatch
    - Avoid error by enabling `-Wall` on the iverilog compiler
    - At design stage, read problem and understand it beforehand

- v2
    - Use of `always_ff @ (posedge CLK)` to specify that module is synchronous, else a latch is inferred

- v3
    - Changed the sensitivity list from `always @ (d or c)` to `always_ff @ (posedge c)`.
    - Poor style in DUT: 
        - using `always` instead of `always_ff`
        - Using the variable `c` instead of `CLK` is misleading
    - Poor style in Testbench:
        - Use a independent `initial` block to setup Clock signal:
        ```verilog
        initial begin 
            forever begin
            clk = 0;
            #10 clk = ~clk;
            end
        end
        ```
        - Instead of using timing offsets `#1`, use `@posedge CLK` or `@negedge CLK`.

- v4
    - Compiler does not highlight the error
    - Missing `else` statements in the DUT, so the output will never be reset to 0.
    - If trying `always begin` there will be a compile-time error because there is no sensitivity list, and thus would synthesize an infinite loop
    - It's called `or_gate` because `or` is a reserved Verilog keyword.
    - Use the `|` (bitwise) or `||` (logical) operator for clarity.

- v5
    - Error: the MSB and LSB indexing is reversed in `add4.v`.
    - Recursively build up larger components. For instance, make out a `add8` module out of `add4` modules, and `add32` modules out of that.
    - Yes, but it will take a long time. ${2^32}$ cases.
    - So perhaps test lowest end, high end, and transition points
    - Alternatively, test different intervals of the test cases briefly (eg 128 times) and see if any of the slices fail.

- v6
    - Bit width in the `hamming16_tb.v` and `hamming16.v`.
    - Same person writing the testbench and DUT means same perspective and assumptions.
    - To circumvent this, write the testbench before the circuit so that you know what to expect from the output.
    - To find these cases, we need to look at the edge cases, so that we know the circut works at extremes.
    - Add more `$display` statements!
    - Things are more clear to the end user instead of cluttering up the top level code
    - Smaller things to debug sequentially
    - To test the 64-bit Hamming, we should specifically look out for the high and low ranges of the input set, and the transition case where 32-bit Hamming components break down (and test this recursively to ensure the 32-bit case works, and the 16-bit, and the 8-bit...)

- v7
    - The assertions in the testbench are wrong.
    - How to debug:
    - 1. First, understand the functionality of the DUT.
    - 2. Next, look at the testbench to figure out what it is testing
    - 3. Ascertain that the assertions by the testcases are indeed correct (in this case, most of them were wrong).
    - Values of `a` and `b` that are worth testing:
      - Large/Small +ve/-ve numbers, and test addition and subtraction
    - Interesting inputs for opcode 3:
      - Cases for overflow:
      - eg: `FFFF`, `0000`, `7FFF`, `8000` (basically - values in middle, or at the extremes.)