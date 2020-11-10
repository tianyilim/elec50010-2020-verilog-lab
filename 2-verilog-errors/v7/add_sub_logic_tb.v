module add_sub_logic_tb();
    logic[1:0] op;
    logic[15:0] a;
    logic[15:0] b;
    logic[15:0] r;

    initial begin
        $dumpfile("add_sub_logic_tb.vcd");
        $dumpvars(0, add_sub_logic_tb);

        /* op==0 */

        op=0; a=2; b=3;
        #1;
        assert(r==5);

        op=0; a=100; b=200;
        #1;
        assert(r==300);

        /* op==1 */

        op=1; a=10; b=5;
        #1;
        assert(r==5);

        op=1; a=100; b=200;
        #1;
        assert(r==16'hff9c);    // -100

        /* op==2 */

        op=2; a=7;  b=11;
        #1;
        assert(r==~16'd11); // Flip 11

        op=2; a=11; b=7;
        #1;
        assert(r==~16'd7);  // Flip 7

        /* op==3 */

        op=3; a=3; b=10;
        #1;
        assert(r==0);    // Checks if there is carry out (none)

        op=3; a=10; b=3;
        #1;
        assert(r==1);    // There is carry out
    end

    add_sub_logic dut(
        .op(op),
        .a(a),
        .b(b),
        .r(r)
    );

endmodule