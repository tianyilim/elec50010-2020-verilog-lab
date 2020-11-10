module ff_tb();
    logic clk;
    logic clock_enable;
    logic d;
    logic q;

    initial begin
        $dumpfile("ff_tb.vcd");
        $dumpvars(0, ff_tb);
        
        clk = 0;
        d = 1;
        clock_enable = 1;
        #4;

        /* rising edge */
        clk = 1;
        #1;
        assert(q==1);
        #1;
        d=0;          /* Change the register input to 0. */
        #1;
        assert(q==1);   // Should be 0 here
        d=1;          
        #1;
        assert(q==1);   // Should be 1 here

        /* falling edge */
        clk = 0;
        #1;
        assert(q == 1); 
        #1;
        d=0;         
        #1;
        assert(q==1); 
        d=0;          
        #1;
        assert(q==1); 

        /* rising edge */
        clk = 1;
        #1;
        assert(q == 0);
        #1;
        d=1;         
        #1;
        assert(q==0); 
        d=1;          
        #1;
        assert(q==0); // Changed to 0 here - no rising edge so can't overwrite


        $finish;
    end

    ff dut(
        clock_enable,clk,d,q
    );

endmodule