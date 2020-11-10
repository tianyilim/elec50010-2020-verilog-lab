module ff(
    input logic ce,
    input c,
    input logic d,
    output logic q
);
    // Changed sensitivity list to only reflect posedge clk!
    always_ff @(posedge c) begin
        if (ce==1) begin
            q <= d; // Sequential assignment
        end
    end

endmodule