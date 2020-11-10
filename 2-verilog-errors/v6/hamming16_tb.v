module hamming16_tb();
    

    logic[15:0] x;
    logic[4:0]  count;

    hamming16 dut(
        .x(x),
        .count(count)
    );

    /**
    - Both the test-bench and circuit were written by the same person. Why might this cause this type of error?
        oversight/assumptions
    - The circuit was written before the test-bench. Why might this cause this type of error?
        ????
    - The failure case is unlikely because it is rare. How might the test-bench be written to look for these cases?
        Print out the exact details of the error case
    - What is the advantage of this hierarchical composition style?
        Things are more clear to the end user instead of cluttering up the top level code
        Smaller things to debug sequentially
    - How might you adapt the test-bench and test approach for a 64-bit hamming circuit?
        Random generate some cases?
    **/

    integer i;
    logic[4:0] count_ref;   // Changed this to reference 
    initial begin
        $dumpfile("hamming16_tb.vcd");
        $dumpvars(0, hamming16_tb);
        
        x = 0;
        repeat (65535) begin
            /* Calculate reference count sequentially. Not synthesisable. */
            count_ref=0;
            for (i=0; i<16; i++) begin
                count_ref = count_ref + x[i];
            end

            #1; /* Wait 1 time unit */

            assert(count == count_ref) else begin
                $fatal(1, "Mis-match : x=%b, count=%d, count_ref=%d", x, count, count_ref);
            end

            x = x+1;
        end
    end


endmodule