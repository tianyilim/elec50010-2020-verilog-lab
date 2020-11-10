module ff(
    input logic clock,
    input logic d,
    output logic q
);
    // Error - use posedge_clock
    always_ff @(posedge clock) begin
        q <= d;
    end

endmodule