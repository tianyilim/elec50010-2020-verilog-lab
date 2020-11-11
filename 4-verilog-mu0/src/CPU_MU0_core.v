// Core shared code for all MU0 interpretations
/*
STP 0111 stop
JNE S 0110 if ACC ≠ 0, PC := S
JGE S 0101 if ACC > 0, PC := S
JMP S 0100 PC := S
SUB S 0011 ACC := ACC – mem[S]
ADD S 0010 ACC := ACC + mem[S]
STO S 0001 mem[S] := ACC
LDA S 0000 ACC := mem[S]
OUT S 1000 print(Acc)
*/

module CPU_MU0_core(
    input wire clk,                 // Set as explicit 
    input wire rst,
    input logic[15:0] instr,
    input logic[15:0] readdata,
    input logic read_valid,         // readdata/readvalid means core implementation is state agnostic
    output logic running,           // debug output
    output logic[11:0] pc,
    output wire[15:0] writedata     // This is an explicit wire as it should definiely not be registered
    );

    /* Using an enum to define constants */
    typedef enum logic[3:0] {
        OPCODE_LDA = 4'd0,
        OPCODE_STO = 4'd1,
        OPCODE_ADD = 4'd2,
        OPCODE_SUB = 4'd3,
        OPCODE_JMP = 4'd4,
        OPCODE_JGE = 4'd5,
        OPCODE_JNE = 4'd6,
        OPCODE_STP = 4'd7,
        OPCODE_OUT = 4'd8
    } opcode_t;
    
    logic[15:0] acc;
    wire[11:0] pc_increment;
    assign pc_increment = pc + 1;

    opcode_t instr_opcode;
    logic[11:0] instr_constant;
    assign instr_opcode = instr[15:12];
    assign instr_constant = instr[11:0];

    assign writedata = acc;

    initial begin
        running = 0;
    end

    always @(posedge clk) begin
        if (rst) begin
            $display("CPU : INFO  : Core Resetting.");
            pc <= 0;
            acc <= 0;
            running <= 1;
        end else if (running & read_valid) begin
        // read_valid is a qualifier that is handled in specific implementation.
        // For cases where reading from RAM is not relevant, it is always asserted
        // so that the operations can continue.
            $display("CPU : INFO  : Core Executing opcode=%h, imm=%h, readdata=%x, acc=%d", instr_opcode, instr_constant, readdata, acc);
            case(instr_opcode)
                OPCODE_LDA: begin
                    acc <= readdata;
                    pc <= pc_increment;
                end
                OPCODE_STO: begin
                    // Writes handled combinatorially                    
                    pc <= pc_increment;
                end
                OPCODE_ADD: begin
                    acc <= acc + readdata;
                    pc <= pc_increment;
                end
                OPCODE_SUB: begin
                    acc <= acc - readdata;
                    pc <= pc_increment;
                end
                OPCODE_JMP: begin
                    pc <= instr_constant;
                end
                OPCODE_JGE: begin
                    if (acc > 0) begin
                        pc <= instr_constant;
                    end else begin
                        pc <= pc_increment;
                    end
                end
                OPCODE_JNE: begin
                    if (acc != 0) begin
                        pc <= instr_constant;
                    end else begin
                        pc <= pc_increment;
                    end
                end
                OPCODE_OUT: begin
                    $display("CPU : OUT   : %d", $signed(acc));
                    pc <= pc_increment;
                end
                OPCODE_STP: begin
                    $display("CPU : INFO  : Stopped.");
                    running <= 0;
                end
                default: begin
                    $display("CPU : ERROR : Processor read unexpected instruction %b", instr_opcode);
                    $finish;
                end
            endcase
        end
    end

endmodule