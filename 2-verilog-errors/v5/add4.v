module add4(
    input logic[3:0] a,
    input logic[3:0] b,
    input logic cin,
    output logic[3:0] sum,
    output logic cout
);
    wire logic[4:0] carry;  
    // Index of bus is wrong way around, LSB <- 0
    // Build up add32 using add4 -> add16 blocks
    // The strategy might still work for add32 given that the code is not hardcoded.
    // However it takes a lot of computational time, lots of cases to test for

    assign carry[0] = cin;
    fadd fadd3(a[0],b[0],carry[0],sum[0],carry[1]);
    fadd fadd2(a[1],b[1],carry[1],sum[1],carry[2]);
    fadd fadd1(a[2],b[2],carry[2],sum[2],carry[3]);
    fadd fadd0(a[3],b[3],carry[3],sum[3],carry[4]);
    assign cout = carry[4];

endmodule