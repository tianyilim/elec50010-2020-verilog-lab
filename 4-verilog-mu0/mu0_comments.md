## MU0 Simulator Comments

| Instruction | Opcode |
|:-----------:|:------:|
| LDA         | 0x0    |
| STO         | 0x1    |
| ADD         | 0x2    |
| SUB         | 0x3    |
| JMP         | 0x4    |
| JGE         | 0x5    |
| JNE         | 0x6    |
| STP         | 0x7    |
| OUT         | 0x8    |

1. MU0 Verilog Code
   1. `RAM_16x4096_delay0`
      1. Instanstiates a vector of 4096 16-bit busses as `reg` and performs the Read operation combinatorially via a Mux, and the Write operation sequentially through a `if` qualifier.
      2. Loads the content of RAM the `RAM_INIT_FILE` parameter. This can be changed to the filepath of the eventual MIF. If there is no initialization file, the RAM initializes as all zeros.
   2. `RAM_16x4096_delay1`
      1. Similar to before, except that the read path is also sequential instead of combinatorial.
   3. `RAM_countdown_delay0`
      1. Hardcodes the 6-instruction "Countdown" benchmark program. Useful to debug memory read issues with the MU0 as it removes the possibility that RAM is the broken component.
      2. Also returns errors if unexpected addresses are read from, or if a writes are attempted.
      3. This "hardcoded" so it is a useful debugging tool for the decoding / control path side of the CPU.
   4. `CPU_MU0_delay0`
      1. Use of `enums` to more clearly express what is meant by otherwise arbitrary hexadecimal numbers, simplifying the programming process.
      2. All the instructions and data should come from the `readdata` port, externally connected to the relevant RAM module.
      3. Decode portion is implemented as a few combinatorial muxes:
         1. If in FETCH, fetch from PC. Otherwise, read from the relevant memory address speccified in the instruction.
         2. Only pull the Write Enable bit to RAM high during a STO instruction. This allows us to always set the value of the `writedata` port as the value of the accumulator as it should not affect the value written to RAM otherwise.
         3. Only pull the Read Enable bit to RAM high during instructions where data is required from RAM: LDA, ADD, SUB. This data should then appear on the `readdata` port "instantly" as it is a combinatorial read RAM.
         4. Sequentially declare the behaviour of all instructions. These should always happen an EXEC state.
         5. Use of case-switch statements avoids unnecessary nested if-else statements. However, no default case to catch unexpected errors in instruction.
         7. Catch unexpected errors in CPU state with a `else` block for checking state.
         8. Use of the HALTED state to denote the startup and stop states for the CPU.
   5. `CPU_MU0_delay0_tb`
      1. Hierarchical design allows us to pass parameters on to sub-modules, simplifying the test process. In this case, a program is prespecified to be loaded into the delay0 RAM.
      2. Immediately resets the CPU and checks for a heartbeat (debug `running` output)
      3. Usage of a timeout counter so that CPU simulation does not carry on forever
   6. `CPU_MU0_delay1`
      1. Now there are two additional states: `FETCH_INSTR_DATA`: fetching the data from an instruction (as per LDA, ADD, SUB) and `EXEC_INSTR_ADDR`: a wait state for the RAM to output the correct data on the `readdata` bus. This would be analogous to the EXEC1 and EXEC2 states in the case of a 3-cycle instruction.
      2. CPU state always (somewhat inefficiently) cycles from `FETCH_INSTR_ADDR` > `FETCH_INSTR_DATA` > `EXEC_INSTR_ADDR` > `EXEC_INSTR_DATA`. Each instruction thus takes 4 cycles.
      3. Otherwise, the CPU is setup in a similar way as the delay1 CPU.
   7. `CPU_MU0_delay1_tb`
      1. Similar to the delay1 CPU testbench, as both CPUs look similar from the outside, bar the additional two cycles that this CPU requires.
2. Benchmark Test Code
   1. Fibonacci
      1. Implements Fibonacci iteratively (of course) by there being a TOP code block that serves as a countdown - when the accumulator value reaches 0, all loops are complete.
      2. The Prev, Curr and Next numbers are stored as variables as well. This implements the fib_n = fib_(n-1) + fib_(n-2) functionality.
      3. After the addition is performed, the variables change places. Curr = Prev, Next = Curr in preparation for the next loop.
      4. A `ONE` constant is added as a variable as there is no Immediate instruction.
   2. Multiply
      1. Similarly, multiplication is handled iteratively as repeatedly adding the multiplicand by (multiplier) times. A `TOP` code block handles the loop by observing the number of times the multiplicand has been added (countdown multiplier times)
      2. A `NEG_ONE` constant is added as a variable as there is no Immediate instruction.
   3. Countdown
      1. Counts down from a value by iterating and subtracting from it.
3. Assembler C++ Code
   1. The function of the assembler is to convert text-based programs into hex program files for loading into the MU0.
   2. The `to_hex` function converts an integer into a 4-digit hexadecimal string.
      1. It seems like it is encoded in the Big-endian format. (MSB corresponds to the first character)
      2. Creates a temporary array of characters, their indices corresponding to the respective hex character. Then, bit shifts and bit masks (`&0xFF`) are used to only select the relevant 4-bit slices of the integer.
      3. These 4-bit slices are used as indices in the temporary array to select the corresponding hex character that represents the relevant 4 bits.
   3. The assembler reads the input file via `cin`. It checks firstly for program label declarations (), asserting that 
   4. 
4. Disassembler C++ Code
5. MU0 Simulator C++ Code
6. Shell Scripts
   1. `build_utils`
   2. `run_all_testcases`
   3. `run_one_testcase`
   4. `run_all`
7. Extensions
   1. Supporting partial recompilation:
      1. Perhaps a more fleshed-out command line utility (analogous to `make`) would be useful, but the examples we are working with are rather small, so the time wasted in recompiling everything would not matter as much.
      2. Testing submodules could be done by writing individual testbenches for them, for instance the RAM. However, the MU0 is implemented as one entire module (control path and data path are both included together), so any debugging of each individual component would have to be done using `$display` statements.