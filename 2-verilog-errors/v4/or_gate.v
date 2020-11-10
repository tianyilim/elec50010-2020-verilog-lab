module or_gate(
    input logic a,
    input logic b,
    output logic r
);

    // Using an always block also does not help
    // Solution: Always assign r on both branches of code.
    always_comb begin
        r = 0;

        if (a==1 && b==1) begin
            r = 1;
        end else if (a==1) begin
            r = 1;
        end else if (b==1) begin
            r = 1;
        end
    end

endmodule